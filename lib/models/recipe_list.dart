import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'recipe.dart';

class RecipeList with ChangeNotifier {
  List<Recipe> _recipes = [];
  static const _key = 'recipes_data';

  List<Recipe> get recipes => _recipes;

  // Загрузка из SharedPreferences
  Future<void> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _recipes = jsonList.map((json) => Recipe.fromJson(json)).toList();
      notifyListeners();
    } else {
      // Стартовые рецепты
      _recipes = [
        Recipe(
          id: '1',
          title: 'Смузи-боул',
          imageUrl: 'assets/smoothie.jpg',
          description: 'ПП-завтрак за 5 минут',
          calories: 250,
          proteins: 8.5,
          fats: 4.2,
          carbs: 45.0,
          ingredients: ['Банан', 'Шпинат', 'Миндальное молоко'],
          steps: ['Смешать в блендере'],
          difficulty: 'Легко',
          category: 'Завтрак',
        ),
        Recipe(
          id: '2',
          title: 'Лосось в медовом соусе',
          imageUrl: 'assets/salmon.jpg',
          description: 'Идеальный ужин',
          calories: 350,
          proteins: 25.0,
          fats: 18.0,
          carbs: 12.0,
          ingredients: ['Лосось', 'Мёд', 'Лимон'],
          steps: ['Замариновать', 'Запечь 20 мин'],
          difficulty: 'Средне',
          category: 'Ужин',
        ),
        Recipe(
          id: '3',
          title: 'Шоколадный мусс',
          imageUrl: 'assets/mousse.jpg',
          description: 'Десерт без сахара',
          calories: 180,
          proteins: 4.0,
          fats: 12.0,
          carbs: 15.0,
          ingredients: ['Авокадо', 'Какао', 'Мёд'],
          steps: ['Взбить в блендере'],
          difficulty: 'Легко',
          category: 'Десерт',
        ),
      ];
      _saveToPrefs();
    }
  }

  // Сохранение в SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _recipes.map((recipe) => recipe.toJson()).toList();
    await prefs.setString(_key, json.encode(jsonList));
    notifyListeners();
  }

  // Добавление рецепта
  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    _saveToPrefs();
  }

  // Удаление рецепта
  void removeRecipe(String id) {
    _recipes.removeWhere((recipe) => recipe.id == id);
    _saveToPrefs();
  }

  // Избранное
  void toggleFavorite(String id) {
    final index = _recipes.indexWhere((recipe) => recipe.id == id);
    _recipes[index].isFavorite = !_recipes[index].isFavorite;
    _saveToPrefs();
  }
}
