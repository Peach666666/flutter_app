import 'package:flutter/material.dart';
import 'package:flutter_app/screens/recipe_detail.dart';
import '../../models/recipe.dart';
import '../recipe_detail.dart';

class HomeScreen extends StatelessWidget {
  final List<Recipe> recipes = [
    Recipe(
      id: '1',
      title: 'Паста Карбонара',
      imageUrl:
          'https://s1.eda.ru/StaticContent/Photos/Upscaled/150525210126/150601174518/p_O.jpg',
      description: 'Классическая итальянская паста',
      ingredients: ['Спагетти', 'Бекон', 'Яйца', 'Сыр Пармезан'],
      steps: ['Варите пасту', 'Обжарьте бекон', 'Смешайте с соусом'],
    ),
    Recipe(
      id: '2',
      title: 'Оливье',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjjazWDRBazBb166PZq7OlOaaY8JNFMLdC2g&s',
      description: 'Новогодний салат',
      ingredients: ['Картофель', 'Морковь', 'Колбаса', 'Горошек'],
      steps: ['Нарежьте ингредиенты', 'Заправьте майонезом'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Книга рецептов')),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (ctx, index) {
          final recipe = recipes[index];
          return Card(
            child: ListTile(
              leading: Image.network(
                recipe.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: Добавить новый рецепт
        },
      ),
    );
  }
}
