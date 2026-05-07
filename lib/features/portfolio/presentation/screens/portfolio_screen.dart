import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/cards/cards.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Portfolio'), leading: const BackButton()),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12,
        ),
        itemCount: 8,
        itemBuilder: (_, i) => SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: const Center(child: Icon(Icons.play_circle_outline, color: AppColors.textTertiary)),
                ),
              ),
              const SizedBox(height: 8),
              Text('Project ${i + 1}', style: AppTypography.labelMedium),
              Text('${(i + 1) * 340} views', style: AppTypography.caption),
            ],
          ),
        ),
      ),
    );
  }
}
