/// Validadores puros para formularios de alumnado y panel docente (SKILL 3.3).
class Validators {
  const Validators._();

  /// Valida el nombre del personaje: entre 1 y 20 caracteres tras recortar espacios.
  static String? validateExplorerName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Escribe un nombre para tu personaje (1 a 20 caracteres).';
    }
    if (trimmed.length > 20) {
      return 'El nombre puede tener como máximo 20 caracteres.';
    }
    return null;
  }

  /// Valida el enunciado de una pregunta creada por el docente.
  static String? validateQuestionPrompt(String? value) =>
      questionStatement(value);

  static String? questionStatement(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'El enunciado de la prueba no puede estar vacío.';
    }
    if (trimmed.length < 10) {
      return 'Escribe un enunciado de al menos 10 caracteres.';
    }
    return null;
  }

  static String? answerOption(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Esta opción de respuesta es obligatoria.';
    }
    return null;
  }

  /// Valida que la respuesta seleccionada pertenezca al temario del nivel activo.
  static String? validateAnswerInCurriculum(
    String? answer,
    List<String> validTerritories,
  ) {
    final trimmed = answer?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Selecciona una respuesta correcta del temario.';
    }
    if (!validTerritories.contains(trimmed)) {
      return 'La respuesta debe pertenecer al territorio de este nivel.';
    }
    return null;
  }
}
