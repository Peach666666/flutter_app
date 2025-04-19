class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;
  final String difficulty;
  final String category;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.difficulty,
    required this.category,
    this.isFavorite = false,
  });

  // Конвертация в JSON для сохранения
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'description': description,
    'ingredients': ingredients,
    'steps': steps,
    'calories': calories,
    'proteins': proteins,
    'fats': fats,
    'carbs': carbs,
    'difficulty': difficulty,
    'category': category,
    'isFavorite': isFavorite,
  };

  // Загрузка из JSON
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    title: json['title'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    ingredients: List<String>.from(json['ingredients']),
    steps: List<String>.from(json['steps']),
    calories: json['calories'],
    proteins: json['proteins'],
    fats: json['fats'],
    carbs: json['carbs'],
    difficulty: json['difficulty'],
    category: json['category'],
    isFavorite: json['isFavorite'],
  );
}
