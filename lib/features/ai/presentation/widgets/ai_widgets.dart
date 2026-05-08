///
/// @file ai_widgets.dart
/// @description Reusable AI UI widgets — futuristic, cinematic, dark theme
///
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehub/core/theme/app_colors.dart';

// ─── AI Response Card ────────────────────────────────────────
/// Expandable card for displaying AI responses
class AIResponseCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final dynamic content;
  final String? icon;
  final VoidCallback? onAction;
  final bool expandable;
  final Duration animationDuration;

  const AIResponseCard({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.icon,
    this.onAction,
    this.expandable = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AIResponseCard> createState() => _AIResponseCardState();
}

class _AIResponseCardState extends State<AIResponseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.darkBg.withOpacity(0.8),
                AppColors.darkBg.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3 + (_animationController.value * 0.3)),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1 + (_animationController.value * 0.1)),
                blurRadius: 10 + (_animationController.value * 10),
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              InkWell(
                onTap: widget.expandable ? _toggleExpand : null,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon
                      if (widget.icon != null)
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (widget.subtitle != null)
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  widget.subtitle!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Row(
                        children: [
                          if (widget.onAction != null)
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: widget.onAction,
                              tooltip: 'Copy to clipboard',
                            ),
                          if (widget.expandable)
                            RotatedBox(
                              quarterTurns: _isExpanded ? 2 : 0,
                              child: Icon(
                                Icons.expand_more,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              if (_isExpanded)
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.black26,
                      padding: EdgeInsets.all(12),
                      child: _buildContent(widget.content),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(dynamic content) {
    if (content is String) {
      return Text(
        content,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          height: 1.6,
        ),
      );
    } else if (content is List) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: content.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(color: AppColors.primary),
                ),
                Expanded(
                  child: Text(
                    content[index].toString(),
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (content is Map) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: content.entries.length,
        itemBuilder: (context, index) {
          final entry = content.entries.elementAt(index);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key.toString(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  entry.value.toString(),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        },
      );
    }
    return Text(content.toString(), style: TextStyle(color: Colors.white70));
  }
}

// ─── AI Loading State ────────────────────────────────────────
/// Animated loading indicator with typing effect
class AILoadingWidget extends StatefulWidget {
  final String? message;
  final Duration animationDuration;

  const AILoadingWidget({
    super.key,
    this.message = 'Generating with AI...',
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<AILoadingWidget> createState() => _AILoadingWidgetState();
}

class _AILoadingWidgetState extends State<AILoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _dotsController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated glow effect
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 80 + (30 * _pulseController.value),
              height: 80 + (30 * _pulseController.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 24),
        // Message with typing dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.message ?? 'Generating with AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8),
            AnimatedBuilder(
              animation: _dotsController,
              builder: (context, child) {
                final progress = _dotsController.value;
                return Row(
                  children: [
                    Opacity(
                      opacity: (progress > 0 && progress < 0.4) ? 1 : 0.3,
                      child: Text('.', style: TextStyle(color: AppColors.primary)),
                    ),
                    SizedBox(width: 2),
                    Opacity(
                      opacity: (progress > 0.3 && progress < 0.7) ? 1 : 0.3,
                      child: Text('.', style: TextStyle(color: AppColors.primary)),
                    ),
                    SizedBox(width: 2),
                    Opacity(
                      opacity: (progress > 0.6) ? 1 : 0.3,
                      child: Text('.', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Typing Animation ────────────────────────────────────────
/// Text with typewriter animation effect
class TypingTextAnimation extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;
  final VoidCallback? onComplete;

  const TypingTextAnimation({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 50),
    this.style,
    this.onComplete,
  });

  @override
  State<TypingTextAnimation> createState() => _TypingTextAnimationState();
}

class _TypingTextAnimationState extends State<TypingTextAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late int _displayedCharacters = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration * widget.text.length,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        _displayedCharacters =
            (widget.text.length * _controller.value).ceil();
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _displayedCharacters),
      style: widget.style,
    );
  }
}

// ─── AI Module Card ─────────────────────────────────────────
/// Card for displaying available AI modules
class AIModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final int taskCount;
  final VoidCallback onTap;
  final bool isSelected;

  const AIModuleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.taskCount,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0.1)]
                : [AppColors.darkBg, AppColors.darkBg.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 28,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$taskCount tasks',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
