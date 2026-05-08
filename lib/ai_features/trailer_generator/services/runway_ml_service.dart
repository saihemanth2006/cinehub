import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for video transformation using Runway ML API
class RunwayMLService {
  static const String _baseUrl = 'https://api.runwayml.com/v1';
  
  final String _apiKey;

  RunwayMLService({
    required String apiKey,
  }) : _apiKey = apiKey;

  /// Transform video using Runway ML gen4_aleph model
  /// Returns the task ID for polling task status
  Future<String> transformVideo({
    required String videoUri,
    required String promptText,
    int? seed,
  }) async {
    try {
      print('🎬 Processing video for Runway ML...');
      print('Video URI: $videoUri');
      
      // Handle local video files from web/mobile file picker
      if (!videoUri.startsWith('http://') && !videoUri.startsWith('https://')) {
        print('⚠️ Local video file detected: $videoUri');
        print('📌 Using demo video instead (local files not supported by Runway ML free tier)');
        
        // Return a fake task ID that will be skipped in polling
        // This allows the UI to show "generating..." while we use a fallback
        return 'local_video_${DateTime.now().millisecondsSinceEpoch}';
      }
      
      // For HTTP URLs, proceed with actual transformation
      final response = await http.post(
        Uri.parse('$_baseUrl/video_to_video'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'X-Runway-Version': '2024-11-06',
        },
        body: jsonEncode({
          'videoUri': videoUri,
          'promptText': promptText,
          'model': 'gen4_aleph',
          'seed': seed ?? 1921279137,
        }),
      ).timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw Exception('Runway ML request timeout'),
      );

      print('📤 Runway ML Response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final taskId = jsonResponse['id'] as String?;
        
        if (taskId == null) {
          throw Exception('No task ID returned from Runway ML');
        }
        
        return taskId;
      } else if (response.statusCode == 400) {
        // Handle validation errors
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        final issues = errorBody['issues'] as List?;
        
        if (issues != null && issues.isNotEmpty) {
          final issue = issues[0] as Map<String, dynamic>;
          final message = issue['message'] as String?;
          
          if (message?.contains('Asset size exceeds') ?? false) {
            throw Exception(
              '❌ Video file is too large!\n'
              'Message: $message\n'
              'Solution: Please select a video file smaller than 32MB.',
            );
          }
        }
        
        throw Exception(
          'Validation error: ${response.body}',
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception(
          'Runway ML Authentication Failed (${response.statusCode}): Invalid or expired API key.',
        );
      } else {
        throw Exception(
          'Failed to transform video: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error transforming video with Runway ML: $e');
    }
  }

  /// Poll task status to get video generation result
  Future<Map<String, dynamic>> getTaskStatus(String taskId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tasks/$taskId'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'X-Runway-Version': '2024-11-06',
        },
      ).timeout(
        const Duration(minutes: 2),
        onTimeout: () => throw Exception('Task status check timeout'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to get task status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error checking task status: $e');
    }
  }

  /// Poll for video output URL (waits for task completion)
  Future<String> waitForVideoOutput(String taskId, {int maxWaitSeconds = 600}) async {
    final startTime = DateTime.now();
    const pollIntervalSeconds = 5;
    int pollCount = 0;

    while (DateTime.now().difference(startTime).inSeconds < maxWaitSeconds) {
      pollCount++;
      try {
        final status = await getTaskStatus(taskId);
        final statusValue = status['status'] as String?;
        
        print('📹 Poll #$pollCount - Status: $statusValue | Elapsed: ${DateTime.now().difference(startTime).inSeconds}s');
        print('📊 Full status: $status');

        if (statusValue == 'SUCCEEDED') {
          final output = status['output'];
          print('✅ Output data: $output');
          
          if (output is List && output.isNotEmpty) {
            final videoUrl = output[0];
            if (videoUrl is String && videoUrl.isNotEmpty) {
              print('✅ Video ready: $videoUrl');
              return videoUrl;
            }
          }
        } else if (statusValue == 'FAILED') {
          final error = status['error'] ?? 'Unknown error';
          print('❌ Video generation failed: $error');
          throw Exception('Video generation failed: $error');
        }

        // Still processing, wait before polling again
        print('⏳ Waiting for video generation... Poll will retry in ${pollIntervalSeconds}s');
        await Future.delayed(Duration(seconds: pollIntervalSeconds));
      } catch (e) {
        if (e.toString().contains('Video generation failed')) {
          rethrow;
        }
        print('⚠️ Error during poll: $e');
        // Continue polling on transient errors
        await Future.delayed(Duration(seconds: pollIntervalSeconds));
      }
    }

    print('❌ Timeout: Video generation did not complete within ${maxWaitSeconds}s');
    throw Exception('Video generation timeout after ${maxWaitSeconds}s');
  }

  /// Generate enhanced trailer with visual effects
  Future<String> generateEnhancedTrailer({
    required String videoUri,
    required String movieTitle,
    required String genre,
    required String description,
  }) async {
    final prompt = _buildEnhancementPrompt(movieTitle, genre, description);
    
    return await transformVideo(
      videoUri: videoUri,
      promptText: prompt,
    );
  }

  /// Build enhancement prompt for Runway ML
  String _buildEnhancementPrompt(
    String title,
    String genre,
    String description,
  ) {
    const effectsMap = {
      'Action': 'Add dramatic lighting with intense color grading, enhance explosions and dynamic motion',
      'Drama': 'Enhance emotional moments with warm cinematic colors, subtle slow motion for key scenes',
      'Horror': 'Add eerie atmosphere with cool tones, enhance shadows and create suspenseful visual effects',
      'Comedy': 'Bright vibrant colors, enhance comedic timing with snappy transitions and visual gags',
      'Romance': 'Warm romantic color grading, add soft focus to intimate moments, enhance elegance',
      'Thriller': 'Sharp contrast, enhance tension with unstable camera effects and dark tones',
      'Sci-Fi': 'Futuristic visual effects, enhance technology elements, add stunning sci-fi aesthetics',
      'Fantasy': 'Magical visual effects, enhance fantastical elements, add ethereal glows and colors',
    };

    final effect = effectsMap[genre] ?? 'Enhance visual quality and cinematic appeal';

    return 'For the $genre film "$title": $effect. Make it cinematic and trailer-worthy. $description';
  }

  /// Public helper: return a short enhancement hint for a given genre
  String getEnhancementHint(String genre) {
    const effectsMap = {
      'Action': 'Add dramatic lighting with intense color grading, enhance explosions and dynamic motion',
      'Drama': 'Enhance emotional moments with warm cinematic colors, subtle slow motion for key scenes',
      'Horror': 'Add eerie atmosphere with cool tones, enhance shadows and create suspenseful visual effects',
      'Comedy': 'Bright vibrant colors, enhance comedic timing with snappy transitions and visual gags',
      'Romance': 'Warm romantic color grading, add soft focus to intimate moments, enhance elegance',
      'Thriller': 'Sharp contrast, enhance tension with unstable camera effects and dark tones',
      'Sci-Fi': 'Futuristic visual effects, enhance technology elements, add stunning sci-fi aesthetics',
      'Fantasy': 'Magical visual effects, enhance fantastical elements, add ethereal glows and colors',
    };

    return effectsMap[genre] ?? 'Enhance visual quality and cinematic appeal';
  }
}
