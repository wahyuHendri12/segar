import 'package:flutter/material.dart';

enum FreshnessStatus { safe, soon, expired }

enum StorageLocation {
  fridge('Kulkas', '🧊'),
  freezer('Freezer', '❄️'),
  pantry('Lemari / Pantry', '🧺');

  const StorageLocation(this.label, this.emoji);

  final String label;
  final String emoji;
}

class Ingredient {
  const Ingredient({
    required this.name,
    required this.emoji,
    required this.quantity,
    required this.storage,
    required this.status,
    required this.statusText,
    this.progress = 0,
    this.imageAsset,
    this.category = 'Sayuran Hijau',
    this.addedLabel = 'Ditambahkan 3 hari lalu',
    this.storageDetail = 'Rak Crisper',
    this.isHistory = false,
    this.historyNote,
  });

  final String name;
  final String emoji;
  final String quantity;
  final StorageLocation storage;
  final FreshnessStatus status;
  final String statusText;
  final double progress;
  final String? imageAsset;
  final String category;
  final String addedLabel;
  final String storageDetail;
  final bool isHistory;
  final String? historyNote;
}

class RecipeIngredient {
  const RecipeIngredient(this.name, {this.available = false});

  final String name;
  final bool available;
}

class Recipe {
  const Recipe({
    required this.title,
    required this.imageAsset,
    required this.badge,
    required this.badgeIcon,
    required this.badgeColor,
    required this.rescue,
    required this.time,
    required this.difficulty,
    required this.cost,
    required this.tags,
    required this.ingredients,
    this.description,
  });

  final String title;
  final String imageAsset;
  final String badge;
  final IconData badgeIcon;
  final Color badgeColor;
  final String rescue;
  final String time;
  final String difficulty;
  final String cost;
  final List<String> tags;
  final List<RecipeIngredient> ingredients;
  final String? description;
}
