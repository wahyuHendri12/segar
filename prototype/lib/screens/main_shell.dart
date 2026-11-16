import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/common.dart';
import 'add_ingredient_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'recipes_screen.dart';
import 'stats_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    if (index == 2) {
      _openAddIngredient();
      return;
    }
    setState(() => _currentIndex = index);
  }

  Future<void> _openAddIngredient() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddIngredientScreen()),
    );
    if (saved == true && mounted) {
      showSegarSnack(context, 'Bahan baru berhasil disimpan ke pantry.');
      setState(() => _currentIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        onOpenRecipes: () => _selectTab(1),
        onOpenProfile: () => _selectTab(4),
      ),
      RecipesScreen(
        onOpenProfile: () => _selectTab(4),
      ),
      // Placeholder for the raised center "add" slot (nav index 2).
      const SizedBox.shrink(),
      const StatsScreen(),
      ProfileScreen(
        onOpenStats: () => _selectTab(3),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: SegarBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
        onAdd: _openAddIngredient,
      ),
    );
  }
}
