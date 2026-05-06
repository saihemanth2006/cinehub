import 'package:flutter/material.dart';
import '../models/trailer_models.dart';
import '../services/trailer_generator_service.dart';

class TrailerGeneratorScreen extends StatefulWidget {
  final String apiKey;

  const TrailerGeneratorScreen({
    required this.apiKey,
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
  GeneratedTrailer? _generatedTrailer;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = TrailerGeneratorService(apiKey: widget.apiKey);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectVideoFile() async {
    // Simulated file picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Video File'),
        content: const Text('Video file selection would open file picker'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedVideoFileName = 'sample_film.mp4';
                _selectedVideoFile = 'video_id_12345';
              });
              Navigator.pop(context);
            },
            child: const Text('Use Sample Video'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateTrailer() async {
    if (_selectedVideoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video file')),
      );
      return;
    }

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
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
        videoUrl: 'gs://sample-videos/${_selectedVideoFileName!}',
        genre: _selectedGenre,
        duration: _selectedDuration,
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );

      final trailer = await _service.generateTrailer(request);

      setState(() {
        _generatedTrailer = trailer;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trailer generated successfully!')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ),
                if (_selectedVideoFileName != null)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectVideoFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('Choose Video'),
              ),
            ),
          ],
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
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Analyzing video...\nDetecting scenes & emotions...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
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
                'Trailer Analysis',
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
