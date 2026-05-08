/// Data models for AI Trailer Generator
library;

// Enum for video genre
enum VideoGenre {
  action('Action'),
  drama('Drama'),
  comedy('Comedy'),
  horror('Horror'),
  thriller('Thriller'),
  romance('Romance'),
  scifi('Science Fiction'),
  documentary('Documentary');

  const VideoGenre(this.label);
  final String label;
}

// Enum for trailer duration
enum TrailerDuration {
  thirtySeconds('30 seconds'),
  fortyFiveSeconds('45 seconds'),
  sixtySeconds('60 seconds');

  const TrailerDuration(this.label);
  final String label;
  
  int get seconds {
    switch (this) {
      case TrailerDuration.thirtySeconds:
        return 30;
      case TrailerDuration.fortyFiveSeconds:
        return 45;
      case TrailerDuration.sixtySeconds:
        return 60;
    }
  }
}

/// Scene model for detected scenes
class Scene {
  final int startTime; // in seconds
  final int endTime; // in seconds
  final double emotionScore; // 0.0 to 1.0
  final String emotionType; // intense, calm, sad, happy, etc
  final String description;

  Scene({
    required this.startTime,
    required this.endTime,
    required this.emotionScore,
    required this.emotionType,
    required this.description,
  });

  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      startTime: json['startTime'] ?? 0,
      endTime: json['endTime'] ?? 0,
      emotionScore: double.tryParse(json['emotionScore'].toString()) ?? 0.0,
      emotionType: json['emotionType'] ?? 'neutral',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'startTime': startTime,
    'endTime': endTime,
    'emotionScore': emotionScore,
    'emotionType': emotionType,
    'description': description,
  };
}

/// Request model for trailer generation
class TrailerGenerationRequest {
  final String videoId;
  final String videoUrl;
  final VideoGenre genre;
  final TrailerDuration duration;
  final String? title;
  final String? description;

  TrailerGenerationRequest({
    required this.videoId,
    required this.videoUrl,
    required this.genre,
    required this.duration,
    this.title,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'videoId': videoId,
    'videoUrl': videoUrl,
    'genre': genre.label,
    'duration': duration.label,
    'title': title ?? '',
    'description': description ?? '',
  };
}

/// Trailer model with analysis
class GeneratedTrailer {
  final String id;
  final String videoId;
  final VideoGenre genre;
  final int duration;
  final List<Scene> highlightScenes;
  final List<int> selectedTimestamps; // timestamps of selected clips
  final String musicSuggestion;
  final String analysis;
  final DateTime generatedAt;
  String? runwayTaskId; // Runway ML task ID for video enhancement
  String? generatedVideoUrl; // URL to the generated trailer video

  GeneratedTrailer({
    required this.id,
    required this.videoId,
    required this.genre,
    required this.duration,
    required this.highlightScenes,
    required this.selectedTimestamps,
    required this.musicSuggestion,
    required this.analysis,
    required this.generatedAt,
    this.runwayTaskId,
    this.generatedVideoUrl,
  });

  factory GeneratedTrailer.fromJson(Map<String, dynamic> json) {
    return GeneratedTrailer(
      id: json['id'] ?? '',
      videoId: json['videoId'] ?? '',
      genre: VideoGenre.values.firstWhere(
        (g) => g.label == json['genre'],
        orElse: () => VideoGenre.action,
      ),
      duration: json['duration'] ?? 30,
      highlightScenes: ((json['highlightScenes'] ?? []) as List)
          .map((s) => Scene.fromJson(s as Map<String, dynamic>))
          .toList(),
      selectedTimestamps: List<int>.from(json['selectedTimestamps'] ?? []),
      musicSuggestion: json['musicSuggestion'] ?? '',
      analysis: json['analysis'] ?? '',
      generatedAt: DateTime.now(),
      runwayTaskId: json['runwayTaskId'],
      generatedVideoUrl: json['generatedVideoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'videoId': videoId,
    'genre': genre.label,
    'duration': duration,
    'highlightScenes': highlightScenes.map((s) => s.toJson()).toList(),
    'selectedTimestamps': selectedTimestamps,
    'musicSuggestion': musicSuggestion,
    'analysis': analysis,
    'generatedAt': generatedAt.toIso8601String(),
    'runwayTaskId': runwayTaskId,
    'generatedVideoUrl': generatedVideoUrl,
  };
}

/// Video upload model
class VideoUpload {
  final String id;
  final String fileName;
  final int fileSizeBytes;
  final String mimeType;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String mongoDbId; // MongoDB document ID

  VideoUpload({
    required this.id,
    required this.fileName,
    required this.fileSizeBytes,
    required this.mimeType,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.mongoDbId,
  });

  factory VideoUpload.fromJson(Map<String, dynamic> json) {
    return VideoUpload(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileSizeBytes: json['fileSizeBytes'] ?? 0,
      mimeType: json['mimeType'] ?? 'video/mp4',
      uploadedBy: json['uploadedBy'] ?? '',
      uploadedAt: DateTime.tryParse(json['uploadedAt'] ?? '') ?? DateTime.now(),
      mongoDbId: json['mongoDbId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fileName': fileName,
    'fileSizeBytes': fileSizeBytes,
    'mimeType': mimeType,
    'uploadedBy': uploadedBy,
    'uploadedAt': uploadedAt.toIso8601String(),
    'mongoDbId': mongoDbId,
  };
}
