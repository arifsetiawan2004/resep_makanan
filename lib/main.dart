import 'package:flutter/material.dart';
import 'package:resep_makanan2/ui/home_screen.dart';
import 'package:resep_makanan2/ui/login_screen.dart';
import 'package:resep_makanan2/ui/register_screen.dart';
import 'package:resep_makanan2/ui/detail_resep.dart';
import 'package:resep_makanan2/ui/edit_resep.dart';
import 'package:resep_makanan2/ui/tambah_resep.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: Menonaktifkan banner debug
      initialRoute:
          '/login', // Halaman pertama yang muncul saat aplikasi dibuka
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/detail_resep': (context) => RecipeDetailScreen(
              recipe: {},
            ), // Halaman detail resep
        '/edit_resep': (context) => EditRecipeScreen(
              recipe: null,
            ), // Halaman edit resep
        '/tambah_resep': (context) => AddRecipeScreen(),
      },
    );
  }
}
