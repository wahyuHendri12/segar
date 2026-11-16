import '../../data/local/enums.dart';

/// Digits only, so barcodes copied with spaces or dashes still match.
String normalizeBarcode(String raw) => raw.replaceAll(RegExp(r'[^0-9]'), '');

/// EAN-8 through ITF-14 are accepted.
bool isValidBarcode(String raw) {
  final normalized = normalizeBarcode(raw);
  return normalized.length >= 8 && normalized.length <= 14;
}

/// Best-effort category for a product from a barcode database.
///
/// Open Food Facts categories are inconsistent, so the product name is used as
/// a fallback and anything unknown lands in `lainnya`.
IngredientCategory guessCategory({String? categories, String? name}) {
  final haystack = '${categories ?? ''} ${name ?? ''}'.toLowerCase();
  if (haystack.trim().isEmpty) return IngredientCategory.lainnya;

  const rules = <IngredientCategory, List<String>>{
    IngredientCategory.ikanSeafood: <String>[
      'ikan',
      'fish',
      'seafood',
      'udang',
      'shrimp',
      'prawn',
      'cumi',
      'squid',
      'tuna',
      'salmon',
      'kepiting',
      'crab',
      'kerang',
      'shellfish',
      'tongkol',
    ],
    IngredientCategory.daging: <String>[
      'daging',
      'meat',
      'beef',
      'sapi',
      'ayam',
      'chicken',
      'pork',
      'babi',
      'kambing',
      'lamb',
      'mutton',
      'sosis',
      'sausage',
      'nugget',
      'ham',
      'bacon',
      'dendeng',
    ],
    IngredientCategory.telurSusu: <String>[
      'telur',
      'egg',
      'susu',
      'milk',
      'keju',
      'cheese',
      'yogurt',
      'yoghurt',
      'mentega',
      'butter',
      'krim',
      'cream',
      'dairy',
    ],
    IngredientCategory.sayur: <String>[
      'sayur',
      'vegetable',
      'veggie',
      'bayam',
      'spinach',
      'wortel',
      'carrot',
      'brokoli',
      'broccoli',
      'kangkung',
      'sawi',
      'cabbage',
      'tomat',
      'tomato',
      'timun',
      'cucumber',
      'paprika',
      'bell pepper',
      'selada',
      'lettuce',
      'jamur',
      'mushroom',
      'kentang',
      'potato',
      'bawang bombay',
      'onion',
    ],
    IngredientCategory.buah: <String>[
      'buah',
      'fruit',
      'apple',
      'apel',
      'pisang',
      'banana',
      'jeruk',
      'orange',
      'mangga',
      'mango',
      'anggur',
      'grape',
      'semangka',
      'watermelon',
      'melon',
      'pepaya',
      'papaya',
      'nanas',
      'pineapple',
      'stroberi',
      'strawberry',
      'alpukat',
      'avocado',
      'kiwi',
      'pir',
      'pear',
    ],
    IngredientCategory.bumbu: <String>[
      'bumbu',
      'spice',
      'rempah',
      'saus',
      'sauce',
      'kecap',
      'soy sauce',
      'garam',
      'salt',
      'gula',
      'sugar',
      'merica',
      'pepper',
      'cabe',
      'cabai',
      'chili',
      'bawang putih',
      'bawang merah',
      'garlic',
      'jahe',
      'ginger',
      'kunyit',
      'turmeric',
      'ketumbar',
      'coriander',
      'kaldu',
      'broth',
    ],
    IngredientCategory.bahanKering: <String>[
      'beras',
      'rice',
      'mie',
      'noodle',
      'pasta',
      'tepung',
      'flour',
      'gandum',
      'wheat',
      'oat',
      'sereal',
      'cereal',
      'kacang',
      'bean',
      'lentil',
      'jagung',
      'corn',
      'biskuit',
      'cracker',
      'roti',
      'bread',
    ],
    IngredientCategory.minuman: <String>[
      'minuman',
      'drink',
      'beverage',
      'jus',
      'juice',
      'kopi',
      'coffee',
      'teh',
      'tea',
      'soda',
      'air mineral',
      'mineral water',
      'sirup',
      'syrup',
      'boba',
    ],
    IngredientCategory.makananOlahan: <String>[
      'olahan',
      'processed',
      'instan',
      'instant',
      'kaleng',
      'canned',
      'frozen',
      'beku',
      'siap saji',
      'ready meal',
      'snack',
      'keripik',
      'chips',
      'cokelat',
      'chocolate',
      'es krim',
      'ice cream',
    ],
  };

  for (final entry in rules.entries) {
    for (final keyword in entry.value) {
      if (_containsWord(haystack, keyword)) return entry.key;
    }
  }
  return IngredientCategory.lainnya;
}

bool _containsWord(String haystack, String keyword) {
  final escaped = RegExp.escape(keyword);
  return RegExp('(^|[^a-z])$escaped([^a-z]|\$)').hasMatch(haystack);
}

/// Reads a pack size such as "500 g" or "1 L" from a barcode database.
({double quantity, Unit unit})? parsePackQuantity(String? text) {
  if (text == null) return null;
  final lower = text.toLowerCase().replaceAll(',', '.');
  final match = RegExp(
    r'(\d+(?:\.\d+)?)\s*(kg|kilogram|g|gr|gram|ml|mililiter|l|lt|liter|pcs|pc|butir|bungkus|botol|kaleng|ikat|siung)\b',
  ).firstMatch(lower);
  if (match == null) return null;

  final quantity = double.tryParse(match.group(1)!);
  if (quantity == null || quantity <= 0) return null;

  final unit = switch (match.group(2)!) {
    'kg' || 'kilogram' => Unit.kg,
    'g' || 'gr' || 'gram' => Unit.gram,
    'ml' || 'mililiter' => Unit.ml,
    'l' || 'lt' || 'liter' => Unit.liter,
    'pcs' || 'pc' => Unit.pcs,
    'butir' => Unit.butir,
    'bungkus' => Unit.bungkus,
    'botol' => Unit.botol,
    'kaleng' => Unit.kaleng,
    'ikat' => Unit.ikat,
    'siung' => Unit.siung,
    _ => Unit.pcs,
  };
  return (quantity: quantity, unit: unit);
}
