import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Account/You Screen - User profile and settings
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('You'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.7),
                          AppColors.secondary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'AR',
                        style: AppTypography.headline3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Profile info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Rivera',
                          style: AppTypography.headline3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@alexrivera',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'View profile',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.border,
              height: 1,
            ),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(label: 'Uploads', value: '12'),
                  _StatColumn(label: 'Followers', value: '2.4K'),
                  _StatColumn(label: 'Following', value: '350'),
                ],
              ),
            ),
            Divider(
              color: AppColors.border,
              height: 1,
            ),
            // Menu items
            ...List.generate(
              5,
              (index) => _MenuItemTile(
                icons: [
                  Icons.upload_outlined,
                  Icons.bookmark_outline,
                  Icons.history,
                  Icons.settings_outlined,
                  Icons.help_outline,
                ][index],
                titles: [
                  'Your uploads',
                  'Saved playlists',
                  'Watch history',
                  'Settings',
                  'Help & feedback',
                ][index],
              ),
            ),
            Divider(
              color: AppColors.border,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat column widget
class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headline3,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }
}

/// Menu item tile
class _MenuItemTile extends StatelessWidget {
  final IconData icons;
  final String titles;

  const _MenuItemTile({
    required this.icons,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Icon(
            icons,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              titles,
              style: AppTypography.bodyMedium,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
