import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../theme/app_theme.dart';

class AppData {
  AppData._();

  static const urgentIngredients = <Ingredient>[
    Ingredient(
      name: 'Bayam Hijau',
      emoji: '🥬',
      quantity: '1 Ikat',
      storage: StorageLocation.fridge,
      status: FreshnessStatus.soon,
      statusText: '2 hari lagi',
      progress: 0.75,
      imageAsset: 'assets/images/spinach.jpg',
    ),
    Ingredient(
      name: 'Tomat Merah',
      emoji: '🍅',
      quantity: '4 Butir',
      storage: StorageLocation.fridge,
      status: FreshnessStatus.soon,
      statusText: '2 hari lagi',
      progress: 0.80,
      category: 'Sayuran Buah',
    ),
    Ingredient(
      name: 'Susu UHT Full Cream',
      emoji: '🥛',
      quantity: '200 ml',
      storage: StorageLocation.fridge,
      status: FreshnessStatus.expired,
      statusText: 'Basi Besok!',
      progress: 0.95,
      category: 'Susu & Olahan',
    ),
  ];

  static const safeIngredients = <Ingredient>[
    Ingredient(
      name: 'Telur Ayam Negeri',
      emoji: '🥚',
      quantity: '10 Butir',
      storage: StorageLocation.fridge,
      status: FreshnessStatus.safe,
      statusText: 'Aman (12 hari)',
      progress: 0.30,
      category: 'Protein',
    ),
    Ingredient(
      name: 'Daging Dada Ayam',
      emoji: '🍗',
      quantity: '500 gr',
      storage: StorageLocation.freezer,
      status: FreshnessStatus.safe,
      statusText: 'Aman (24 hari)',
      progress: 0.15,
      category: 'Daging & Protein',
    ),
    Ingredient(
      name: 'Bawang Merah',
      emoji: '🧅',
      quantity: '250 gr',
      storage: StorageLocation.pantry,
      status: FreshnessStatus.safe,
      statusText: 'Aman (18 hari)',
      progress: 0.25,
      category: 'Bumbu Dapur',
    ),
  ];

  static const historyIngredients = <Ingredient>[
    Ingredient(
      name: 'Wortel Manis',
      emoji: '🥕',
      quantity: '250 gr',
      storage: StorageLocation.pantry,
      status: FreshnessStatus.safe,
      statusText: 'Terpakai',
      isHistory: true,
      historyNote: 'Habis kemarin • Dimasak jadi sop ayam',
      category: 'Sayuran Akar',
    ),
  ];

  static const allIngredients = <Ingredient>[
    ...urgentIngredients,
    ...safeIngredients,
  ];

  static const recipes = <Recipe>[
    Recipe(
      title: 'Sayur Bening Bayam Jagung Manis',
      imageAsset: 'assets/images/recipe_sayur_bening.jpg',
      badge: 'Hemat 92% Limbah',
      badgeIcon: Icons.eco_rounded,
      badgeColor: AppColors.primary,
      rescue: 'Menyelamatkan: Bayam Hijau (Basi 2 hari lagi)',
      time: '15 Menit',
      difficulty: 'Mudah',
      cost: '~Rp8.000',
      tags: ['fast', 'kuah', 'kos'],
      ingredients: [
        RecipeIngredient('Bayam (Tersedia)', available: true),
        RecipeIngredient('Jagung Manis'),
        RecipeIngredient('Tempe Goreng (Tersedia)', available: true),
      ],
    ),
    Recipe(
      title: 'Sup Telur Tomat Gurih Ala Rumahan',
      imageAsset: 'assets/images/recipe_tomato_egg.jpg',
      badge: 'Populer Kosan',
      badgeIcon: Icons.local_fire_department_rounded,
      badgeColor: AppColors.tertiary,
      rescue: 'Menyelamatkan: 4 Tomat Merah & Telur Ayam',
      time: '10 Menit',
      difficulty: 'Sangat Mudah',
      cost: 'Panci Kecil',
      tags: ['fast', 'kuah', 'kos'],
      description:
          'Resep favorit praktis anak kos dengan kuah hangat asam gurih, cepat matang, dan kaya vitamin C.',
      ingredients: [
        RecipeIngredient('Tomat Matang (Tersedia)', available: true),
        RecipeIngredient('Telur Ayam (Tersedia)', available: true),
        RecipeIngredient('Daun Bawang'),
      ],
    ),
    Recipe(
      title: 'Smoothie Hijau Segar Pisang & Bayam',
      imageAsset: 'assets/images/recipe_smoothie.jpg',
      badge: 'Ultra Cepat',
      badgeIcon: Icons.bolt_rounded,
      badgeColor: AppColors.primary,
      rescue: 'Menyelamatkan: Bayam Hijau & Susu UHT',
      time: '5 Menit',
      difficulty: 'Blender / Halus',
      cost: 'Bebas Repot',
      tags: ['fast', 'kos', 'simple'],
      description:
          'Solusi kilat menghabiskan sisa bayam tanpa rasa langu. Manis alami dari pisang matang dan lembut.',
      ingredients: [
        RecipeIngredient('Bayam Segar (Tersedia)', available: true),
        RecipeIngredient('1 Pisang Ambon'),
        RecipeIngredient('Susu UHT (Tersedia)', available: true),
      ],
    ),
  ];

  static const quickTags = <String>[
    'Tempe',
    'Tahu',
    'Kangkung',
    'Wortel',
    'Ayam',
  ];

  static const units = <String>[
    'Papan',
    'Bungkus',
    'Kilogram (kg)',
    'Gram (gr)',
    'Butir',
    'Ikat',
  ];
}
