import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/expedition_state_store.dart';
import '../models/inventory_item_model.dart';

/// Servicio de tienda y mochila de explorador.
class InventoryService {
  InventoryService({required this._store});

  final ExpeditionStateStore _store;

  UserModel getCurrentUser() => _store.currentUser;
  Set<int> getUnlockedMedalNumbers() => _store.unlockedMedalNumbers;

  List<InventoryItemModel> fetchItems() {
    final counts = _store.inventoryCounts;
    return <InventoryItemModel>[
      InventoryItemModel(
        id: 'magnifying_glass',
        name: AppStrings.itemMagnifyingGlass,
        shortName: 'lupa',
        description: 'Resalta la casilla o comunidad correcta y muestra la pista detallada en cualquier prueba.',
        costCoins: AppStrings.itemMagnifyingGlassCost,
        ownedCount: counts['magnifying_glass'] ?? 0,
        icon: Icons.search_rounded,
      ),
      InventoryItemModel(
        id: 'hourglass',
        name: AppStrings.itemHourglass,
        shortName: 'reloj de arena',
        description: 'Suma +20 segundos extra de margen en misiones de recorrido y contrarreloj.',
        costCoins: AppStrings.itemHourglassCost,
        ownedCount: counts['hourglass'] ?? 0,
        icon: Icons.hourglass_bottom_rounded,
      ),
      InventoryItemModel(
        id: 'special_compass',
        name: AppStrings.itemSpecialCompass,
        shortName: 'brújula especial',
        description: 'Calibra automáticamente los puntos cardinales y muestra botones de rumbo en el tablero.',
        costCoins: AppStrings.itemSpecialCompassCost,
        ownedCount: counts['special_compass'] ?? 0,
        icon: Icons.explore_rounded,
      ),
      InventoryItemModel(
        id: 'explorer_jacket',
        name: 'Chaqueta exploradora',
        shortName: 'chaqueta exploradora',
        description:
            'Desbloquea una chaqueta verde de expedición para tu avatar.',
        costCoins: 100,
        ownedCount: counts['explorer_jacket'] ?? 0,
        icon: Icons.checkroom_rounded,
        category: InventoryItemCategory.outfit,
        requiredMedalNumber: 2,
      ),
      InventoryItemModel(
        id: 'compass_badge',
        name: 'Insignia de brújula',
        shortName: 'insignia de brújula',
        description:
            'Añade una insignia dorada con forma de brújula a tu ropa.',
        costCoins: 60,
        ownedCount: counts['compass_badge'] ?? 0,
        icon: Icons.explore_rounded,
        category: InventoryItemCategory.accessory,
        requiredMedalNumber: 1,
      ),
      InventoryItemModel(
        id: 'golden_avatar',
        name: 'Explorador dorado',
        shortName: 'avatar Explorador dorado',
        description: 'Desbloquea un estilo dorado exclusivo para tu personaje. Necesitas la medalla Explorador de España.',
        costCoins: 220,
        ownedCount: counts['golden_avatar'] ?? 0,
        icon: Icons.emoji_events_rounded,
        category: InventoryItemCategory.specialAvatar,
        requiredMedalNumber: 8,
      ),
    ];
  }

  Future<bool> redeemItem({
    required String transactionId,
    required String itemId,
    required int costCoins,
    int? requiredMedalNumber,
    bool oneTimePurchase = false,
  }) {
    return _store.redeemInventoryItem(
      transactionId: transactionId,
      itemId: itemId,
      costCoins: costCoins,
      requiredMedalNumber: requiredMedalNumber,
      oneTimePurchase: oneTimePurchase,
    );
  }
}
