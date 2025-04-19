import 'package:flutter/material.dart';
import 'package:flutter_app/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';
import 'models/recipe_list.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (ctx) => RecipeList(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кулинарная книга',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/": (context) => HomeScreen(),
        "/add-recipe": (context) => AddRecipeScreen(),
      },
      initialRoute: "/",
    );
  }
}
