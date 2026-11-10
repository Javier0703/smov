import '../../../../shared/widgets/vector/spain_vector_map_widget.dart';

/// Modelo de una entrada autonómica en `Mi pasaporte`.
class PassportEntryModel {
  const PassportEntryModel({required this.region, required this.isStamped});

  final SpainMapRegion region;
  final bool isStamped;
}
