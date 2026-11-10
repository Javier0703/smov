import 'package:flutter/material.dart';

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
  });

  final String id;
  final String name;
  final String shortName;
  final String description;
  final int costCoins;
  final int ownedCount;
  final IconData icon;

  bool canAfford(int userCoins) => userCoins >= costCoins;
  int missingCoins(int userCoins) =>
      userCoins >= costCoins ? 0 : costCoins - userCoins;
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
