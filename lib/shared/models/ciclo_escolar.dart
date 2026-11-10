/// Modelo transversal de curso y clase escolar (ej. 4.º de Primaria · 4.º A).
class CicloEscolar {
  final String classId;
  final String className;
  final String gradeLabel;
  final int gradeNumber;

  const CicloEscolar({
    required this.classId,
    required this.className,
    required this.gradeLabel,
    required this.gradeNumber,
  });

  static const CicloEscolar segundoCiclo = CicloEscolar(
    classId: '4A',
    className: '4.º A',
    gradeLabel: '4.º de Primaria (Segundo Ciclo)',
    gradeNumber: 4,
  );

  CicloEscolar copyWith({
    String? classId,
    String? className,
    String? gradeLabel,
    int? gradeNumber,
  }) {
    return CicloEscolar(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      gradeLabel: gradeLabel ?? this.gradeLabel,
      gradeNumber: gradeNumber ?? this.gradeNumber,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'classId': classId,
    'className': className,
    'gradeLabel': gradeLabel,
    'gradeNumber': gradeNumber,
  };

  factory CicloEscolar.fromJson(Map<String, dynamic> json) {
    return CicloEscolar(
      classId: json['classId'] as String? ?? '4A',
      className: json['className'] as String? ?? '4.º A',
      gradeLabel: json['gradeLabel'] as String? ?? '4.º de Primaria',
      gradeNumber: json['gradeNumber'] as int? ?? 4,
    );
  }

  static const List<CicloEscolar> defaultClasses = <CicloEscolar>[
    CicloEscolar(
      classId: '3A',
      className: '3.º A',
      gradeLabel: '3.º de Primaria',
      gradeNumber: 3,
    ),
    CicloEscolar(
      classId: '4A',
      className: '4.º A',
      gradeLabel: '4.º de Primaria',
      gradeNumber: 4,
    ),
    CicloEscolar(
      classId: '4B',
      className: '4.º B',
      gradeLabel: '4.º de Primaria',
      gradeNumber: 4,
    ),
    CicloEscolar(
      classId: '5A',
      className: '5.º A',
      gradeLabel: '5.º de Primaria',
      gradeNumber: 5,
    ),
    CicloEscolar(
      classId: '6A',
      className: '6.º A',
      gradeLabel: '6.º de Primaria',
      gradeNumber: 6,
    ),
  ];
}
