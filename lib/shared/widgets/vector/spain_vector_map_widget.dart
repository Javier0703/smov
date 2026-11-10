import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/svg_path_parser.dart';

/// Modo territorial del mapa vectorial interactivo de España.
enum SpainMapMode {
  /// Nivel 1: 17 Comunidades Autónomas + Ceuta y Melilla.
  autonomousCommunities,

  /// Nivel 2: Las 9 provincias de Castilla y León.
  castillaYLeonProvinces,

  /// Nivel 3: Provincias de España (selección representativa nacional).
  spainProvinces,
}

/// Definición inmutable de una región poligonal en el mapa vectorial.
class SpainMapRegion {
  const SpainMapRegion({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.capital,
    required this.svgPath,
    required this.labelCenter,
    this.neighbors = const <String>[],
    this.curiosity = '',
  });

  final String id;
  final String name;
  final String shortLabel;
  final String capital;
  final String svgPath;
  final Offset labelCenter;
  final List<String> neighbors;
  final String curiosity;
}

/// Catálogo oficial de regiones vectoriales de España basado en `Mapa de la expedición.svg`.
abstract final class SpainMapCatalog {
  static const List<SpainMapRegion> autonomousCommunities = <SpainMapRegion>[
    SpainMapRegion(
      id: 'galicia',
      name: 'Galicia',
      shortLabel: 'GAL',
      capital: 'Santiago de Compostela',
      svgPath: 'M34 15L58 12L62 28L55 40L32 39L28 24Z',
      labelCenter: Offset(45, 26),
      neighbors: <String>['asturias', 'castilla_y_leon'],
      curiosity: 'Famosa por sus rías, la Torre de Hércules y la meta del Camino de Santiago.',
    ),
    SpainMapRegion(
      id: 'asturias',
      name: 'Principado de Asturias',
      shortLabel: 'AST',
      capital: 'Oviedo',
      svgPath: 'M58 12L85 11L86 24L62 28Z',
      labelCenter: Offset(72, 19),
      neighbors: <String>['galicia', 'cantabria', 'castilla_y_leon'],
      curiosity:
          'Tierra de los Picos de Europa, verdes valles y costa cantábrica.',
    ),
    SpainMapRegion(
      id: 'cantabria',
      name: 'Cantabria',
      shortLabel: 'CAN',
      capital: 'Santander',
      svgPath: 'M85 11L103 13L104 25L86 24Z',
      labelCenter: Offset(94, 18),
      neighbors: <String>['asturias', 'pais_vasco', 'castilla_y_leon'],
      curiosity:
          'Alberga la Cueva de Altamira, joya del arte rupestre prehistórico.',
    ),
    SpainMapRegion(
      id: 'pais_vasco',
      name: 'País Vasco',
      shortLabel: 'PVA',
      capital: 'Vitoria-Gasteiz',
      svgPath: 'M103 13L122 14L120 27L104 25Z',
      labelCenter: Offset(112, 20),
      neighbors: <String>[
        'cantabria',
        'navarra',
        'la_rioja',
        'castilla_y_leon',
      ],
      curiosity:
          'Une tradición marinera, montes verdes y arquitectura moderna.',
    ),
    SpainMapRegion(
      id: 'navarra',
      name: 'Comunidad Foral de Navarra',
      shortLabel: 'NAV',
      capital: 'Pamplona',
      svgPath: 'M122 14L140 16L138 35L120 27Z',
      labelCenter: Offset(130, 23),
      neighbors: <String>['pais_vasco', 'la_rioja', 'aragon'],
      curiosity:
          'Desde los bosques de Irati en el Pirineo hasta las Bardenas Reales.',
    ),
    SpainMapRegion(
      id: 'la_rioja',
      name: 'La Rioja',
      shortLabel: 'RIO',
      capital: 'Logroño',
      svgPath: 'M104 25L120 27L122 38L105 37Z',
      labelCenter: Offset(113, 32),
      neighbors: <String>['pais_vasco', 'navarra', 'aragon', 'castilla_y_leon'],
      curiosity:
          'Cuna de las primeras palabras escritas en castellano en San Millán.',
    ),
    SpainMapRegion(
      id: 'aragon',
      name: 'Aragón',
      shortLabel: 'ARA',
      capital: 'Zaragoza',
      svgPath: 'M140 16L168 20L170 59L142 63L138 35Z',
      labelCenter: Offset(154, 40),
      neighbors: <String>[
        'navarra',
        'la_rioja',
        'castilla_y_leon',
        'castilla_la_mancha',
        'valencia',
        'cataluna',
      ],
      curiosity: 'Atravesada por el río Ebro y coronada por el pico Aneto en los Pirineos.',
    ),
    SpainMapRegion(
      id: 'cataluna',
      name: 'Cataluña',
      shortLabel: 'CAT',
      capital: 'Barcelona',
      svgPath: 'M168 20L205 24L196 56L170 59Z',
      labelCenter: Offset(185, 39),
      neighbors: <String>['aragon', 'valencia', 'baleares'],
      curiosity:
          'Destaca por el modernismo de Gaudí, los Pirineos y la Costa Brava.',
    ),
    SpainMapRegion(
      id: 'castilla_y_leon',
      name: 'Castilla y León',
      shortLabel: 'CYL',
      capital: 'Valladolid (sede institucional)',
      svgPath: 'M55 40L62 28L104 25L105 37L122 38L138 35L140 58L112 64L59 61Z',
      labelCenter: Offset(94, 46),
      neighbors: <String>[
        'galicia',
        'asturias',
        'cantabria',
        'pais_vasco',
        'la_rioja',
        'aragon',
        'castilla_la_mancha',
        'madrid',
        'extremadura',
      ],
      curiosity: 'La comunidad más extensa de España, formada por 9 provincias históricas.',
    ),
    SpainMapRegion(
      id: 'madrid',
      name: 'Comunidad de Madrid',
      shortLabel: 'MAD',
      capital: 'Madrid',
      svgPath: 'M105 62L122 60L125 76L104 77Z',
      labelCenter: Offset(114, 69),
      neighbors: <String>['castilla_y_leon', 'castilla_la_mancha'],
      curiosity:
          'Situada en el centro peninsular junto a la Sierra de Guadarrama.',
    ),
    SpainMapRegion(
      id: 'extremadura',
      name: 'Extremadura',
      shortLabel: 'EXT',
      capital: 'Mérida',
      svgPath: 'M54 62L86 63L87 98L52 96Z',
      labelCenter: Offset(70, 80),
      neighbors: <String>['castilla_y_leon', 'castilla_la_mancha', 'andalucia'],
      curiosity: 'Tierra de dehesas, los ríos Tajo y Guadiana y el Teatro Romano de Mérida.',
    ),
    SpainMapRegion(
      id: 'castilla_la_mancha',
      name: 'Castilla-La Mancha',
      shortLabel: 'CLM',
      capital: 'Toledo',
      svgPath:
          'M86 63L104 63L104 77L125 76L122 60L142 63L156 88L128 101L87 98Z',
      labelCenter: Offset(118, 84),
      neighbors: <String>[
        'castilla_y_leon',
        'madrid',
        'aragon',
        'valencia',
        'murcia',
        'andalucia',
        'extremadura',
      ],
      curiosity:
          'Famosa por sus molinos de viento y las aventuras de Don Quijote.',
    ),
    SpainMapRegion(
      id: 'valencia',
      name: 'Comunidad Valenciana',
      shortLabel: 'VAL',
      capital: 'Valencia',
      svgPath: 'M170 59L189 58L178 99L156 88L142 63Z',
      labelCenter: Offset(168, 76),
      neighbors: <String>[
        'cataluna',
        'aragon',
        'castilla_la_mancha',
        'murcia',
        'baleares',
      ],
      curiosity:
          'Bañada por el Mediterráneo, famosa por la Albufera y sus huertas.',
    ),
    SpainMapRegion(
      id: 'murcia',
      name: 'Región de Murcia',
      shortLabel: 'MUR',
      capital: 'Murcia',
      svgPath: 'M156 88L178 99L165 113L146 105Z',
      labelCenter: Offset(161, 101),
      neighbors: <String>['valencia', 'castilla_la_mancha', 'andalucia'],
      curiosity:
          'Conocida como la huerta de Europa y por la laguna del Mar Menor.',
    ),
    SpainMapRegion(
      id: 'andalucia',
      name: 'Andalucía',
      shortLabel: 'AND',
      capital: 'Sevilla',
      svgPath: 'M52 96L87 98L128 101L146 105L165 113L135 125L62 122Z',
      labelCenter: Offset(104, 111),
      neighbors: <String>[
        'extremadura',
        'castilla_la_mancha',
        'murcia',
        'ceuta',
        'melilla',
        'canarias',
      ],
      curiosity: 'Recorrida por el Guadalquivir y coronada por Sierra Nevada.',
    ),
    SpainMapRegion(
      id: 'baleares',
      name: 'Islas Baleares',
      shortLabel: 'BAL',
      capital: 'Palma',
      svgPath: 'M212 68L236 64L239 81L214 84Z',
      labelCenter: Offset(225, 74),
      neighbors: <String>['cataluna', 'valencia'],
      curiosity: 'Archipiélago mediterráneo formado por Mallorca, Menorca, Ibiza y Formentera.',
    ),
    SpainMapRegion(
      id: 'canarias',
      name: 'Islas Canarias',
      shortLabel: 'ICN',
      capital: 'Santa Cruz de Tenerife / Las Palmas',
      svgPath: 'M16 108L60 105L62 124L15 125Z',
      labelCenter: Offset(38, 116),
      neighbors: <String>['andalucia'],
      curiosity: 'Archipiélago volcánico atlántico donde se alza el Teide, el pico más alto de España.',
    ),
    SpainMapRegion(
      id: 'ceuta',
      name: 'Ceuta',
      shortLabel: 'CEU',
      capital: 'Ceuta',
      svgPath: 'M84 125L102 125L102 133L84 133Z',
      labelCenter: Offset(93, 129),
      neighbors: <String>['andalucia', 'melilla'],
      curiosity: 'Ciudad autónoma situada a orillas del estrecho de Gibraltar.',
    ),
    SpainMapRegion(
      id: 'melilla',
      name: 'Melilla',
      shortLabel: 'MEL',
      capital: 'Melilla',
      svgPath: 'M116 125L136 125L136 133L116 133Z',
      labelCenter: Offset(126, 129),
      neighbors: <String>['andalucia', 'ceuta'],
      curiosity:
          'Ciudad autónoma mediterránea con una gran ciudadela histórica.',
    ),
  ];

  /// Las 9 provincias de Castilla y León para el Nivel 2 de `España en tus manos`.
  static const List<SpainMapRegion> castillaYLeonProvinces = <SpainMapRegion>[
    SpainMapRegion(
      id: 'leon',
      name: 'León',
      shortLabel: 'LEÓ',
      capital: 'León',
      svgPath: 'M42 20L102 18L104 52L46 54Z',
      labelCenter: Offset(73, 36),
      curiosity:
          'Destaca por su Catedral gótica, Las Médulas y los Picos de Europa.',
    ),
    SpainMapRegion(
      id: 'palencia',
      name: 'Palencia',
      shortLabel: 'PAL',
      capital: 'Palencia',
      svgPath: 'M102 18L136 20L135 66L104 65Z',
      labelCenter: Offset(119, 42),
      curiosity: 'Ruta del Románico más grande de Europa y Canal de Castilla.',
    ),
    SpainMapRegion(
      id: 'burgos',
      name: 'Burgos',
      shortLabel: 'BUR',
      capital: 'Burgos',
      svgPath: 'M136 20L182 18L180 72L135 66Z',
      labelCenter: Offset(158, 44),
      curiosity:
          'Tierra del Cid, su gran Catedral y los yacimientos de Atapuerca.',
    ),
    SpainMapRegion(
      id: 'zamora',
      name: 'Zamora',
      shortLabel: 'ZAM',
      capital: 'Zamora',
      svgPath: 'M46 54L96 53L95 86L44 84Z',
      labelCenter: Offset(70, 70),
      curiosity:
          'Bañada por el río Duero y el Lago de Sanabria, de origen glaciar.',
    ),
    SpainMapRegion(
      id: 'valladolid',
      name: 'Valladolid',
      shortLabel: 'VAL',
      capital: 'Valladolid',
      svgPath: 'M96 53L135 55L134 90L95 86Z',
      labelCenter: Offset(115, 72),
      curiosity: 'Situada en el corazón de la meseta norte, junto al Pisuerga y el Duero.',
    ),
    SpainMapRegion(
      id: 'soria',
      name: 'Soria',
      shortLabel: 'SOR',
      capital: 'Soria',
      svgPath: 'M180 56L226 58L224 94L178 92Z',
      labelCenter: Offset(202, 75),
      curiosity:
          'Aquí nace el río Duero en los Picos de Urbión y se halla Numancia.',
    ),
    SpainMapRegion(
      id: 'salamanca',
      name: 'Salamanca',
      shortLabel: 'SAL',
      capital: 'Salamanca',
      svgPath: 'M44 84L95 86L94 118L42 116Z',
      labelCenter: Offset(68, 101),
      curiosity: 'Célebre por su Universidad histórica y su Plaza Mayor.',
    ),
    SpainMapRegion(
      id: 'avila',
      name: 'Ávila',
      shortLabel: 'ÁVI',
      capital: 'Ávila',
      svgPath: 'M95 86L134 90L133 120L94 118Z',
      labelCenter: Offset(114, 104),
      curiosity:
          'Rodeada por su muralla medieval completa y la Sierra de Gredos.',
    ),
    SpainMapRegion(
      id: 'segovia',
      name: 'Segovia',
      shortLabel: 'SEG',
      capital: 'Segovia',
      svgPath: 'M134 72L178 72L176 114L133 112Z',
      labelCenter: Offset(155, 93),
      curiosity: 'Famosa por su Acueducto romano y su Alcázar sobre la roca.',
    ),
  ];

  /// Selección de provincias de España para el Nivel 3 de `España en tus manos`.
  static const List<SpainMapRegion> spainProvinces = <SpainMapRegion>[
    SpainMapRegion(
      id: 'a_coruna',
      name: 'A Coruña',
      shortLabel: 'COR',
      capital: 'A Coruña',
      svgPath: 'M30 14L48 12L50 28L30 28Z',
      labelCenter: Offset(40, 20),
    ),
    SpainMapRegion(
      id: 'asturias_prov',
      name: 'Asturias',
      shortLabel: 'AST',
      capital: 'Oviedo',
      svgPath: 'M58 12L85 11L86 24L62 28Z',
      labelCenter: Offset(72, 19),
    ),
    SpainMapRegion(
      id: 'bizkaia',
      name: 'Bizkaia',
      shortLabel: 'BIZ',
      capital: 'Bilbao',
      svgPath: 'M103 13L118 14L117 26L104 25Z',
      labelCenter: Offset(110, 19),
    ),
    SpainMapRegion(
      id: 'zaragoza',
      name: 'Zaragoza',
      shortLabel: 'ZAR',
      capital: 'Zaragoza',
      svgPath: 'M140 28L168 30L168 52L140 52Z',
      labelCenter: Offset(154, 40),
    ),
    SpainMapRegion(
      id: 'barcelona',
      name: 'Barcelona',
      shortLabel: 'BCN',
      capital: 'Barcelona',
      svgPath: 'M178 24L204 26L196 52L176 50Z',
      labelCenter: Offset(189, 38),
    ),
    SpainMapRegion(
      id: 'valladolid_prov',
      name: 'Valladolid',
      shortLabel: 'VLL',
      capital: 'Valladolid',
      svgPath: 'M82 36L110 36L110 56L82 56Z',
      labelCenter: Offset(96, 46),
    ),
    SpainMapRegion(
      id: 'madrid_prov',
      name: 'Madrid',
      shortLabel: 'MAD',
      capital: 'Madrid',
      svgPath: 'M105 60L125 60L125 77L104 77Z',
      labelCenter: Offset(115, 68),
    ),
    SpainMapRegion(
      id: 'caceres',
      name: 'Cáceres',
      shortLabel: 'CÁC',
      capital: 'Cáceres',
      svgPath: 'M54 62L86 63L86 80L53 79Z',
      labelCenter: Offset(70, 71),
    ),
    SpainMapRegion(
      id: 'toledo',
      name: 'Toledo',
      shortLabel: 'TOL',
      capital: 'Toledo',
      svgPath: 'M88 77L124 77L124 94L88 94Z',
      labelCenter: Offset(106, 85),
    ),
    SpainMapRegion(
      id: 'valencia_prov',
      name: 'Valencia',
      shortLabel: 'VLC',
      capital: 'Valencia',
      svgPath: 'M158 64L184 64L178 90L156 88Z',
      labelCenter: Offset(170, 77),
    ),
    SpainMapRegion(
      id: 'sevilla',
      name: 'Sevilla',
      shortLabel: 'SEV',
      capital: 'Sevilla',
      svgPath: 'M62 98L96 98L96 120L62 120Z',
      labelCenter: Offset(79, 109),
    ),
    SpainMapRegion(
      id: 'granada',
      name: 'Granada',
      shortLabel: 'GRA',
      capital: 'Granada',
      svgPath: 'M112 102L144 104L140 123L110 122Z',
      labelCenter: Offset(126, 113),
    ),
  ];

  static List<SpainMapRegion> regionsForMode(SpainMapMode mode) {
    switch (mode) {
      case SpainMapMode.autonomousCommunities:
        return autonomousCommunities;
      case SpainMapMode.castillaYLeonProvinces:
        return castillaYLeonProvinces;
      case SpainMapMode.spainProvinces:
        return spainProvinces;
    }
  }

  static SpainMapRegion? findById(
    String id, {
    SpainMapMode mode = SpainMapMode.autonomousCommunities,
  }) {
    for (final region in regionsForMode(mode)) {
      if (region.id == id) return region;
    }
    return null;
  }
}

/// Mapa vectorial interactivo de España basado en `Mapa de la expedición.svg`.
///
/// Soporta:
/// - Toque directo sobre polígonos autonómicos o provinciales
/// - Resaltado de regiones completadas, seleccionadas, sugeridas (pista) y ruta activa
/// - Trazo de ruta conectada entre comunidades limítrofes (para `El viaje por España`)
class SpainVectorMapWidget extends StatelessWidget {
  const SpainVectorMapWidget({
    super.key,
    this.mode = SpainMapMode.autonomousCommunities,
    this.completedRegionIds = const <String>{},
    this.selectedRegionId,
    this.targetRegionId,
    this.hintRegionIds = const <String>{},
    this.routeRegionIds = const <String>[],
    this.showLabels = true,
    this.onRegionTap,
  });

  final SpainMapMode mode;
  final Set<String> completedRegionIds;
  final String? selectedRegionId;
  final String? targetRegionId;
  final Set<String> hintRegionIds;
  final List<String> routeRegionIds;
  final bool showLabels;
  final ValueChanged<SpainMapRegion>? onRegionTap;

  static const double _viewBoxWidth = 264.0;
  static const double _viewBoxHeight = 136.0;

  @override
  Widget build(BuildContext context) {
    final regions = SpainMapCatalog.regionsForMode(mode);

    return AspectRatio(
      aspectRatio: _viewBoxWidth / _viewBoxHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Semantics(
            label: 'Mapa interactivo de España',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: onRegionTap == null
                  ? null
                  : (details) {
                      final local = details.localPosition;
                      final svgX = (local.dx / width) * _viewBoxWidth;
                      final svgY = (local.dy / height) * _viewBoxHeight;
                      final svgPoint = Offset(svgX, svgY);

                      for (final region in regions.reversed) {
                        final path = SvgPathParser.parse(region.svgPath);
                        if (path.contains(svgPoint)) {
                          onRegionTap!(region);
                          return;
                        }
                      }
                      // Fallback al centro más cercano si el toque estuvo en el borde
                      SpainMapRegion? closest;
                      var minDistance = 18.0;
                      for (final region in regions) {
                        final dist = (region.labelCenter - svgPoint).distance;
                        if (dist < minDistance) {
                          minDistance = dist;
                          closest = region;
                        }
                      }
                      if (closest != null) {
                        onRegionTap!(closest);
                      }
                    },
              child: CustomPaint(
                size: Size(width, height),
                painter: _SpainVectorMapPainter(
                  regions: regions,
                  completedRegionIds: completedRegionIds,
                  selectedRegionId: selectedRegionId,
                  targetRegionId: targetRegionId,
                  hintRegionIds: hintRegionIds,
                  routeRegionIds: routeRegionIds,
                  showLabels: showLabels,
                  isCastillaYLeonZoom:
                      mode == SpainMapMode.castillaYLeonProvinces,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpainVectorMapPainter extends CustomPainter {
  _SpainVectorMapPainter({
    required this.regions,
    required this.completedRegionIds,
    required this.selectedRegionId,
    required this.targetRegionId,
    required this.hintRegionIds,
    required this.routeRegionIds,
    required this.showLabels,
    required this.isCastillaYLeonZoom,
  });

  final List<SpainMapRegion> regions;
  final Set<String> completedRegionIds;
  final String? selectedRegionId;
  final String? targetRegionId;
  final Set<String> hintRegionIds;
  final List<String> routeRegionIds;
  final bool showLabels;
  final bool isCastillaYLeonZoom;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 264.0;
    final scaleY = size.height / 136.0;

    // Fondo marítimo / cartográfico
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(18),
    );
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = isCastillaYLeonZoom
            ? const Color(0xFFF3EFE6)
            : const Color(0xFFEAF4FB)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = AppColors.borderDefault
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Recuadro insular Canarias cuando es mapa nacional
    if (!isCastillaYLeonZoom) {
      final canariasBox = RRect.fromRectAndRadius(
        const Rect.fromLTWH(10, 101, 56, 28),
        const Radius.circular(6),
      );
      canvas.drawRRect(
        canariasBox,
        Paint()
          ..color = AppColors.brandPrimary.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }

    // Dibujar cada región
    for (final region in regions) {
      final path = SvgPathParser.parse(region.svgPath);
      final isCompleted = completedRegionIds.contains(region.id);
      final isSelected = selectedRegionId == region.id;
      final isTarget = targetRegionId == region.id;
      final isHint = hintRegionIds.contains(region.id);
      final isInRoute = routeRegionIds.contains(region.id);

      Color fillColor = const Color(0xFFDCE7F3);
      Color strokeColor = AppColors.brandPrimary;
      double strokeWidth = 1.2;

      if (isCompleted) {
        fillColor = AppColors.brandAccent.withValues(alpha: 0.55);
        strokeColor = AppColors.brandPrimary;
      }
      if (isInRoute) {
        fillColor = AppColors.brandHighlight.withValues(alpha: 0.72);
      }
      if (isHint) {
        fillColor = const Color(0xFFFFE08A);
        strokeColor = const Color(0xFFD97706);
        strokeWidth = 1.8;
      }
      if (isTarget) {
        fillColor = AppColors.brandAccent;
        strokeColor = AppColors.brandPrimary;
        strokeWidth = 2.0;
      }
      if (isSelected) {
        fillColor = AppColors.brandPrimary;
        strokeColor = AppColors.inkStrong;
        strokeWidth = 2.2;
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Dibujar línea de itinerario si hay ruta activa (El viaje por España)
    if (routeRegionIds.length >= 2) {
      final routePaint = Paint()
        ..color = AppColors.danger
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final routePath = Path();
      var started = false;
      for (final id in routeRegionIds) {
        final region = regions.where((r) => r.id == id).firstOrNull;
        if (region == null) continue;
        if (!started) {
          routePath.moveTo(region.labelCenter.dx, region.labelCenter.dy);
          started = true;
        } else {
          routePath.lineTo(region.labelCenter.dx, region.labelCenter.dy);
        }
      }
      canvas.drawPath(routePath, routePaint);

      for (final id in routeRegionIds) {
        final region = regions.where((r) => r.id == id).firstOrNull;
        if (region == null) continue;
        canvas.drawCircle(
          region.labelCenter,
          3.2,
          Paint()..color = AppColors.danger,
        );
      }
    }

    // Etiquetas abreviadas sobre cada polígono
    if (showLabels) {
      for (final region in regions) {
        final isSelected = selectedRegionId == region.id;
        final textSpan = TextSpan(
          text: region.shortLabel,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: isCastillaYLeonZoom ? 7.5 : 5.4,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : AppColors.inkStrong,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(
            region.labelCenter.dx - textPainter.width / 2,
            region.labelCenter.dy - textPainter.height / 2,
          ),
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SpainVectorMapPainter oldDelegate) {
    return oldDelegate.regions != regions ||
        oldDelegate.completedRegionIds != completedRegionIds ||
        oldDelegate.selectedRegionId != selectedRegionId ||
        oldDelegate.targetRegionId != targetRegionId ||
        oldDelegate.hintRegionIds != hintRegionIds ||
        oldDelegate.routeRegionIds != routeRegionIds ||
        oldDelegate.showLabels != showLabels ||
        oldDelegate.isCastillaYLeonZoom != isCastillaYLeonZoom;
  }
}
