import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/recipe.dart';
import '../models/recipe_list.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _fatsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  File? _image;
  String _difficulty = 'Легко';
  String _category = 'Завтрак';

  final List<String> _difficultyLevels = ['Легко', 'Средне', 'Сложно'];
  final List<String> _categories = ['Завтрак', 'Обед', 'Ужин', 'Десерт'];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _image != null) {
      final newRecipe = Recipe(
        id: DateTime.now().toString(),
        title: _titleController.text,
        imageUrl: _image!.path, // В реальном приложении загружайте на сервер
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split('\n'),
        steps: _stepsController.text.split('\n'),
        calories: int.parse(_caloriesController.text),
        proteins: double.parse(_proteinsController.text),
        fats: double.parse(_fatsController.text),
        carbs: double.parse(_carbsController.text),
        difficulty: _difficulty,
        category: _category,
      );

      Provider.of<RecipeList>(context, listen: false).addRecipe(newRecipe);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить рецепт'),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: _submitForm)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Загрузка изображения
              GestureDetector(
                onTap:
                    () => showModalBottomSheet(
                      context: context,
                      builder:
                          (ctx) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Галерея'),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Камера'),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                            ],
                          ),
                    ),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      _image == null
                          ? Center(child: Text('Добавить фото'))
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                ),
              ),
              SizedBox(height: 20),
              // Основные поля
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Название*'),
                validator:
                    (value) => value!.isEmpty ? 'Обязательное поле' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Описание*'),
                maxLines: 2,
                validator:
                    (value) => value!.isEmpty ? 'Обязательное поле' : null,
              ),
              // БЖУ и калории
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      decoration: InputDecoration(labelText: 'Ккал*'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) => value!.isEmpty ? 'Укажите ккал' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _proteinsController,
                      decoration: InputDecoration(labelText: 'Белки (г)*'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) => value!.isEmpty ? 'Укажите белки' : null,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fatsController,
                      decoration: InputDecoration(labelText: 'Жиры (г)*'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) => value!.isEmpty ? 'Укажите жиры' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: InputDecoration(labelText: 'Углеводы (г)*'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) => value!.isEmpty ? 'Укажите углеводы' : null,
                    ),
                  ),
                ],
              ),
              // Сложность и категория
              DropdownButtonFormField<String>(
                value: _difficulty,
                items:
                    _difficultyLevels.map((level) {
                      return DropdownMenuItem(value: level, child: Text(level));
                    }).toList(),
                onChanged: (value) => setState(() => _difficulty = value!),
                decoration: InputDecoration(labelText: 'Сложность'),
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _category = value!),
                decoration: InputDecoration(labelText: 'Категория'),
              ),
              // Ингредиенты и шаги
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: 'Ингредиенты*',
                  hintText: 'Каждый ингредиент с новой строки',
                ),
                maxLines: 3,
                validator:
                    (value) => value!.isEmpty ? 'Добавьте ингредиенты' : null,
              ),
              TextFormField(
                controller: _stepsController,
                decoration: InputDecoration(
                  labelText: 'Шаги приготовления*',
                  hintText: 'Каждый шаг с новой строки',
                ),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Добавьте шаги' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
