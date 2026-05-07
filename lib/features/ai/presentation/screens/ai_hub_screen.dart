import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/cards/cards.dart';
import '../../../../shared/widgets/ai/ai_widgets.dart';

class AIHubScreen extends StatefulWidget {
  const AIHubScreen({super.key});

  @override
  State<AIHubScreen> createState() => _AIHubScreenState();
}

class _AIHubScreenState extends State<AIHubScreen> {
  final _promptCtrl = TextEditingController();
  bool _isGenerating = false;
  String? _generatedContent;

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  void _mockGenerate() {
    if (_promptCtrl.text.trim().isEmpty) return;
    setState(() {
      _isGenerating = true;
      _generatedContent = null;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _generatedContent =
              'INT. ABANDONED WAREHOUSE - NIGHT\n\n'
              'Rain hammers against broken windows. A single overhead lamp '
              'swings, casting shifting shadows across concrete pillars.\n\n'
              'DETECTIVE ARIA COLE (40s, weathered, sharp eyes) steps through '
              'the doorway, service weapon drawn. Her breath fogs in the cold.\n\n'
              'ARIA\n(whispering into earpiece)\n'
              'I\'m inside. No visual on the suspect.\n\n'
              'She sweeps the beam of her flashlight across the space. '
              'Something CLANKS in the darkness ahead...';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: AppRadii.borderSm,
                  ),
                  child: const Icon(Iconsax.cpu, size: 15, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('AI Studio', style: AppTypography.h1),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.setting_2, size: 22),
                onPressed: () {},
              ),
            ],
          ),

          // ── Quick create prompt ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What do you want to create?',
                      style: AppTypography.h2),
                  const SizedBox(height: 4),
                  Text('Describe your idea and let AI bring it to life.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 16),
                  AIPromptInput(
                    controller: _promptCtrl,
                    hint: 'A noir detective thriller set in 2050...',
                    onSend: _mockGenerate,
                    isLoading: _isGenerating,
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
            ),
          ),

          // ── Generation progress ─────────────────────────────
          if (_isGenerating)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const AIGeneratingCard(
                  status: 'Generating your script...',
                  progress: 0.6,
                  steps: [
                    'Analyzing prompt',
                    'Building story structure',
                    'Writing scenes',
                    'Formatting output',
                  ],
                  currentStep: 2,
                ).animate().fadeIn(duration: 300.ms),
              ),
            ),

          // ── AI response ─────────────────────────────────────
          if (_generatedContent != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: AIResponseCard(
                  title: 'Generated Script',
                  content: _generatedContent!,
                  onCopy: () {},
                  onSave: () {},
                  onRegenerate: _mockGenerate,
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.02),
              ),
            ),

          // ── AI Tools grid ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text('AI Tools', style: AppTypography.h2),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                _ToolCard(
                  icon: Iconsax.edit,
                  title: 'Script Writer',
                  subtitle: 'Full screenplay from prompt',
                  color: AppColors.primary,
                  onTap: () => context.push(Routes.scriptGenerator),
                ),
                _ToolCard(
                  icon: Iconsax.calculator,
                  title: 'Budget AI',
                  subtitle: 'Predict production costs',
                  color: AppColors.accent,
                  onTap: () => context.push(Routes.costPredictor),
                ),
                _ToolCard(
                  icon: Iconsax.video,
                  title: 'Trailer Lab',
                  subtitle: 'Concept & shot list',
                  color: AppColors.secondary,
                  onTap: () => context.push(Routes.trailerConcept),
                ),
                _ToolCard(
                  icon: Iconsax.magic_star,
                  title: 'Smart Cast',
                  subtitle: 'AI talent matching',
                  color: AppColors.success,
                  isComingSoon: true,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── Recent generations ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Recent', style: AppTypography.h2),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _RecentItem(index: i),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isComingSoon;
  final VoidCallback? onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isComingSoon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isComingSoon ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.borderLg,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const Spacer(),
                if (isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningMuted,
                      borderRadius: AppRadii.borderFull,
                    ),
                    child: Text('Soon', style: AppTypography.labelSmall.copyWith(color: AppColors.warning, fontSize: 9)),
                  ),
              ],
            ),
            const Spacer(),
            Text(title, style: AppTypography.labelLarge),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final int index;
  const _RecentItem({required this.index});

  static const _titles = ['Noir Thriller Script', 'Budget Estimate: Echoes', 'Trailer Shot List'];
  static const _types = ['Script', 'Budget', 'Trailer'];
  static const _times = ['2 hours ago', 'Yesterday', '3 days ago'];
  static const _colors = [AppColors.primary, AppColors.accent, AppColors.secondary];
  static const _icons = [Iconsax.edit, Iconsax.calculator, Iconsax.video];

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: _colors[index].withValues(alpha: 0.12),
              borderRadius: AppRadii.borderMd,
            ),
            child: Icon(_icons[index], size: 18, color: _colors[index]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_titles[index], style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(_types[index], style: AppTypography.labelSmall.copyWith(color: _colors[index])),
                    Text(' • ${_times[index]}', style: AppTypography.caption),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, size: 14, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
