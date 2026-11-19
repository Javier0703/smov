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

  /// Nivel 3: Las 50 provincias de España.
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

/// Geometría de comunidades obtenida de `Mapa de la expedición.svg`.
abstract final class SpainMapCatalog {
  static const List<SpainMapRegion> autonomousCommunities = <SpainMapRegion>[
    SpainMapRegion(
      id: 'galicia',
      name: 'Galicia',
      shortLabel: 'GAL',
      capital: 'Santiago de Compostela',
      svgPath: 'M63.3 15.3999L76.9 21.7999L73.8 26.0999L81.3 32.7999L77.6 36.0999L81.5 40.0999L76 49.8999L81.3 50.3999L82.1 57.7999L68.6 68.8999L53.1 68.5999L52.4 59.4999L38.3 67.2999L37.7 60.5999L43.8 55.8999L38.3 56.8999L42.9 52.0999L36.8 51.0999L41.3 45.0999L34.7 49.6999L38.2 41.2999L33.7 43.6999L29.3 35.0999L38.9 27.2999L52.2 27.7999L49.8 21.3999L63.3 15.3999Z',
      labelCenter: Offset(55.7, 42.1),
      neighbors: <String>['asturias', 'castilla_y_leon'],
      curiosity: 'Famosa por sus rías, la Torre de Hércules y la meta del Camino de Santiago.',
    ),
    SpainMapRegion(
      id: 'asturias',
      name: 'Principado de Asturias',
      shortLabel: 'AST',
      capital: 'Oviedo',
      svgPath: 'M102 18.8L129.7 29.1L82.4 39.8L73.8 26L102 18.8Z',
      labelCenter: Offset(101.8, 29.3),
      neighbors: <String>['galicia', 'cantabria', 'castilla_y_leon'],
      curiosity:
          'Tierra de los Picos de Europa, verdes valles y costa cantábrica.',
    ),
    SpainMapRegion(
      id: 'cantabria',
      name: 'Cantabria',
      shortLabel: 'CAN',
      capital: 'Santander',
      svgPath: 'M149.2 22.8L158.4 28.4L143.8 34.4L142.4 42.9L122.7 33.3L129.8 26L149.2 22.8Z',
      labelCenter: Offset(140.6, 32.9),
      neighbors: <String>['asturias', 'pais_vasco', 'castilla_y_leon'],
      curiosity:
          'Alberga la Cueva de Altamira, joya del arte rupestre prehistórico.',
    ),
    SpainMapRegion(
      id: 'pais_vasco',
      name: 'País Vasco',
      shortLabel: 'PVA',
      capital: 'Vitoria-Gasteiz',
      svgPath: 'M166.9 24.3L188.3 28.7L170.1 50.9L155.8 40.1L162 38.3L152.2 30.3L166.9 24.3Z',
      labelCenter: Offset(170.2, 37.6),
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
      svgPath: 'M189.9 28.3L195.5 29.8L194.3 35.4L209.4 38.8L197.9 48.9L194.8 66L184.7 62.9L189.3 58.5L172.1 47.2L189.9 28.3Z',
      labelCenter: Offset(190.8, 47.1),
      neighbors: <String>['pais_vasco', 'la_rioja', 'aragon'],
      curiosity:
          'Desde los bosques de Irati en el Pirineo hasta las Bardenas Reales.',
    ),
    SpainMapRegion(
      id: 'la_rioja',
      name: 'La Rioja',
      shortLabel: 'RIO',
      capital: 'Logroño',
      svgPath: 'M161.7 46.3L189.3 59.5L183.2 65.8L175.9 59.7L163.9 63.4L158.9 58.3L161.7 46.3Z',
      labelCenter: Offset(174.1, 56),
      neighbors: <String>['pais_vasco', 'navarra', 'aragon', 'castilla_y_leon'],
      curiosity:
          'Cuna de las primeras palabras escritas en castellano en San Millán.',
    ),
    SpainMapRegion(
      id: 'aragon',
      name: 'Aragón',
      shortLabel: 'ARA',
      capital: 'Zaragoza',
      svgPath: 'M209 38.7L238.5 45L240.8 54.1L231.5 72.2999L230.5 95.4L216.7 99.6L218.7 107.7L206.4 121.7L188.5 110.1L192.3 95.7L179 82.7999L187.1 71.7L185.9 63.4L195 65.8L197.6 49.5L209 38.7Z',
      labelCenter: Offset(209.9, 80.2),
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
      svgPath: 'M239.6 40.5L253.1 44.2L255.1 51.9H291.2L292.5 65L269 82.8L245.3 89.6L239.2 96L242.8 99L234 103.1L227.9 97.4L228.8 87.3L240.6 55L239.6 40.5Z',
      labelCenter: Offset(260.2, 71.8),
      neighbors: <String>['aragon', 'valencia', 'baleares'],
      curiosity:
          'Destaca por el modernismo de Gaudí, los Pirineos y la Costa Brava.',
    ),
    SpainMapRegion(
      id: 'castilla_y_leon',
      name: 'Castilla y León',
      shortLabel: 'CYL',
      capital: 'Valladolid (sede institucional)',
      svgPath: 'M121.9 30.2L139.1 43.1L144.4 42L140.9 38.2L147.9 31.8L158.5 31.9L162 38.3L155.7 40L164.6 46.4L158.8 49L160.9 61.3L185.6 64.5L187.1 71.7999L179.2 81L181.6 88.5L152.9 83.2999L128.7 111.7L119.5 114.7L93.8 104.5L80.8 110.8L79.1 89.7999L94.6 75.1L87.1 72.1L86.6 64.7L77.9 64.4L83.2 53.9L76 49.9L76.7 44.9L91.1 35L102.7 37.6L121.9 30.2Z',
      labelCenter: Offset(131.6, 72.5),
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
      svgPath: 'M150.3 86.3L153.3 90.6L150.8 96.3L151.7 99L157.4 103.7L158.8 106.7L157.5 110.9L160.3 115.2L150.9 116.3L144.7 120.7L143.2 119.6L148.8 114.7L136.6 109.6L134.1 111.6L132.6 109L128.5 112.1L129.1 108.4L133.8 106.6L134.5 100.7L137.2 100.8L142.5 91.8L150.3 86.3Z',
      labelCenter: Offset(144.4, 103.5),
      neighbors: <String>['castilla_y_leon', 'castilla_la_mancha'],
      curiosity:
          'Situada en el centro peninsular junto a la Sierra de Guadarrama.',
    ),
    SpainMapRegion(
      id: 'extremadura',
      name: 'Extremadura',
      shortLabel: 'EXT',
      capital: 'Mérida',
      svgPath: 'M93.8 104.5L112.4 110.5L111.1 120.9L120.7 134L126.2 132.5L127 140.1L107.7 160L108.3 167.3L94.9 173.2L75.8 167.1L70.6 159.9L78.7 144L66.2 126.7L77.3 126.5L80.5 117.3L77.4 111.5L93.8 104.5Z',
      labelCenter: Offset(96.6, 138.8),
      neighbors: <String>['castilla_y_leon', 'castilla_la_mancha', 'andalucia'],
      curiosity: 'Tierra de dehesas, los ríos Tajo y Guadiana y el Teatro Romano de Mérida.',
    ),
    SpainMapRegion(
      id: 'castilla_la_mancha',
      name: 'Castilla-La Mancha',
      shortLabel: 'CLM',
      capital: 'Toledo',
      svgPath: 'M163.7 81.8999L190.8 92.3999L192.2 101.6L186.7 106.9L200.7 118.5L192.5 132.4L200.2 136.3L198 143.3L204.5 146.2L205.4 152.9L195.2 153L193.6 161.5L181.6 163.4L175.1 171.1L171.1 169.4L170.1 157.9L134.6 162.4L118.7 152L123.2 146.4L120.4 143.1L127 140.2L126.6 133.2L115.4 128.7L111.9 115L132.7 109.1L148.9 114.7L144.5 120.8L159.8 115.8L150.3 86.1999L163.7 81.8999Z',
      labelCenter: Offset(158.7, 126.5),
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
      svgPath: 'M221.2 96.3999L235.4 103.6L217.7 132.3L221.3 144.9L229.5 151.8L214 162.7L208.2 175.9L201.8 161.8L205.2 147.6L198.1 143.5L200.2 136.4L192.7 129.8L199.4 119.1L207.9 120.9L218.7 107.8L216.6 99.7999L221.2 96.3999Z',
      labelCenter: Offset(214.1, 136.1),
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
      svgPath: 'M200.5 151.5L210.2 181.6L186.6 186.9L183.2 175.2L175.7 169.9L191.9 162.9L194.8 153.4L200.5 151.5Z',
      labelCenter: Offset(192.9, 169.2),
      neighbors: <String>['valencia', 'castilla_la_mancha', 'andalucia'],
      curiosity:
          'Conocida como la huerta de Europa y por la laguna del Mar Menor.',
    ),
    SpainMapRegion(
      id: 'andalucia',
      name: 'Andalucía',
      shortLabel: 'AND',
      capital: 'Sevilla',
      svgPath: 'M118.8 152L134.5 162.4L170.1 157.8L171 169.3L183.1 175.2V181.9L190.3 188.5L180 205.8L131.9 206.2L106.8 225.6L95.6 217.6L87.6 199.2L69 193.7L67 182.3L79 166L99.6 171.7L118.8 152Z',
      labelCenter: Offset(128.7, 188.8),
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
      svgPath: 'M292.1 118.8L290.4 123.5L297.6 125.3L289 137.5L273.9 129.4L292.1 118.8ZM310.6 115.3L314.6 122.7L304.8 119.7L310.6 115.3ZM256.8 141.5L254.1 149.2L250.3 148.2L256.8 141.5Z',
      labelCenter: Offset(282.5, 132.2),
      neighbors: <String>['cataluna', 'valencia'],
      curiosity: 'Archipiélago mediterráneo formado por Mallorca, Menorca, Ibiza y Formentera.',
    ),
    SpainMapRegion(
      id: 'canarias',
      name: 'Islas Canarias',
      shortLabel: 'ICN',
      capital: 'Santa Cruz de Tenerife / Las Palmas',
      svgPath: 'M65.6 255.357L58.6 265.52L55.8 265.918L51.8 259.841L65.6 255.357ZM106.4 252.368L107.6 256.055L105.9 261.435L98.5 265.121L95.3 264.822L100.4 262.132L104.1 253.265L106.4 252.368ZM78.9 262.73L80 267.213L78.8 269.405L75.6 270.7L72.3 268.907L71.4 266.416L73.7001 262.929L78.9 262.73ZM114 243.9L113.7 248.184L106.7 250.575L107.8 247.387L114 243.9ZM34 250.575L37.4 252.667L35.3 257.848L32.3 252.368L34 250.575ZM45.7 262.032L48.6 263.627L47.4 265.32L44.1 264.224L45.7 262.032ZM32.3 267.811L36.3 266.815L37.3 269.804L33.3 270.8L32.3 267.811Z',
      labelCenter: Offset(73.2, 257.4),
      neighbors: <String>['andalucia'],
      curiosity: 'Archipiélago volcánico atlántico donde se alza el Teide, el pico más alto de España.',
    ),
    SpainMapRegion(
      id: 'ceuta',
      name: 'Ceuta',
      shortLabel: 'CEU',
      capital: 'Ceuta',
      svgPath: 'M196 225L204 225L204 231L196 231Z',
      labelCenter: Offset(200, 228),
      neighbors: <String>['andalucia', 'melilla'],
      curiosity: 'Ciudad autónoma situada a orillas del estrecho de Gibraltar.',
    ),
    SpainMapRegion(
      id: 'melilla',
      name: 'Melilla',
      shortLabel: 'MEL',
      capital: 'Melilla',
      svgPath: 'M213 225L221 225L221 231L213 231Z',
      labelCenter: Offset(217, 228),
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

  /// Las celdas representan las 50 provincias y mantienen la misma mecánica
  /// vectorial de selección y arrastre que los otros modos del mapa.
  static const List<(String, String, String, String, int, int)>
  _spainProvinceGrid = <(String, String, String, String, int, int)>[
    ('a_coruna', 'A Coruña', 'COR', 'A Coruña', 0, 0),
    ('lugo', 'Lugo', 'LUG', 'Lugo', 0, 1),
    ('asturias_prov', 'Asturias', 'AST', 'Oviedo', 0, 2),
    ('cantabria_prov', 'Cantabria', 'CAN', 'Santander', 0, 3),
    ('bizkaia', 'Bizkaia', 'BIZ', 'Bilbao', 0, 4),
    ('gipuzkoa', 'Gipuzkoa', 'GIP', 'Donostia-San Sebastián', 0, 5),
    ('navarra_prov', 'Navarra', 'NAV', 'Pamplona', 0, 6),
    ('huesca', 'Huesca', 'HUE', 'Huesca', 0, 7),
    ('lleida', 'Lleida', 'LLE', 'Lleida', 0, 8),
    ('girona', 'Girona', 'GIR', 'Girona', 0, 9),
    ('pontevedra', 'Pontevedra', 'PON', 'Pontevedra', 1, 0),
    ('ourense', 'Ourense', 'OUR', 'Ourense', 1, 1),
    ('leon_prov', 'León', 'LEO', 'León', 1, 2),
    ('palencia_prov', 'Palencia', 'PAL', 'Palencia', 1, 3),
    ('burgos_prov', 'Burgos', 'BUR', 'Burgos', 1, 4),
    ('alava', 'Álava', 'ALA', 'Vitoria-Gasteiz', 1, 5),
    ('la_rioja_prov', 'La Rioja', 'RIO', 'Logroño', 1, 6),
    ('zaragoza', 'Zaragoza', 'ZAR', 'Zaragoza', 1, 7),
    ('barcelona', 'Barcelona', 'BCN', 'Barcelona', 1, 8),
    ('zamora', 'Zamora', 'ZAM', 'Zamora', 2, 0),
    ('valladolid_prov', 'Valladolid', 'VLL', 'Valladolid', 2, 1),
    ('soria_prov', 'Soria', 'SOR', 'Soria', 2, 2),
    ('segovia_prov', 'Segovia', 'SEG', 'Segovia', 2, 3),
    ('guadalajara', 'Guadalajara', 'GUA', 'Guadalajara', 2, 4),
    ('teruel', 'Teruel', 'TER', 'Teruel', 2, 5),
    ('tarragona', 'Tarragona', 'TAR', 'Tarragona', 2, 6),
    ('illes_balears', 'Illes Balears', 'BAL', 'Palma', 2, 9),
    ('salamanca_prov', 'Salamanca', 'SAL', 'Salamanca', 3, 0),
    ('avila_prov', 'Ávila', 'AVI', 'Ávila', 3, 1),
    ('madrid_prov', 'Madrid', 'MAD', 'Madrid', 3, 2),
    ('caceres', 'Cáceres', 'CAC', 'Cáceres', 3, 3),
    ('toledo', 'Toledo', 'TOL', 'Toledo', 3, 4),
    ('cuenca', 'Cuenca', 'CUE', 'Cuenca', 3, 5),
    ('castellon', 'Castellón', 'CAS', 'Castellón de la Plana', 3, 6),
    ('valencia_prov', 'Valencia', 'VAL', 'Valencia', 3, 7),
    ('badajoz', 'Badajoz', 'BAD', 'Badajoz', 4, 1),
    ('ciudad_real', 'Ciudad Real', 'CR', 'Ciudad Real', 4, 2),
    ('cordoba', 'Córdoba', 'COR', 'Córdoba', 4, 3),
    ('jaen', 'Jaén', 'JAE', 'Jaén', 4, 4),
    ('albacete', 'Albacete', 'ALB', 'Albacete', 4, 5),
    ('alicante', 'Alicante', 'ALI', 'Alicante', 4, 6),
    ('murcia_prov', 'Región de Murcia', 'MUR', 'Murcia', 4, 7),
    ('granada', 'Granada', 'GRA', 'Granada', 4, 8),
    ('huelva', 'Huelva', 'HUE', 'Huelva', 5, 1),
    ('sevilla', 'Sevilla', 'SEV', 'Sevilla', 5, 2),
    ('cadiz', 'Cádiz', 'CAD', 'Cádiz', 5, 3),
    ('malaga', 'Málaga', 'MAL', 'Málaga', 5, 4),
    ('almeria', 'Almería', 'ALM', 'Almería', 5, 5),
    ('las_palmas', 'Las Palmas', 'LPA', 'Las Palmas de Gran Canaria', 5, 8),
    (
      'santa_cruz_tenerife',
      'Santa Cruz de Tenerife',
      'SCT',
      'Santa Cruz de Tenerife',
      5,
      9,
    ),
  ];

  static final List<SpainMapRegion> spainProvinces =
      _buildSpainProvinceRegions();

  static List<SpainMapRegion> _buildSpainProvinceRegions() {
    return _spainProvinceGrid
        .map((province) {
          final left = 8.0 + province.$6 * 25.0;
          final top = 7.0 + province.$5 * 21.0;
          const width = 23.0;
          const height = 18.0;
          return SpainMapRegion(
            id: province.$1,
            name: province.$2,
            shortLabel: province.$3,
            capital: province.$4,
            svgPath:
                'M$left $top L${left + width} $top '
                'L${left + width} ${top + height} L$left ${top + height} Z',
            labelCenter: Offset(left + width / 2, top + height / 2),
          );
        })
        .toList(growable: false);
  }

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
    this.onRegionDrop,
  });

  final SpainMapMode mode;
  final Set<String> completedRegionIds;
  final String? selectedRegionId;
  final String? targetRegionId;
  final Set<String> hintRegionIds;
  final List<String> routeRegionIds;
  final bool showLabels;
  final ValueChanged<SpainMapRegion>? onRegionTap;
  final void Function(SpainMapRegion dragged, SpainMapRegion target)?
  onRegionDrop;

  static const Size _communityViewBox = Size(350, 288);
  static const double _provinceViewBoxWidth = 264;
  static const double _provinceViewBoxHeight = 136;

  @override
  Widget build(BuildContext context) {
    final regions = SpainMapCatalog.regionsForMode(mode);
    final viewBox = mode == SpainMapMode.autonomousCommunities
        ? _communityViewBox
        : const Size(_provinceViewBoxWidth, _provinceViewBoxHeight);

    return AspectRatio(
      aspectRatio: viewBox.width / viewBox.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Semantics(
            label: 'Mapa interactivo de España',
            child: DragTarget<SpainMapRegion>(
              onWillAcceptWithDetails: (_) => onRegionDrop != null,
              onAcceptWithDetails: (details) {
                final renderObject = context.findRenderObject();
                if (renderObject is! RenderBox) return;
                final localPosition = renderObject.globalToLocal(
                  details.offset,
                );
                final target = _regionAtPosition(
                  localPosition,
                  regions: regions,
                  width: width,
                  height: height,
                  viewBoxWidth: viewBox.width,
                  viewBoxHeight: viewBox.height,
                );
                if (target != null) {
                  onRegionDrop?.call(details.data, target);
                }
              },
              builder: (context, candidates, rejected) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: onRegionTap == null
                      ? null
                      : (details) {
                          final region = _regionAtPosition(
                            details.localPosition,
                            regions: regions,
                            width: width,
                            height: height,
                            viewBoxWidth: viewBox.width,
                            viewBoxHeight: viewBox.height,
                          );
                          if (region != null) onRegionTap!(region);
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
                      viewBoxWidth: viewBox.width,
                      viewBoxHeight: viewBox.height,
                      isCastillaYLeonZoom:
                          mode == SpainMapMode.castillaYLeonProvinces,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  SpainMapRegion? _regionAtPosition(
    Offset position, {
    required List<SpainMapRegion> regions,
    required double width,
    required double height,
    required double viewBoxWidth,
    required double viewBoxHeight,
  }) {
    final svgPoint = Offset(
      (position.dx / width) * viewBoxWidth,
      (position.dy / height) * viewBoxHeight,
    );

    for (final region in regions.reversed) {
      if (SvgPathParser.parse(region.svgPath).contains(svgPoint)) {
        return region;
      }
    }

    SpainMapRegion? closest;
    var minDistance = 18.0;
    for (final region in regions) {
      final distance = (region.labelCenter - svgPoint).distance;
      if (distance < minDistance) {
        minDistance = distance;
        closest = region;
      }
    }
    return closest;
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
    required this.viewBoxWidth,
    required this.viewBoxHeight,
    required this.isCastillaYLeonZoom,
  });

  final List<SpainMapRegion> regions;
  final Set<String> completedRegionIds;
  final String? selectedRegionId;
  final String? targetRegionId;
  final Set<String> hintRegionIds;
  final List<String> routeRegionIds;
  final bool showLabels;
  final double viewBoxWidth;
  final double viewBoxHeight;
  final bool isCastillaYLeonZoom;

  Path _roundedRegionPath(String svgPath) {
    final path = Path();
    final contours = RegExp(r'[Mm]([^Mm]*)').allMatches(svgPath);

    for (final contour in contours) {
      final coordinates = RegExp(r'-?\d+(?:\.\d+)?')
          .allMatches(contour.group(1)!)
          .map((match) => double.parse(match.group(0)!))
          .toList(growable: false);
      if (coordinates.length < 6) continue;

      final points = <Offset>[
        for (var index = 0; index + 1 < coordinates.length; index += 2)
          Offset(coordinates[index], coordinates[index + 1]),
      ];
      if (points.length < 3) continue;

      final beforeCorners = <Offset>[];
      final afterCorners = <Offset>[];
      for (var index = 0; index < points.length; index++) {
        final previous = points[(index - 1 + points.length) % points.length];
        final current = points[index];
        final next = points[(index + 1) % points.length];
        final incomingLength = (current - previous).distance;
        final outgoingLength = (next - current).distance;
        if (incomingLength == 0 || outgoingLength == 0) continue;

        final cornerOffset =
            1.6 < incomingLength * 0.3 && 1.6 < outgoingLength * 0.3
            ? 1.6
            : (incomingLength < outgoingLength
                      ? incomingLength
                      : outgoingLength) *
                  0.3;
        beforeCorners.add(
          current + (previous - current) * (cornerOffset / incomingLength),
        );
        afterCorners.add(
          current + (next - current) * (cornerOffset / outgoingLength),
        );
      }

      if (beforeCorners.length != points.length) continue;
      path.moveTo(afterCorners.first.dx, afterCorners.first.dy);
      for (var index = 1; index < points.length; index++) {
        path.lineTo(beforeCorners[index].dx, beforeCorners[index].dy);
        path.quadraticBezierTo(
          points[index].dx,
          points[index].dy,
          afterCorners[index].dx,
          afterCorners[index].dy,
        );
      }
      path.lineTo(beforeCorners.first.dx, beforeCorners.first.dy);
      path.quadraticBezierTo(
        points.first.dx,
        points.first.dy,
        afterCorners.first.dx,
        afterCorners.first.dy,
      );
      path.close();
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / viewBoxWidth;
    final scaleY = size.height / viewBoxHeight;

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

    // Dibujar cada región
    for (final region in regions) {
      final path = _roundedRegionPath(region.svgPath);
      final isCompleted = completedRegionIds.contains(region.id);
      final isSelected = selectedRegionId == region.id;
      final isTarget = targetRegionId == region.id;
      final isHint = hintRegionIds.contains(region.id);
      final isInRoute = routeRegionIds.contains(region.id);

      Color fillColor = const Color(0xFFDCE7F3);
      Color strokeColor = AppColors.brandPrimary;
      double strokeWidth = 1.2;

      if (isCompleted) {
        fillColor = AppColors.success;
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
      if (isSelected && !isCompleted) {
        fillColor = AppColors.brandAccent;
        strokeColor = AppColors.brandPrimary;
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
        oldDelegate.viewBoxWidth != viewBoxWidth ||
        oldDelegate.viewBoxHeight != viewBoxHeight ||
        oldDelegate.isCastillaYLeonZoom != isCastillaYLeonZoom;
  }
}
