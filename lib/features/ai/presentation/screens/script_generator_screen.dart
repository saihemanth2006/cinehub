import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/buttons/buttons.dart';
import '../../../../shared/widgets/inputs/inputs.dart';
import '../../../../shared/widgets/cards/cards.dart';

class ScriptGeneratorScreen extends StatefulWidget {
  const ScriptGeneratorScreen({super.key});

  @override
  State<ScriptGeneratorScreen> createState() => _ScriptGeneratorScreenState();
}

class _ScriptGeneratorScreenState extends State<ScriptGeneratorScreen> {
  final _promptController = TextEditingController();
  String _selectedGenre = 'Drama';
  final _genres = ['Drama', 'Sci-Fi', 'Horror', 'Comedy', 'Thriller', 'Romance', 'Action', 'Documentary'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Script Generator'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D1B69), Color(0xFF1A1A26)],
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.edit, color: AppColors.primary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Describe your story idea and let AI generate a complete script.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('Genre', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _genres.map((g) => ChoiceChip(
                label: Text(g),
                selected: _selectedGenre == g,
                onSelected: (v) => setState(() => _selectedGenre = g),
                selectedColor: AppColors.primaryMuted,
                backgroundColor: AppColors.surfaceElevated,
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: _selectedGenre == g ? AppColors.primary : AppColors.textSecondary,
                ),
                side: BorderSide(
                  color: _selectedGenre == g ? AppColors.primary : AppColors.border,
                  width: 0.5,
                ),
              )).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppTextField(
              label: 'Story Prompt',
              hint: 'A detective in 2050 discovers that dreams are being stolen...',
              controller: _promptController,
              maxLines: 5,
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: 'Generate Script',
              icon: Iconsax.magic_star,
              isExpanded: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
