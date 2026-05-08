import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../models/trailer_models.dart';
import '../services/trailer_generator_service.dart';

class TrailerGeneratorScreen extends StatefulWidget {
  final String geminiApiKey;
  final String runwayApiKey;

  const TrailerGeneratorScreen({
    required this.geminiApiKey,
    required this.runwayApiKey,
    super.key,
  });

  @override
  State<TrailerGeneratorScreen> createState() =>
      _TrailerGeneratorScreenState();
}

class _TrailerGeneratorScreenState extends State<TrailerGeneratorScreen> {
  late TrailerGeneratorService _service;
  
  VideoGenre _selectedGenre = VideoGenre.action;
  TrailerDuration _selectedDuration = TrailerDuration.sixtySeconds;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String? _selectedVideoFile;
  String? _selectedVideoFileName;
  String? _selectedVideoLocalPath;
  Uint8List? _selectedVideoBytes; // Store actual video bytes
  int? _selectedVideoSizeBytes; // Store video size
  GeneratedTrailer? _generatedTrailer;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = TrailerGeneratorService(
      geminiApiKey: widget.geminiApiKey,
      runwayApiKey: widget.runwayApiKey,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // Clean up video generation callback
    if (_generatedTrailer != null) {
      _service.removeVideoGenerationCallback(_generatedTrailer!.id);
    }
    super.dispose();
  }

  Future<void> _selectVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: true, // Required for web to get bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileSizeBytes = file.size;
        final fileSizeMB = fileSizeBytes / (1024 * 1024);
        
        // Check file size - Runway ML has 32MB limit
        const maxSizeMB = 32;
        if (fileSizeMB > maxSizeMB) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ File too large: ${fileSizeMB.toStringAsFixed(2)}MB (Max: ${maxSizeMB}MB)\n'
                'Please select a smaller video.',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }
        
        // For web, use bytes; for mobile/desktop, use path
        final fileIdentifier = file.bytes != null
            ? 'web_video_${DateTime.now().millisecondsSinceEpoch}'
            : (file.path ?? file.name);

        setState(() {
          _selectedVideoFileName = file.name;
          _selectedVideoFile = fileIdentifier;
          _selectedVideoBytes = file.bytes;
          _selectedVideoSizeBytes = fileSizeBytes;
          // Store the local path when available (desktop/mobile)
          _selectedVideoLocalPath = file.path;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Video: ${file.name} (${fileSizeMB.toStringAsFixed(2)}MB) - Ready!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _generateTrailer() async {
    if (_selectedVideoFile == null || _selectedVideoFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a video file first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a movie title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = TrailerGenerationRequest(
        videoId: _selectedVideoFile!,
        // Use actual local path when available so FFmpeg pipeline can process it.
        videoUrl: _selectedVideoLocalPath != null
            ? _selectedVideoLocalPath!
            : 'video://${_selectedVideoFile!}/${_selectedVideoFileName!}',
        genre: _selectedGenre,
        duration: _selectedDuration,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      final trailer = await _service.generateTrailer(request);

      setState(() {
        _generatedTrailer = trailer;
        _isLoading = false;
      });

      // Register callback to update UI when real video is ready
      _service.onVideoGenerationComplete(trailer.id, (videoUrl) {
        print('🎉 Generated video callback received: $videoUrl');
        if (mounted) {
          setState(() {
            _generatedTrailer?.generatedVideoUrl = videoUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Your trailer video is ready! Playing now...'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏳ Processing your trailer... (AI is generating now)'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 AI Trailer Generator'),
        elevation: 0,
      ),
      body: _isLoading
          ? _buildLoadingView()
          : (_generatedTrailer != null
              ? _buildResultView()
              : _buildFormView()),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select Video'),
          const SizedBox(height: 12),
          _buildVideoSelector(),
          const SizedBox(height: 24),
          _buildSectionTitle('Video Details'),
          const SizedBox(height: 12),
          _buildTitleInput(),
          const SizedBox(height: 12),
          _buildDescriptionInput(),
          const SizedBox(height: 24),
          _buildSectionTitle('Trailer Settings'),
          const SizedBox(height: 12),
          _buildGenreDropdown(),
          const SizedBox(height: 12),
          _buildDurationDropdown(),
          const SizedBox(height: 24),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildVideoSelector() {
    return Card(
      elevation: _selectedVideoFileName != null ? 4 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: _selectedVideoFileName != null
              ? Border.all(color: Colors.green, width: 2)
              : Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedVideoFileName ?? 'No video selected',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _selectedVideoFileName == null
                                ? Colors.grey
                                : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_selectedVideoFileName != null &&
                            _selectedVideoSizeBytes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '✅ Size: ${(_selectedVideoSizeBytes! / 1024 / 1024).toStringAsFixed(2)} MB (Within 32MB limit)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_selectedVideoFileName != null)
                    const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectVideoFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(
                    _selectedVideoFileName != null
                        ? 'Change Video'
                        : 'Choose Video',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Max file size: 32MB (Runway ML limit)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Movie Title *',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'e.g., The Action Adventure',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Movie Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Brief description of the movie',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<VideoGenre>(
          isExpanded: true,
          value: _selectedGenre,
          items: VideoGenre.values.map((genre) {
            return DropdownMenuItem(
              value: genre,
              child: Text(genre.label),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedGenre = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDurationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trailer Duration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButton<TrailerDuration>(
          isExpanded: true,
          value: _selectedDuration,
          items: TrailerDuration.values.map((duration) {
            return DropdownMenuItem(
              value: duration,
              child: Text(duration.label),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedDuration = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _generateTrailer,
        icon: const Icon(Icons.movie),
        label: const Text('Generate Trailer'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            '🎬 Generating Your Trailer',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '📝 Extracting scenes from your film\n🎨 Analyzing emotions & narrative\n🎥 Generating video with AI',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              'This may take a few minutes...',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    if (_generatedTrailer == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trailer Generated!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _generatedTrailer = null;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('New Trailer'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Show video player if video URL is available
          if (_generatedTrailer!.generatedVideoUrl != null &&
              _generatedTrailer!.generatedVideoUrl!.isNotEmpty)
            _buildVideoPlayerWidget(_generatedTrailer!.generatedVideoUrl!)
          else if (_generatedTrailer!.runwayTaskId != null)
            _buildVideoLoadingWidget()
          else
            _buildPlaceholderVideoCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('📊 Trailer Analysis'),
          const SizedBox(height: 12),
          _buildDurationCard(),
          const SizedBox(height: 16),
          _buildGenreCard(),
          const SizedBox(height: 16),
          _buildHighlightScenesSection(),
          const SizedBox(height: 16),
          _buildMusicsuggestionsCard(),
          const SizedBox(height: 16),
          _buildAnalysisCard(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerWidget(String videoUrl) {
    return Card(
      elevation: 4,
      child: Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Video thumbnail or placeholder
              Container(
                color: Colors.grey.shade900,
                child: Image.network(
                  videoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: const Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 80,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Play button overlay
              GestureDetector(
                onTap: () {
                  // Open video in browser
                  print('Opening video: $videoUrl');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: SelectableText(
                        'Video URL: $videoUrl',
                        style: const TextStyle(fontSize: 11),
                      ),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: 'Copy',
                        onPressed: () {
                          // Copy to clipboard would go here
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
              ),
              // Info overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✅ Trailer Generated!',
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _generatedTrailer!.analysis.split('\n').first,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.videocam,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Click to view • Tap to copy URL',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoLoadingWidget() {
    return Card(
      elevation: 4,
      child: Container(
        color: Colors.grey.shade900,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Generating Video',
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Task ID: ${_generatedTrailer!.runwayTaskId}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Refresh to check if video is ready
                  setState(() {
                    // Trigger rebuild
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Check Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderVideoCard() {
    return Card(
      elevation: 4,
      child: Container(
        color: Colors.grey.shade900,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.video_file,
                size: 80,
                color: Colors.blue.shade300,
              ),
              const SizedBox(height: 20),
              Text(
                'Scene Analysis Complete ✅',
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Generating HD trailer video...',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 60,
                height: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey.shade700,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade800,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade300,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This usually takes 2-10 minutes',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trailer Duration',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_generatedTrailer!.duration} seconds',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Genre:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _generatedTrailer!.genre.label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightScenesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🎬 Highlight Scenes'),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _generatedTrailer!.highlightScenes.length,
          itemBuilder: (context, index) {
            final scene = _generatedTrailer!.highlightScenes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${scene.startTime}s - ${scene.endTime}s',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Chip(
                            label: Text(scene.emotionType),
                            backgroundColor: _getEmotionColor(scene.emotionType),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(scene.description),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Emotion Score:'),
                          Text(
                            '${(scene.emotionScore * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMusicsuggestionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🎵 Music Suggestion'),
            const SizedBox(height: 8),
            Text(_generatedTrailer!.musicSuggestion),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('📝 Trailer Analysis'),
            const SizedBox(height: 8),
            Text(
              _generatedTrailer!.analysis,
              style: const TextStyle(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'intense':
        return Colors.red.shade100;
      case 'suspenseful':
        return Colors.orange.shade100;
      case 'climactic':
        return Colors.purple.shade100;
      case 'calm':
        return Colors.blue.shade100;
      case 'romantic':
        return Colors.pink.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
