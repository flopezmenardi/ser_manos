import 'package:flutter/material.dart';

import '../../molecules/components/vacants_indicator.dart';
import '../../tokens/colors.dart';
import '../../tokens/shadow.dart';
import '../../tokens/typography.dart';

class VolunteeringCard extends StatefulWidget {
  final String imagePath;
  final String category;
  final String title;
  final int vacancies;
  final bool isFavorite;
  final Future<void> Function() onFavoritePressed;
  final VoidCallback onLocationPressed;
  final int likeCount;

  const VolunteeringCard({
    super.key,
    required this.imagePath,
    required this.category,
    required this.title,
    required this.vacancies,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onLocationPressed,
    required this.likeCount,
  });

  @override
  State<VolunteeringCard> createState() => _VolunteeringCardState();
}

class _VolunteeringCardState extends State<VolunteeringCard> {
  bool _isTogglingFavorite = false;

  Future<void> _handleFavoritePress() async {
    if (_isTogglingFavorite) return;

    setState(() => _isTogglingFavorite = true);
    try {
      await widget.onFavoritePressed();
    } finally {
      if (mounted) {
        setState(() => _isTogglingFavorite = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(boxShadow: AppShadows.shadow2, borderRadius: BorderRadius.circular(2)),
        child: Card(
          color: AppColors.neutral0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: double.infinity, height: 138, child: Image.network(widget.imagePath, fit: BoxFit.cover)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 210),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.category.toUpperCase(),
                              style: AppTypography.overline.copyWith(color: AppColors.neutral75),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.title,
                              style: AppTypography.subtitle1.copyWith(color: AppColors.neutral100, height: 1.0),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            VacantsIndicator(vacants: widget.vacancies),
                          ],
                        ),
                      ),
                      // Right side
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.likeCount > 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                    '${widget.likeCount}',
                                    style: AppTypography.body2.copyWith(color: AppColors.primary100),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              GestureDetector(
                                onTap: _isTogglingFavorite ? null : _handleFavoritePress,
                                child: Icon(
                                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isTogglingFavorite ? AppColors.neutral25 : AppColors.primary100,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: widget.onLocationPressed,
                                child: Icon(Icons.location_on_outlined, color: AppColors.primary100, size: 24),
                              ),
                            ],
                          ),
                        ),
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
}
