import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Subscriptions Screen - Followed creators and content
class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Subscriptions'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Sort options
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest uploads',
                    style: AppTypography.bodyMedium,
                  ),
                  Icon(
                    Icons.sort,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // Subscriptions list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _SubscriptionCard(index: index),
              childCount: 6,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ],
      ),
    );
  }
}

/// Subscription card
class _SubscriptionCard extends StatelessWidget {
  final int index;

  const _SubscriptionCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator info
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.6),
                      AppColors.secondary.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Creator name and handle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Creator ${index + 1}',
                      style: AppTypography.bodyLarge,
                    ),
                    Text(
                      '@creator${index + 1}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              // Bell icon
              Icon(
                Icons.notifications_off_outlined,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Latest video
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 120,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.secondary.withValues(alpha: 0.2),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Video info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Video Title',
                      style: AppTypography.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${50 + index * 25}K views • ${3 - (index % 3)} hours ago',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(
            color: AppColors.border,
            height: 1,
          ),
        ],
      ),
    );
  }
}
