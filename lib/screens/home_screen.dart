import 'package:flutter/material.dart';
import 'package:flutter_app/models/recipe.dart';
import 'package:flutter_app/screens/add_recipe_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../models/recipe_list.dart';
import 'recipe_detail.dart';

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
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: FutureBuilder(
        future: recipeList.loadRecipes(),
        builder:
            (ctx, snapshot) => GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: recipeList.recipes.length,
              itemBuilder:
                  (ctx, index) => Dismissible(
                    key: Key(recipeList.recipes[index].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed:
                        (_) => recipeList.removeRecipe(
                          recipeList.recipes[index].id,
                        ),
                    child: RecipeCard(recipe: recipeList.recipes[index]),
                  ),
            ),
      ),
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
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: recipe.id,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => RecipeDetailScreen(recipe: recipe),
                ),
              ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Chip(label: Text(recipe.category)),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            recipe.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed:
                              () => Provider.of<RecipeList>(
                                context,
                                listen: false,
                              ).toggleFavorite(recipe.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
