import 'package:flutter/material.dart';
import 'package:flutter_app/screens/recipe_detail.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../models/recipe_list.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final recipeList = Provider.of<RecipeList>(context, listen: false);

    return Hero(
      tag: recipe.id,
      child: Card(
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
                child: Image.asset(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(child: Text(recipe.title)),
                    IconButton(
                      icon: Icon(
                        recipe.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => recipeList.toggleFavorite(recipe.id),
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
