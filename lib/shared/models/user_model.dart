import 'ciclo_escolar.dart';
import 'role_enum.dart';

/// Configuración inmutable de capas del Avatar (Especificación 02 · Personalización del avatar).
enum AvatarPresentation {
  boy('Niño'),
  girl('Niña');

  final String label;
  const AvatarPresentation(this.label);
}

enum AvatarHair {
  shortHair('Corto'),
  longHair('Largo'),
  curlyHair('Rizado');

  final String label;
  const AvatarHair(this.label);
}

typedef AvatarHairStyle = AvatarHair;

enum AvatarSkinTone {
  light('clara'),
  medium('media'),
  dark('oscura');

  final String label;
  const AvatarSkinTone(this.label);
}

enum AvatarEyes {
  brown('marrones'),
  green('verdes'),
  blue('azules');

  final String label;
  const AvatarEyes(this.label);
}

typedef AvatarEyeColor = AvatarEyes;

enum AvatarGlasses {
  none('sin'),
  round('redondas');

  final String label;
  const AvatarGlasses(this.label);
}

enum AvatarOutfit {
  tshirt('Camiseta de manga corta'),
  redHoodie('Sudadera roja'),
  navyPolo('Polo azul');

  final String label;
  const AvatarOutfit(this.label);
}

class AvatarConfig {
  final AvatarPresentation presentation;
  final AvatarHair hair;
  final AvatarSkinTone skinTone;
  final AvatarEyes eyes;
  final AvatarGlasses glasses;
  final AvatarOutfit outfit;

  const AvatarConfig({
    this.presentation = AvatarPresentation.boy,
    this.hair = AvatarHair.shortHair,
    this.skinTone = AvatarSkinTone.light,
    this.eyes = AvatarEyes.brown,
    this.glasses = AvatarGlasses.none,
    this.outfit = AvatarOutfit.tshirt,
  });

  AvatarConfig copyWith({
    AvatarPresentation? presentation,
    AvatarHair? hair,
    AvatarSkinTone? skinTone,
    AvatarEyes? eyes,
    AvatarGlasses? glasses,
    AvatarOutfit? outfit,
  }) {
    return AvatarConfig(
      presentation: presentation ?? this.presentation,
      hair: hair ?? this.hair,
      skinTone: skinTone ?? this.skinTone,
      eyes: eyes ?? this.eyes,
      glasses: glasses ?? this.glasses,
      outfit: outfit ?? this.outfit,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'presentation': presentation.name,
    'hair': hair.name,
    'skinTone': skinTone.name,
    'eyes': eyes.name,
    'glasses': glasses.name,
    'outfit': outfit.name,
  };

  factory AvatarConfig.fromJson(Map<String, dynamic> json) {
    return AvatarConfig(
      presentation: AvatarPresentation.values.firstWhere(
        (e) => e.name == json['presentation'],
        orElse: () => AvatarPresentation.boy,
      ),
      hair: AvatarHair.values.firstWhere(
        (e) => e.name == json['hair'],
        orElse: () => AvatarHair.shortHair,
      ),
      skinTone: AvatarSkinTone.values.firstWhere(
        (e) => e.name == json['skinTone'],
        orElse: () => AvatarSkinTone.light,
      ),
      eyes: AvatarEyes.values.firstWhere(
        (e) => e.name == json['eyes'],
        orElse: () => AvatarEyes.brown,
      ),
      glasses: AvatarGlasses.values.firstWhere(
        (e) => e.name == json['glasses'],
        orElse: () => AvatarGlasses.none,
      ),
      outfit: AvatarOutfit.values.firstWhere(
        (e) => e.name == json['outfit'],
        orElse: () => AvatarOutfit.tshirt,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AvatarConfig &&
        other.presentation == presentation &&
        other.hair == hair &&
        other.skinTone == skinTone &&
        other.eyes == eyes &&
        other.glasses == glasses &&
        other.outfit == outfit;
  }

  @override
  int get hashCode =>
      Object.hash(presentation, hair, skinTone, eyes, glasses, outfit);
}

/// Modelo transversal de usuario (Alumno o Docente).
class UserModel {
  final String id;
  final String classId;
  final String displayName;
  final String username;
  final RoleEnum role;
  final CicloEscolar cicloEscolar;
  final AvatarConfig avatarConfig;
  final int explorerLevel;
  final int streakDays;
  final int coins;

  const UserModel({
    required this.id,
    required this.classId,
    required this.displayName,
    this.username = 'alex.4a',
    required this.role,
    this.cicloEscolar = CicloEscolar.segundoCiclo,
    required this.avatarConfig,
    this.explorerLevel = 3,
    this.streakDays = 2,
    this.coins = 240,
  });

  UserModel copyWith({
    String? id,
    String? classId,
    String? displayName,
    String? username,
    RoleEnum? role,
    CicloEscolar? cicloEscolar,
    AvatarConfig? avatarConfig,
    int? explorerLevel,
    int? streakDays,
    int? coins,
  }) {
    return UserModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      role: role ?? this.role,
      cicloEscolar: cicloEscolar ?? this.cicloEscolar,
      avatarConfig: avatarConfig ?? this.avatarConfig,
      explorerLevel: explorerLevel ?? this.explorerLevel,
      streakDays: streakDays ?? this.streakDays,
      coins: coins ?? this.coins,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'classId': classId,
    'displayName': displayName,
    'username': username,
    'role': role.name,
    'avatarConfig': avatarConfig.toJson(),
    'explorerLevel': explorerLevel,
    'streakDays': streakDays,
    'coins': coins,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'student_alex',
      classId: json['classId'] as String? ?? '4A',
      displayName: json['displayName'] as String? ?? 'Alex',
      username: json['username'] as String? ?? 'alex.4a',
      role: RoleEnum.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => RoleEnum.estudiante,
      ),
      avatarConfig: json['avatarConfig'] is Map<String, dynamic>
          ? AvatarConfig.fromJson(json['avatarConfig'] as Map<String, dynamic>)
          : const AvatarConfig(),
      explorerLevel: json['explorerLevel'] as int? ?? 3,
      streakDays: json['streakDays'] as int? ?? 2,
      coins: json['coins'] as int? ?? 240,
    );
  }
}
