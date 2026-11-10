import '../../../../shared/widgets/vector/medal_badge_widget.dart';

/// Modelo de una medalla del Medallero (`Mi medallero`).
class MedalItemModel {
  const MedalItemModel({
    required this.type,
    required this.subtitle,
    required this.relatedGameId,
    required this.isUnlocked,
  });

  final MedalType type;
  final String subtitle;
  final String relatedGameId;
  final bool isUnlocked;
}
