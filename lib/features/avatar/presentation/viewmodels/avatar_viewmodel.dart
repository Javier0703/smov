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
  String _savedExplorerName = 'Alex';
  Set<String> _ownedCosmetics = const <String>{};
  bool _isSaving = false;
  String? _errorMessage;

  AvatarConfig get savedConfig => _savedConfig;
  AvatarConfig get draftConfig => _draftConfig;
  String get explorerName => _explorerName;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  Set<String> get ownedCosmetics => _ownedCosmetics;
  bool get hasUnsavedChanges =>
      _savedConfig != _draftConfig || _savedExplorerName != _explorerName;
  bool get canSave => _explorerName.trim().isNotEmpty && !_isSaving;

  void loadState() {
    final result = _repository.loadAvatarEditorState();
    switch (result) {
      case Success<AvatarEditorStateModel>(:final data):
        _savedConfig = data.savedConfig;
        _draftConfig = data.draftConfig;
        _explorerName = data.explorerName;
        _savedExplorerName = data.explorerName;
        _ownedCosmetics = _repository.getOwnedCosmetics();
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
    if (value == AvatarOutfit.explorerJacket &&
        !_ownedCosmetics.contains('explorer_jacket')) {
      return;
    }
    _draftConfig = _draftConfig.copyWith(outfit: value);
    notifyListeners();
  }

  void setAccessory(AvatarAccessory value) {
    if (value == AvatarAccessory.compassBadge &&
        !_ownedCosmetics.contains('compass_badge')) {
      return;
    }
    _draftConfig = _draftConfig.copyWith(accessory: value);
    notifyListeners();
  }

  void setSpecialStyle(AvatarSpecialStyle value) {
    if (value == AvatarSpecialStyle.goldenExplorer &&
        !_ownedCosmetics.contains('golden_avatar')) {
      return;
    }
    _draftConfig = _draftConfig.copyWith(specialStyle: value);
    notifyListeners();
  }

  void setExplorerName(String value) {
    _explorerName = value;
    _errorMessage = value.trim().isEmpty
        ? 'Escribe un nombre para tu explorador.'
        : null;
    notifyListeners();
  }

  void discardChanges() {
    _draftConfig = _savedConfig;
    _explorerName = _savedExplorerName;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    final trimmedName = _explorerName.trim();
    if (trimmedName.isEmpty) {
      _errorMessage = 'Escribe un nombre para tu explorador.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.saveAvatarConfig(
      config: _draftConfig,
      displayName: trimmedName,
    );
    _isSaving = false;
    switch (result) {
      case Success<UserModel>(:final data):
        _savedConfig = data.avatarConfig;
        _draftConfig = data.avatarConfig;
        _savedExplorerName = data.displayName;
        _explorerName = data.displayName;
        notifyListeners();
        return true;
      case Error<UserModel>(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return false;
    }
  }
}
