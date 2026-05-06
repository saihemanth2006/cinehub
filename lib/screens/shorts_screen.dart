import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// YouTube Shorts-style Screen - Vertical scrolling videos
class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shorts'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) => _ShortCard(
          index: index,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/// Individual short card
class _ShortCard extends StatelessWidget {
  final int index;

  const _ShortCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.4),
                AppColors.secondary.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
        // Content
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'For You',
                    style: AppTypography.headline3,
                  ),
                  Icon(
                    Icons.more_vert,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
            // Center content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_library_outlined,
                      size: 80,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Short #${index + 1}',
                      style: AppTypography.headline2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${125 + index * 50}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mode_comment_outlined,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${45 + index * 10}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${25 + index * 5}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
