import 'package:flutter/material.dart';
import 'package:resep_makanan2/ui/home_screen.dart';
import 'package:resep_makanan2/ui/login_screen.dart';
import 'package:resep_makanan2/ui/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (contex) => LoginScreen(),
        '/register': (contex) => RegisterScreen(),
        '/home': (contex) => HomeScreen(),
      },
    );
  }
}
