import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/core/utils/recipe_match.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/pantry_item_view.dart';
import 'package:segar/data/models/recipe_view.dart';

void main() {
  final now = DateTime(2026, 11, 10);

  PantryItemView pantryItem({
    String id = 'p1',
    String name = 'Bayam',
    String? catalogId = 'bayam',
    DateTime? expiryDate,
  }) {
    final expiry = expiryDate ?? DateTime(2026, 11, 12);
    return PantryItemView(
      id: id,
      catalogId: catalogId,
      name: name,
      emoji: '🥬',
      category: IngredientCategory.sayur,
      quantity: 1,
      unit: Unit.ikat,
      storageLocation: StorageLocation.kulkas,
      purchaseDate: DateTime(2026, 11, 9),
      expiryDate: expiry,
      expirySource: ExpirySource.estimasi,
      notifyEnabled: true,
      status: PantryStatus.aktif,
      createdAt: now,
      updatedAt: now,
      expiryStatus: statusFor(expiry, now: now),
      daysLeft: daysUntilExpiry(expiry, now: now),
    );
  }

  RecipeIngredientView ingredient({
    String id = 'i1',
    String name = 'Bayam',
    PantryItemView? matchedItem,
  }) {
    return RecipeIngredientView(
      id: id,
      catalogId: matchedItem?.catalogId,
      name: name,
      amount: 1,
      unit: Unit.ikat,
      isOptional: false,
      isStaple: false,
      matchedItem: matchedItem,
    );
  }

  RecipeView recipe({
    String id = 'r1',
    List<RecipeIngredientView>? ingredients,
  }) {
    return RecipeView(
      id: id,
      title: 'Resep $id',
      emoji: '🍲',
      cookTimeMin: 10,
      difficulty: RecipeDifficulty.mudah,
      servings: 2,
      estimatedCostIdr: 10000,
      isQuick: true,
      tags: const <String>['cepat'],
      steps: const <String>['Masak'],
      ingredients: ingredients ?? const <RecipeIngredientView>[],
      matchScore: 50,
      ownedRequiredCount: 1,
      requiredCount: 1,
    );
  }

  group('smartMatchFor', () {
    test('reports no urgent items when every stock is safe', () {
      final match = smartMatchFor(
        recipes: <RecipeView>[
          recipe(
            ingredients: <RecipeIngredientView>[
              ingredient(
                matchedItem: pantryItem(expiryDate: DateTime(2026, 11, 30)),
              ),
            ],
          ),
        ],
        pantry: <PantryItemView>[
          pantryItem(expiryDate: DateTime(2026, 11, 30)),
        ],
      );

      expect(match.hasUrgent, isFalse);
      expect(match.urgentTotal, 0);
      expect(match.rescuedCount, 0);
      expect(match.missingCount, 0);
    });

    test('counts urgent items rescued by at least one recipe', () {
      final urgent = pantryItem();
      final match = smartMatchFor(
        recipes: <RecipeView>[
          recipe(
            ingredients: <RecipeIngredientView>[
              ingredient(matchedItem: urgent),
            ],
          ),
        ],
        pantry: <PantryItemView>[urgent],
      );

      expect(match.hasUrgent, isTrue);
      expect(match.urgentTotal, 1);
      expect(match.rescuedCount, 1);
      expect(match.rescuedItems.single.id, urgent.id);
      expect(match.missingCount, 0);
    });

    test('counts urgent items no recipe can rescue', () {
      final matched = pantryItem(id: 'p1', name: 'Bayam');
      final unmatched = pantryItem(id: 'p2', name: 'Tomat', catalogId: 'tomat');
      final match = smartMatchFor(
        recipes: <RecipeView>[
          recipe(
            ingredients: <RecipeIngredientView>[
              ingredient(matchedItem: matched),
            ],
          ),
        ],
        pantry: <PantryItemView>[matched, unmatched],
      );

      expect(match.urgentTotal, 2);
      expect(match.rescuedCount, 1);
      expect(match.missingCount, 1);
    });

    test('deduplicates an item rescued by several recipes', () {
      final urgent = pantryItem();
      final recipes = <RecipeView>[
        for (var index = 0; index < 3; index++)
          recipe(
            id: 'r$index',
            ingredients: <RecipeIngredientView>[
              ingredient(matchedItem: urgent),
            ],
          ),
      ];

      final match = smartMatchFor(
        recipes: recipes,
        pantry: <PantryItemView>[urgent],
      );

      expect(match.rescuedCount, 1);
      expect(match.rescuedItems.single.id, urgent.id);
    });

    test('ignores expired pantry items', () {
      final expired = pantryItem(expiryDate: DateTime(2026, 11, 9));
      final match = smartMatchFor(
        recipes: <RecipeView>[
          recipe(
            ingredients: <RecipeIngredientView>[
              ingredient(matchedItem: expired),
            ],
          ),
        ],
        pantry: <PantryItemView>[expired],
      );

      expect(match.hasUrgent, isFalse);
      expect(match.urgentTotal, 0);
      expect(match.rescuedItems, isEmpty);
    });
  });
}
