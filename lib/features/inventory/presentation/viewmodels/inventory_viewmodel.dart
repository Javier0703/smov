import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/models/inventory_item_model.dart';
import '../../data/repositories/inventory_repository.dart';

/// ViewModel de `Mi mochila`, `¿Canjear una lupa?` y `¡Lupa en tu mochila!`.
class InventoryViewModel extends ChangeNotifier {
  InventoryViewModel({
    required this._repository,
    this._externalStoreListenable,
  }) {
    _externalStoreListenable?.addListener(refresh);
    refresh();
  }

  final InventoryRepository _repository;
  final Listenable? _externalStoreListenable;

  List<InventoryItemModel> _items = const <InventoryItemModel>[];
  RedeemReceiptModel? _lastReceipt;
  bool _isRedeeming = false;
  String? _errorMessage;

  List<InventoryItemModel> get items => _items;
  RedeemReceiptModel? get lastReceipt => _lastReceipt;
  bool get isRedeeming => _isRedeeming;
  String? get errorMessage => _errorMessage;
  UserModel get currentUser => _repository.getCurrentUser();
  int get coinsBalance => currentUser.coins;

  void refresh() {
    final result = _repository.loadInventoryItems();
    switch (result) {
      case Success<List<InventoryItemModel>>(:final data):
        _items = data;
      case Error<List<InventoryItemModel>>(:final failure):
        _errorMessage = failure.message;
    }
    notifyListeners();
  }

  InventoryItemModel? findItem(String itemId) {
    return _items.where((i) => i.id == itemId).firstOrNull;
  }

  Future<RedeemReceiptModel?> confirmRedeem(
    String itemId, {
    String? customTransactionId,
  }) async {
    _isRedeeming = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.redeemItem(
      itemId: itemId,
      customTransactionId: customTransactionId,
    );

    _isRedeeming = false;
    switch (result) {
      case Success<RedeemReceiptModel>(:final data):
        _lastReceipt = data;
        refresh();
        return data;
      case Error<RedeemReceiptModel>(:final failure):
        _errorMessage = failure.message;
        notifyListeners();
        return null;
    }
  }

  @override
  void dispose() {
    _externalStoreListenable?.removeListener(refresh);
    super.dispose();
  }
}
