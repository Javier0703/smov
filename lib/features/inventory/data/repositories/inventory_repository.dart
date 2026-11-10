import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/inventory_item_model.dart';
import '../services/inventory_service.dart';

/// Repositorio de `Mi mochila` y canje de monedas por ayudas.
class InventoryRepository {
  InventoryRepository({required this._service});

  final InventoryService _service;

  UserModel getCurrentUser() => _service.getCurrentUser();

  Result<List<InventoryItemModel>> loadInventoryItems() {
    try {
      return Success<List<InventoryItemModel>>(_service.fetchItems());
    } catch (e) {
      return Error<List<InventoryItemModel>>(
        CacheFailure('No se pudo cargar tu mochila: $e'),
      );
    }
  }

  Future<Result<RedeemReceiptModel>> redeemItem({
    required String itemId,
    String? customTransactionId,
  }) async {
    try {
      final items = _service.fetchItems();
      final item = items.where((i) => i.id == itemId).firstOrNull;
      if (item == null) {
        return Error<RedeemReceiptModel>(
          ValidationFailure('El objeto $itemId no existe en la tienda.'),
        );
      }

      final userBefore = _service.getCurrentUser();
      if (userBefore.coins < item.costCoins) {
        final missing = item.costCoins - userBefore.coins;
        return Error<RedeemReceiptModel>(
          ValidationFailure(
            'Saldo insuficiente: te faltan $missing monedas para canjear ${item.name}.',
          ),
        );
      }

      final txId =
          customTransactionId ??
          'tx_${item.id}_${DateTime.now().millisecondsSinceEpoch}';
      final success = await _service.redeemItem(
        transactionId: txId,
        itemId: item.id,
        costCoins: item.costCoins,
      );
      if (!success) {
        return const Error<RedeemReceiptModel>(
          ValidationFailure('No se pudo completar el canje.'),
        );
      }

      final updatedItems = _service.fetchItems();
      final updatedItem = updatedItems.firstWhere((i) => i.id == item.id);
      final userAfter = _service.getCurrentUser();

      return Success<RedeemReceiptModel>(
        RedeemReceiptModel(
          transactionId: txId,
          item: updatedItem,
          newOwnedCount: updatedItem.ownedCount,
          remainingCoins: userAfter.coins,
        ),
      );
    } catch (e) {
      return Error<RedeemReceiptModel>(
        CacheFailure('Error al procesar el canje: $e'),
      );
    }
  }
}
