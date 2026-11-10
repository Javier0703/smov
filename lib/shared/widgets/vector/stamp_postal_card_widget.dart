import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Tarjeta vectorial con borde de sello postal dentado/discontinuo (`Sello y postal.svg`).
class StampPostalCardWidget extends StatelessWidget {
  const StampPostalCardWidget({
    super.key,
    required this.communityName,
    required this.capital,
    required this.stamped,
    required this.shortCode,
    this.onTap,
  });

  final String communityName;
  final String capital;
  final bool stamped;
  final String shortCode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label:
          '$communityName, ${stamped ? 'Sello conseguido, pulsa para ver postal' : 'Pendiente de visitar'}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: CustomPaint(
          painter: _DashedStampBorderPainter(stamped: stamped),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: stamped
                  ? AppColors.surfaceElevated
                  : AppColors.surfaceMuted.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: stamped
                            ? AppColors.brandAccent.withValues(alpha: 0.25)
                            : AppColors.borderDefault,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shortCode,
                        style: AppTypography.labelSmall.copyWith(
                          color: stamped
                              ? AppColors.brandPrimary
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(
                      stamped
                          ? Icons.verified_rounded
                          : Icons.lock_outline_rounded,
                      size: 18,
                      color: stamped ? AppColors.success : AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  communityName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    color: stamped ? AppColors.inkStrong : AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                Text(
                  stamped ? 'Postal desbloqueada' : 'Visítala en ruta',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: stamped
                        ? AppColors.brandPrimary
                        : AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: stamped ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedStampBorderPainter extends CustomPainter {
  const _DashedStampBorderPainter({required this.stamped});

  final bool stamped;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppSpacing.radiusMd),
    );
    final paint = Paint()
      ..color = stamped ? AppColors.brandPrimary : AppColors.borderDefault
      ..style = PaintingStyle.stroke
      ..strokeWidth = stamped ? 1.8 : 1.3;

    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashWidth = 6.0;
      const dashSpace = 4.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedStampBorderPainter oldDelegate) {
    return oldDelegate.stamped != stamped;
  }
}
