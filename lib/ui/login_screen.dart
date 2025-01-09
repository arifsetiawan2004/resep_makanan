import 'package:flutter/material.dart';
import 'package:resep_makanan2/services/auth_service.dart';
import 'package:resep_makanan2/services/session_service.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthService _authService = AuthService();
  SessionService _sessionService = SessionService();

  void _login(context) async {
    try {
      final response = await _authService.login(
          _emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response["message"])));
      if (response["status"]) {
        // nampil halaman home
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Text("LOGIN")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text("Belum punya akun? daftar disini!"))
          ],
        ),
      ),
    );
  }
}
