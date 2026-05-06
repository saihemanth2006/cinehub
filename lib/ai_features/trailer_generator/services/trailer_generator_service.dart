import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trailer_models.dart';
import 'mongodb_video_service.dart';

/// Service for generating trailers using Gemini API
class TrailerGeneratorService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _model = 'veo-3.1-fast-generate-preview';
  
  final String _apiKey;
  final MongoDBVideoService _mongoService;

  TrailerGeneratorService({
    required String apiKey,
  }) : _apiKey = apiKey,
       _mongoService = MongoDBVideoService();

  /// Generate trailer from video
  Future<GeneratedTrailer> generateTrailer(
    TrailerGenerationRequest request,
  ) async {
    try {
      final prompt = _buildAnalysisPrompt(request);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': prompt,
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          },
        }),
      ).timeout(
        const Duration(minutes: 3),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final trailer = await _parseResponse(response.body, request);
        
        // Save trailer to MongoDB
        await _mongoService.saveTrailerAnalysis(trailer: trailer);
        
        return trailer;
      } else {
        throw Exception(
          'Failed to generate trailer: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error generating trailer: $e');
    }
  }

  /// Build analysis prompt for Gemini
  String _buildAnalysisPrompt(TrailerGenerationRequest request) {
    return '''Analyze a ${request.duration.label} film trailer generation for a ${request.genre.label} movie.

Video Information:
- Title: ${request.title ?? 'Untitled'}
- Description: ${request.description ?? 'No description provided'}
- Genre: ${request.genre.label}
- Target Duration: ${request.duration.label}

Your task is to:
1. Detect key emotional scenes (intense, climactic, romantic, funny, suspenseful moments)
2. Rank scenes by emotional impact and relevance to ${request.genre.label} genre
3. Select ${request.duration.label} worth of highlights that create pacing
4. Suggest background music style
5. Provide scene timing timestamps

Respond ONLY with this exact JSON format (no markdown, no extra text):
{
  "highlightScenes": [
    {
      "startTime": 0,
      "endTime": 30,
      "emotionScore": 0.9,
      "emotionType": "intense",
      "description": "Opening action sequence with high stakes"
    }
  ],
  "selectedTimestamps": [0, 15, 30, 45, 60],
  "musicSuggestion": "High-energy orchestral score with dramatic strings",
  "analysis": "This trailer structure creates compelling narrative arc by establishing conflict in first 15 seconds, escalating tension through middle sequences, and ending with explosive climax that leaves viewers wanting more."
}

IMPORTANT:
1. Return ONLY valid JSON
2. Ensure total duration of clips ≤ ${request.duration.seconds} seconds
3. Emotion scores must be 0.0-1.0
4. Include 3-5 highlight scenes minimum
5. Timestamps must be realistic (0-1000 seconds for typical videos)
6. Scene descriptions must be evocative and genre-appropriate''';
  }

  /// Parse trailer generation response
  Future<GeneratedTrailer> _parseResponse(
    String responseBody,
    TrailerGenerationRequest request,
  ) async {
    try {
      final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      
      if (jsonResponse['candidates'] == null || 
          (jsonResponse['candidates'] as List).isEmpty) {
        return _createDefaultTrailer(request);
      }

      final content = jsonResponse['candidates'][0]['content']['parts'][0]['text'] as String;
      
      // Try to parse as JSON first
      try {
        final trailerJson = jsonDecode(content);
        if (trailerJson is Map<String, dynamic> && trailerJson.containsKey('highlightScenes')) {
          return _buildTrailerFromResponse(trailerJson, request);
        }
      } catch (e) {
        // Try to extract JSON
      }

      // Extract JSON from text
      final jsonMatch = _extractJsonFromText(content);
      if (jsonMatch != null && jsonMatch.isNotEmpty) {
        try {
          final trailerJson = jsonDecode(jsonMatch) as Map<String, dynamic>;
          return _buildTrailerFromResponse(trailerJson, request);
        } catch (e) {
          return _createDefaultTrailer(request);
        }
      }

      return _createDefaultTrailer(request);
    } catch (e) {
      return _createDefaultTrailer(request);
    }
  }

  /// Build trailer from parsed response
  GeneratedTrailer _buildTrailerFromResponse(
    Map<String, dynamic> json,
    TrailerGenerationRequest request,
  ) {
    final scenes = ((json['highlightScenes'] ?? []) as List)
        .map((s) => Scene.fromJson(s as Map<String, dynamic>))
        .toList();

    final timestamps = List<int>.from(json['selectedTimestamps'] ?? []);

    return GeneratedTrailer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      videoId: request.videoId,
      genre: request.genre,
      duration: request.duration.seconds,
      highlightScenes: scenes,
      selectedTimestamps: timestamps,
      musicSuggestion: json['musicSuggestion'] ?? 'Background music to be determined',
      analysis: json['analysis'] ?? 'Trailer analysis generated',
      generatedAt: DateTime.now(),
    );
  }

  /// Create default trailer when analysis fails
  GeneratedTrailer _createDefaultTrailer(TrailerGenerationRequest request) {
    return GeneratedTrailer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      videoId: request.videoId,
      genre: request.genre,
      duration: request.duration.seconds,
      highlightScenes: [
        Scene(
          startTime: 0,
          endTime: 10,
          emotionScore: 0.8,
          emotionType: 'intense',
          description: 'Opening hook - establish the story',
        ),
        Scene(
          startTime: 10,
          endTime: 20,
          emotionScore: 0.7,
          emotionType: 'suspenseful',
          description: 'Build tension and conflict',
        ),
        Scene(
          startTime: 20,
          endTime: request.duration.seconds,
          emotionScore: 0.9,
          emotionType: 'climactic',
          description: 'Final climax and call to action',
        ),
      ],
      selectedTimestamps: [0, 10, 20],
      musicSuggestion: 'Dramatic and engaging background score',
      analysis: 'Default trailer structure optimized for ${request.genre.label}',
      generatedAt: DateTime.now(),
    );
  }

  /// Extract JSON from text
  String? _extractJsonFromText(String text) {
    int braceCount = 0;
    int startIndex = -1;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == '{') {
        if (braceCount == 0) {
          startIndex = i;
        }
        braceCount++;
      } else if (text[i] == '}') {
        braceCount--;
        if (braceCount == 0 && startIndex != -1) {
          return text.substring(startIndex, i + 1);
        }
      }
    }

    return null;
  }
}
