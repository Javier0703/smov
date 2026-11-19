import 'package:flutter/material.dart';

enum InventoryItemCategory { aid, outfit, accessory, specialAvatar }

/// Modelo de un objeto de ayuda en `Mi mochila`.
class InventoryItemModel {
  const InventoryItemModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.costCoins,
    required this.ownedCount,
    required this.icon,
    this.category = InventoryItemCategory.aid,
    this.requiredMedalNumber,
  });

  final String id;
  final String name;
  final String shortName;
  final String description;
  final int costCoins;
  final int ownedCount;
  final IconData icon;
  final InventoryItemCategory category;
  final int? requiredMedalNumber;

  bool canAfford(int userCoins) => userCoins >= costCoins;
  int missingCoins(int userCoins) =>
      userCoins >= costCoins ? 0 : costCoins - userCoins;
  bool get isOneTimePurchase => category != InventoryItemCategory.aid;
  bool get isOwned => isOneTimePurchase && ownedCount > 0;

  String get categoryLabel => switch (category) {
    InventoryItemCategory.aid => 'Ayuda',
    InventoryItemCategory.outfit => 'Ropa',
    InventoryItemCategory.accessory => 'Accesorio',
    InventoryItemCategory.specialAvatar => 'Avatar especial',
  };
}

/// Comprobante de canje exitoso (`¡Lupa en tu mochila!`).
class RedeemReceiptModel {
  const RedeemReceiptModel({
    required this.transactionId,
    required this.item,
    required this.newOwnedCount,
    required this.remainingCoins,
  });

  final String transactionId;
  final InventoryItemModel item;
  final int newOwnedCount;
  final int remainingCoins;
}
