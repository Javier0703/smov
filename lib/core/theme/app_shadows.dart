import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Sombras y elevaciones de tarjetas según Figma.
class AppShadows {
  const AppShadows._();

  static final List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.05),
      blurRadius: 14,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> elevatedShadow = <BoxShadow>[
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> pillShadow = <BoxShadow>[
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
