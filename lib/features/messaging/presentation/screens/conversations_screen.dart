import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/media/cached_avatar.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Messages'), leading: const BackButton()),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: 6,
        separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 1),
        itemBuilder: (_, i) => ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: CachedAvatar(name: 'User $i', size: 48, showOnlineIndicator: true, isOnline: i % 2 == 0),
          title: Text('User ${i + 1}', style: AppTypography.labelLarge),
          subtitle: Text('Last message preview...', style: AppTypography.bodySmall),
          trailing: Text('${i + 1}h ago', style: AppTypography.caption),
        ),
      ),
    );
  }
}
