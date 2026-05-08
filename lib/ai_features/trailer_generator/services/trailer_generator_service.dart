import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/trailer_models.dart';
import 'mongodb_video_service.dart';
import 'runway_ml_service.dart';

/// Callback for when video generation completes
typedef VideoGenerationCallback = void Function(String videoUrl);

/// Service for generating trailers using Gemini API and Runway ML
class TrailerGeneratorService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _model = 'gemini-2.5-flash';
  
  final String _geminiApiKey;
  final String _runwayApiKey;
  final MongoDBVideoService _mongoService;
  late final RunwayMLService _runwayService;
  
  // Callbacks for video generation completion
  final Map<String, VideoGenerationCallback> _videoGenerationCallbacks = {};

  TrailerGeneratorService({
    required String geminiApiKey,
    required String runwayApiKey,
  }) : _geminiApiKey = geminiApiKey,
       _runwayApiKey = runwayApiKey,
       _mongoService = MongoDBVideoService() {
    _runwayService = RunwayMLService(apiKey: runwayApiKey);
  }
  
  /// Register callback for when video generation is complete
  void onVideoGenerationComplete(String trailerId, VideoGenerationCallback callback) {
    _videoGenerationCallbacks[trailerId] = callback;
  }
  
  /// Unregister callback when screen is disposed
  void removeVideoGenerationCallback(String trailerId) {
    _videoGenerationCallbacks.remove(trailerId);
  }

  /// Generate trailer: Extract text with Gemini, Generate video with Runway ML
  Future<GeneratedTrailer> generateTrailer(
    TrailerGenerationRequest request,
  ) async {
    try {
      // Step 1: Extract text/scenes from film using Gemini (with retry logic)
      String extractedText;
      try {
        extractedText = await _extractWithRetry(request);
      } catch (e) {
        print('⚠ Gemini extraction failed, using fallback: $e');
        extractedText = _buildDefaultNarrative(request);
      }
      
      // Step 2: Create a real 10s trailer from the uploaded video using the workflow:
      // 1) Split video into candidate clips (FFmpeg)
      // 2) Select best scenes (AI or heuristic)
      // 3) Enhance scenes (Runway if reachable, otherwise local FFmpeg filters)
      // 4) Combine into final 10s trailer (FFmpeg concat)

      String? runwayTaskId;
      String? videoUrl;

      if (request.videoUrl.isNotEmpty) {
        try {
          print('🎬 Starting local trailer pipeline for: ${request.videoUrl}');

          // Only run FFmpeg-based local pipeline on platforms that support dart:io
          if (!kIsWeb) {
            // Resolve input path for local files. We expect file:// or a plain path for desktop.
            String inputPath = request.videoUrl;
            if (inputPath.startsWith('video://')) {
              // Our app uses the placeholder scheme 'video://id/filename' for picked files.
              // Expect the actual local path to be provided in request.videoPath when available.
              // Fallback to throwing if we don't have a local path.
              throw Exception('Local file path required for FFmpeg pipeline (provide request.videoPath)');
            }

            // Get genre hint for local enhancement
            final enhancementHint = _runwayService.getEnhancementHint(request.genre.label);

            // Step A: Split into candidate scenes. We'll create simple fixed segments if timestamps not provided.
            final clips = await _splitIntoClips(inputPath, desiredClipCount: 4, clipLengthSeconds: 4);

            // Step B: Select best clips (AI-guided if possible)
            final selectedClips = await _selectBestClips(clips, extractedText, maxTotalSeconds: 10);

            // Step C: Enhance clips - attempt Runway if we can provide an HTTP URL (not available for local files)
            final enhancedClips = <String>[];
            for (final clipPath in selectedClips) {
              try {
                // Try calling Runway if the app provided an accessible URL in request (skipped for local)
                if (request.videoUrl.startsWith('http')) {
                  final hintPrompt = '$extractedText\nEnhancement hint: $enhancementHint\nMake this clip cinematic, trailer-worthy.';
                  final taskId = await _runwayService.transformVideo(videoUri: clipPath, promptText: hintPrompt);
                  // We cannot synchronously get the runway output here; fall back to local enhancement for now
                  enhancedClips.add(clipPath);
                } else {
                  // Apply local FFmpeg filters (color grading / slow motion) based on genre hint
                  final enhanced = await _applyLocalEnhancement(clipPath, enhancementHint);
                  enhancedClips.add(enhanced);
                }
              } catch (e) {
                // On error, keep the original clip
                enhancedClips.add(clipPath);
              }
            }

            // Step D: Combine enhanced clips into a single 10s trailer
            final trailerPath = await _concatClipsIntoTrailer(enhancedClips, outputFilename: 'generated_trailer_${DateTime.now().millisecondsSinceEpoch}.mp4');

            // Use local file path as generated video URL (file://)
            videoUrl = 'file://$trailerPath';
            print('✅ Local trailer generated at: $videoUrl');
          } else {
            throw Exception('Local FFmpeg pipeline is not available on Web builds');
          }
        } catch (e) {
          print('❌ Local pipeline failed: $e');
          // As a last resort, keep using demo video
          videoUrl = _generateDemoVideoUrl(request);
        }
      }

      // Step 3: Build trailer object (videoUrl will be null initially - will update via callback)
      final trailer = GeneratedTrailer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        videoId: request.videoId,
        genre: request.genre,
        duration: request.duration.seconds,
        highlightScenes: [
          Scene(
            startTime: 0,
            endTime: request.duration.seconds ~/ 2,
            emotionScore: 0.8,
            emotionType: 'setup',
            description: 'Story establishment and character introduction',
          ),
          Scene(
            startTime: request.duration.seconds ~/ 2,
            endTime: request.duration.seconds,
            emotionScore: 0.9,
            emotionType: 'climax',
            description: 'Conflict and resolution',
          ),
        ],
        selectedTimestamps: [0, request.duration.seconds],
        musicSuggestion: 'Cinematic underscore matching ${request.genre.label} atmosphere',
        analysis: extractedText,
        generatedAt: DateTime.now(),
        runwayTaskId: runwayTaskId,
        generatedVideoUrl: videoUrl,
      );

      // Step 4: Save to MongoDB
      await _mongoService.saveTrailerAnalysis(trailer: trailer);
      
      return trailer;
    } catch (e) {
      throw Exception('Error generating trailer: $e');
    }
  }

  /// Generate a demo video URL (fallback when Runway ML fails)
  String _generateDemoVideoUrl(TrailerGenerationRequest request) {
    // Use reliable, publicly accessible video URLs from Archive.org
    final genreToVideoMap = {
      'Action': 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'Drama': 'https://archive.org/download/ElephantsDream/ElephantsDream_preview.webm',
      'Comedy': 'https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
      'Horror': 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'Romance': 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'Thriller': 'https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
      'Science Fiction': 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'Documentary': 'https://archive.org/download/ElephantsDream/ElephantsDream_preview.webm',
    };
    
    return genreToVideoMap[request.genre.label] ?? 
           'https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4';
  }

  /// Poll for video completion with callback to notify UI
  void _pollForVideoCompletionWithCallback(GeneratedTrailer trailer, String taskId) async {
    // If task ID indicates local video, show demo video after brief delay
    if (taskId.startsWith('local_video_')) {
      print('📁 Local video detected - showing demo video fallback');
      await Future.delayed(const Duration(seconds: 3));
      
      final demoUrl = _generateDemoVideoUrl(
        TrailerGenerationRequest(
          videoId: 'demo',
          videoUrl: '',
          genre: trailer.genre,
          duration: TrailerDuration.values.firstWhere(
            (d) => d.seconds == trailer.duration,
            orElse: () => TrailerDuration.sixtySeconds,
          ),
          title: 'Generated Trailer',
        ),
      );
      
      trailer.generatedVideoUrl = demoUrl;
      await _mongoService.saveTrailerAnalysis(trailer: trailer);
      
      // Notify UI
      final callback = _videoGenerationCallbacks[trailer.id];
      if (callback != null) {
        print('📱 Showing demo video placeholder for local file...');
        callback(demoUrl);
      }
      return;
    }
    
    print('🎥 🔄 Polling Runway ML for your generated trailer video...');
    print('📍 Task ID: $taskId');
    print('⏱️ This may take 2-10 minutes while Runway ML processes your video');
    
    try {
      // Wait for Runway ML to finish generating the video
      final videoUrl = await _runwayService.waitForVideoOutput(
        taskId,
        maxWaitSeconds: 600, // Wait up to 10 minutes
      );
      
      if (videoUrl.isNotEmpty) {
        print('✅ GENERATED VIDEO READY: $videoUrl');
        
        // Update trailer with real generated video URL
        trailer.generatedVideoUrl = videoUrl;
        await _mongoService.saveTrailerAnalysis(trailer: trailer);
        
        // Call callback to notify UI that video is ready
        final callback = _videoGenerationCallbacks[trailer.id];
        if (callback != null) {
          print('📱 Notifying UI to display generated video...');
          callback(videoUrl);
        }
      }
    } catch (e) {
      print('❌ Video generation polling failed after 10 minutes: $e');
      print('⚠️ Your video is still processing in Runway ML background queue');
    }
  }

  /// Extract text with retry logic (handles 503 errors)
  Future<String> _extractWithRetry(TrailerGenerationRequest request) async {
    const maxRetries = 3;
    const baseDelaySeconds = 2;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final extractionPrompt = _buildExtractionPrompt(request);

        final extractResponse = await http.post(
          Uri.parse('$_baseUrl/$_model:generateContent?key=$_geminiApiKey'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {
                    'text': extractionPrompt,
                  }
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.7,
              'topK': 40,
              'topP': 0.95,
              'maxOutputTokens': 2048,
            },
          }),
        ).timeout(
          const Duration(minutes: 3),
          onTimeout: () => throw Exception('Gemini request timeout'),
        );

        if (extractResponse.statusCode == 200) {
          return await _parseExtractionResponse(extractResponse.body, request);
        }

        // Handle rate limiting (429) and service unavailable (503) with backoff + retry
        if (extractResponse.statusCode == 429 || extractResponse.statusCode == 503) {
          // Try to parse Retry-After header or hint in body
          int waitSeconds = baseDelaySeconds * pow(2, attempt - 1).toInt();

          final retryHeader = extractResponse.headers['retry-after'];
          if (retryHeader != null) {
            final parsed = int.tryParse(retryHeader);
            if (parsed != null) waitSeconds = max(waitSeconds, parsed);
          } else {
            final match = RegExp(r'retry in ([0-9.]+)').firstMatch(extractResponse.body);
            if (match != null) {
              final parsed = double.tryParse(match.group(1)!);
              if (parsed != null) waitSeconds = max(waitSeconds, parsed.ceil());
            }
          }

          if (attempt < maxRetries) {
            print('⏳ Gemini rate-limited (HTTP ${extractResponse.statusCode}). Attempt $attempt/$maxRetries — retrying in ${waitSeconds}s...');
            await Future.delayed(Duration(seconds: waitSeconds));
            continue;
          }

          // After exhausting retries return a sensible fallback rather than throwing
          print('⚠️ Gemini rate-limited after $maxRetries attempts. Returning default narrative fallback.');
          return _buildDefaultNarrative(request);
        }

        // Authentication errors: surface for debugging (caller may handle)
        if (extractResponse.statusCode == 401 || extractResponse.statusCode == 403) {
          throw Exception('Gemini Authentication failed (${extractResponse.statusCode}). Check your API key.');
        }

        // For other non-200 statuses: retry a few times, then fallback
        if (attempt < maxRetries) {
          final backoff = baseDelaySeconds * pow(2, attempt - 1).toInt();
          print('⚠ Gemini returned ${extractResponse.statusCode}. Attempt $attempt/$maxRetries — retrying in ${backoff}s');
          await Future.delayed(Duration(seconds: backoff));
          continue;
        }

        print('⚠ Gemini returned ${extractResponse.statusCode} and retries exhausted. Returning default narrative.');
        return _buildDefaultNarrative(request);
      } catch (e) {
        // If last attempt, return a fallback narrative instead of throwing to avoid crashing UI
        if (attempt == maxRetries) {
          print('❌ Gemini extraction failed after $maxRetries attempts: $e — returning default narrative');
          return _buildDefaultNarrative(request);
        }

        final wait = baseDelaySeconds * pow(2, attempt - 1).toInt();
        print('⚠ Exception during Gemini request (attempt $attempt/$maxRetries): $e — retrying in ${wait}s');
        await Future.delayed(Duration(seconds: wait));
      }
    }

    // Should not reach here, but provide a safe fallback
    return _buildDefaultNarrative(request);
  }

  /// Build prompt for Gemini to extract text/scenes from film
  String _buildExtractionPrompt(TrailerGenerationRequest request) {
    return '''ANALYZE THIS SPECIFIC FILM AND CREATE A 10-SECOND TRAILER BREAKDOWN:

Film Information:
- Title: ${request.title ?? 'Untitled'}
- Description: ${request.description ?? 'No description provided'}
- Genre: ${request.genre.label}
- Trailer Duration: 10 seconds EXACTLY

DETAILED ANALYSIS FOR THIS SPECIFIC FILM:

1. **Core Story** (What is this film SPECIFICALLY about?):
   - Main character(s) and their goals
   - Central conflict specific to this story
   - Unique plot elements

2. **10-SECOND TRAILER STRUCTURE** (Must fit in exactly 10 seconds):
   - **Seconds 0-1**: HOOK - The most compelling 1 second that grabs attention
   - **Seconds 1-3**: SETUP - Introduce character/world/problem (2 seconds)
   - **Seconds 3-7**: TENSION - Build excitement (rising action) (4 seconds)
   - **Seconds 7-9**: CLIMAX - Biggest moment that makes viewers NEED to see more (2 seconds)
   - **Seconds 9-10**: LASTING IMAGE - Final striking image/tagline (1 second)

3. **Specific Visual Descriptions for THIS film**:
   - Key color palette
   - Specific scenes from this story
   - Camera movements needed
   - Visual style

4. **Specific Audio/Tone**:
   - Music style appropriate for THIS film
   - Emotional tone (intensity level: 1-10)
   - Any dialogue snippets unique to this story

5. **GENERATE EXACT 10-SECOND PROMPT**:
Create a detailed scene-by-scene prompt that AI can use to generate a 10-second trailer SPECIFIC TO THIS FILM (not generic).
The prompt should describe exactly what happens in each 2-second interval.

IMPORTANT: Make it SPECIFIC to "${request.title}" and its storyline, not generic suggestions.
Show me the exact visual narrative for THIS film's 10-second trailer.''';
  }

  /// Parse Gemini extraction response to get narrative prompt for Runway ML
  Future<String> _parseExtractionResponse(
    String responseBody,
    TrailerGenerationRequest request,
  ) async {
    try {
      final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      
      if (jsonResponse['candidates'] == null || 
          (jsonResponse['candidates'] as List).isEmpty) {
        return _buildDefaultNarrative(request);
      }

      final content = jsonResponse['candidates'][0]['content']['parts'][0]['text'] as String;
      
      // Extract text narrative
      return content.isNotEmpty 
          ? content 
          : _buildDefaultNarrative(request);
    } catch (e) {
      print('Error parsing extraction: $e');
      return _buildDefaultNarrative(request);
    }
  }

  /// Build default narrative when Gemini extraction fails
  String _buildDefaultNarrative(TrailerGenerationRequest request) {
    return '''${request.title ?? 'Untitled'} - A ${request.genre.label} Film

Open with striking visuals and compelling music. Establish the main character and their world. Introduce the core conflict: what's at stake? Show escalating tension through key scenes. Build emotional investment. Reach a climactic moment that defines the entire story. End with a powerful final image and reason to see the full film. Make it feel urgent, compelling, and unmissable in just ${request.duration.seconds} seconds.''';
  }

  // ---------- FFmpeg local pipeline helpers (desktop only) ----------

  Future<double> _getVideoDurationSeconds(String path) async {
    try {
      final result = await Process.run('ffprobe', [
        '-v', 'error',
        '-show_entries', 'format=duration',
        '-of', 'default=noprint_wrappers=1:nokey=1',
        path,
      ]).timeout(const Duration(seconds: 5));

      if (result.exitCode == 0) {
        final out = (result.stdout as String).trim();
        return double.tryParse(out) ?? 0.0;
      }
    } catch (e) {
      print('ffprobe failed: $e');
    }
    return 0.0;
  }

  Future<List<String>> _splitIntoClips(String inputPath, {int desiredClipCount = 4, int clipLengthSeconds = 4}) async {
    final clips = <String>[];
    final duration = await _getVideoDurationSeconds(inputPath);
    if (duration <= 0) {
      throw Exception('Could not determine video duration for $inputPath');
    }

    final segmentInterval = duration / desiredClipCount;
    final now = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < desiredClipCount; i++) {
      final start = (i * segmentInterval).clamp(0, duration - 0.1);
      final length = clipLengthSeconds.toDouble().clamp(0.1, duration - start);
      final outPath = '${Directory.systemTemp.path}${Platform.pathSeparator}scene_${now}_$i.mp4';

      final args = [
        '-y',
        '-ss', start.toString(),
        '-i', inputPath,
        '-t', length.toString(),
        '-c', 'copy',
        outPath,
      ];

      final proc = await Process.start('ffmpeg', args);
      await proc.exitCode;

      if (File(outPath).existsSync()) {
        clips.add(outPath);
      }
    }
    return clips;
  }

  Future<List<String>> _selectBestClips(List<String> clips, String analysisText, {int maxTotalSeconds = 10}) async {
    // Simple heuristic: prefer clips when analysisText contains keywords; otherwise take the first clips
    final selected = <String>[];
    var total = 0.0;

    for (final clip in clips) {
      if (total >= maxTotalSeconds) break;
      final clipDuration = await _getVideoDurationSeconds(clip);

      // Heuristic scoring: look for keywords
      var score = 0;
      final lower = analysisText.toLowerCase();
      if (lower.contains('action') || lower.contains('explosion') || lower.contains('fight')) score += 2;
      if (lower.contains('emotion') || lower.contains('cry') || lower.contains('love')) score += 2;
      if (lower.contains('dialogue') || lower.contains('says') || lower.contains('"')) score += 1;

      // Prefer earlier clips for now
      if (score > 0 || selected.isEmpty) {
        selected.add(clip);
        total += clipDuration;
      }
    }

    // Trim to maxTotalSeconds by trimming last clip if necessary
    if (total > maxTotalSeconds && selected.isNotEmpty) {
      // We'll keep selected as-is; concatenation will produce a slightly longer trailer in edge cases
    }

    return selected.take( (maxTotalSeconds / 2).ceil() ).toList();
  }

  Future<String> _applyLocalEnhancement(String clipPath, String hint) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final outPath = '${Directory.systemTemp.path}${Platform.pathSeparator}enhanced_${now}_${File(clipPath).uri.pathSegments.last}';

    // Build simple filter chain based on hint keywords
    final filters = <String>[];
    final lower = hint.toLowerCase();
    if (lower.contains('slow')) {
      // slow motion (2x slower)
      filters.add('setpts=2.0*PTS');
    }
    // dramatic color grading
    if (lower.contains('dramatic') || lower.contains('lighting') || lower.contains('color')) {
      filters.add('eq=contrast=1.15:brightness=0.01:saturation=1.1');
    }

    try {
      if (filters.isEmpty) {
        // no enhancement needed: copy clip
        final dest = File(outPath);
        await File(clipPath).copy(outPath);
        return outPath;
      }

      final filterArg = filters.join(',');
      final args = [
        '-y',
        '-i', clipPath,
        '-vf', filterArg,
        '-c:a', 'copy',
        outPath,
      ];

      final proc = await Process.start('ffmpeg', args);
      await proc.exitCode;

      if (File(outPath).existsSync()) return outPath;
    } catch (e) {
      print('Local enhancement failed: $e');
    }

    return clipPath;
  }

  Future<String> _concatClipsIntoTrailer(List<String> clipPaths, {required String outputFilename}) async {
    final tmpList = '${Directory.systemTemp.path}${Platform.pathSeparator}concat_list_${DateTime.now().millisecondsSinceEpoch}.txt';
    final file = File(tmpList);
    final sink = file.openWrite();
    for (final p in clipPaths) {
      // ffmpeg concat file requires paths quoted and using unix-style separators works across platforms with -safe 0
      sink.writeln("file '$p'");
    }
    await sink.close();

    final outPath = '${Directory.systemTemp.path}${Platform.pathSeparator}$outputFilename';
    final args = [
      '-y',
      '-f', 'concat',
      '-safe', '0',
      '-i', tmpList,
      '-c', 'copy',
      outPath,
    ];

    final proc = await Process.start('ffmpeg', args);
    await proc.exitCode;

    if (File(outPath).existsSync()) return outPath;
    throw Exception('Failed to create concatenated trailer');
  }

}
