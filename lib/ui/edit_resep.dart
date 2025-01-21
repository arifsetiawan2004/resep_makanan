import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:resep_makanan2/services/session_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditRecipeScreen extends StatefulWidget {
  final dynamic recipe;

  EditRecipeScreen({required this.recipe});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingMethodController = TextEditingController();
  final _ingredientsController = TextEditingController();

  SessionService _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.recipe['title'];
    _descriptionController.text = widget.recipe['description'];
    _cookingMethodController.text = widget.recipe['cooking_method'];
    _ingredientsController.text = widget.recipe['ingredients'];
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _updateRecipe() async {
    final token = await _getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Token tidak ditemukan. Silakan login ulang.')));
      return;
    }

    final recipeId = widget.recipe['id'];

    final response = await http.put(
      Uri.parse("https://recipe.incube.id/api/recipes/$recipeId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'cooking_method': _cookingMethodController.text,
        'ingredients': _ingredientsController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Resep berhasil diperbarui')));
      Navigator.pop(context, data['data']);
    } else {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${errorData['message']}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Edit Recipe", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 113, 42, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Judul Resep",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(255, 113, 42, 1), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(255, 113, 42, 1), width: 2),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cookingMethodController,
                decoration: InputDecoration(
                  labelText: "Langkah Memasak",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(255, 113, 42, 1), width: 2),
                  ),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(
                  labelText: "Bahan-Bahan",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(255, 113, 42, 1), width: 2),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 113, 42, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _updateRecipe,
                  child: Text("Simpan Perubahan",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
