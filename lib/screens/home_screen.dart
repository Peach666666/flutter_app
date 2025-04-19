import 'package:flutter/material.dart';
import 'package:flutter_app/models/recipe_list.dart';
import 'package:flutter_app/screens/add_recipe_screen.dart';
import 'package:flutter_app/screens/recipe_detail.dart';
import 'package:flutter_app/widgets/recipe_card.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Темная тема'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipeList = Provider.of<RecipeList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Кулинарная книга'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => _showFavorites(context, recipeList),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => SettingsScreen()),
                ),
          ),
        ],
      ),
      body: _buildRecipeGrid(recipeList),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => AddRecipeScreen()),
            ),
      ),
    );
  }

  void _showFavorites(BuildContext context, RecipeList recipeList) {
    final favoriteRecipes =
        recipeList.recipes.where((r) => r.isFavorite).toList();

    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Избранное',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteRecipes.length,
                    itemBuilder:
                        (ctx, index) => ListTile(
                          title: Text(favoriteRecipes[index].title),
                          onTap:
                              () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder:
                                      (ctx) => RecipeDetailScreen(
                                        recipe: favoriteRecipes[index],
                                      ),
                                ),
                              ),
                        ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildRecipeGrid(RecipeList recipeList) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipeList.recipes.length,
      itemBuilder:
          (ctx, index) => RecipeCard(recipe: recipeList.recipes[index]),
    );
  }
}
