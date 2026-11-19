import 'package:flutter_test/flutter_test.dart';
import 'package:smov/shared/widgets/vector/spain_vector_map_widget.dart';

void main() {
  test('closed community contours retain their clickable area', () {
    final galicia = SpainMapCatalog.findById('galicia')!;

    expect(galicia.toPath().contains(const Offset(55, 42)), isTrue);
  });

  test('horizontal SVG commands preserve the region outline', () {
    final catalonia = SpainMapCatalog.findById('cataluna')!;

    expect(catalonia.toPath().getBounds().right, closeTo(292.5, 0.1));
  });
}
