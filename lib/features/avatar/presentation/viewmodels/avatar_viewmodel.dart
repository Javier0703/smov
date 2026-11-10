import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/models/avatar_editor_state_model.dart';
import '../../data/repositories/avatar_repository.dart';

/// ViewModel de `Tu personaje, a tu manera` (`/avatar`).
class AvatarViewModel extends ChangeNotifier {
  AvatarViewModel({required this._repository}) {
    loadState();
  }

  final AvatarRepository _repository;

  AvatarConfig _savedConfig = const AvatarConfig();
  AvatarConfig _draftConfig = const AvatarConfig();
  String _explorerName = 'Alex';
  bool _isSaving = false;
  String? _errorMessage;

  AvatarConfig get savedConfig => _savedConfig;
  AvatarConfig get draftConfig => _draftConfig;
  String get explorerName => _explorerName;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  bool get hasUnsavedChanges => _savedConfig != _draftConfig;

  void loadState() {
    final result = _repository.loadAvatarEditorState();
    switch (result) {
      case Success<AvatarEditorStateModel>(:final data):
        _savedConfig = data.savedConfig;
        _draftConfig = data.draftConfig;
        _explorerName = data.explorerName;
        _errorMessage = null;
      case Error<AvatarEditorStateModel>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  void setPresentation(AvatarPresentation value) {
    _draftConfig = _draftConfig.copyWith(presentation: value);
    notifyListeners();
  }

  void setHair(AvatarHair value) {
    _draftConfig = _draftConfig.copyWith(hair: value);
    notifyListeners();
  }

  void setSkinTone(AvatarSkinTone value) {
    _draftConfig = _draftConfig.copyWith(skinTone: value);
    notifyListeners();
  }

  void setEyes(AvatarEyes value) {
    _draftConfig = _draftConfig.copyWith(eyes: value);
    notifyListeners();
  }

  void setGlasses(AvatarGlasses value) {
    _draftConfig = _draftConfig.copyWith(glasses: value);
    notifyListeners();
  }

  void setOutfit(AvatarOutfit value) {
    _draftConfig = _draftConfig.copyWith(outfit: value);
    notifyListeners();
  }

  void discardChanges() {
    _draftConfig = _savedConfig;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.saveAvatarConfig(_draftConfig);
    _isSaving = false;
    switch (result) {
      case Success<AvatarConfig>(:final data):
        _savedConfig = data;
        _draftConfig = data;
        notifyListeners();
        return true;
      case Error<AvatarConfig>(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return false;
    }
  }
}
