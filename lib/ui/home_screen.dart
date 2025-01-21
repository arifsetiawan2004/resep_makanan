import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:resep_makanan2/services/session_service.dart';
import 'package:resep_makanan2/ui/detail_resep.dart';
import 'package:resep_makanan2/ui/edit_resep.dart';
import 'package:resep_makanan2/ui/tambah_resep.dart'; // Import halaman Tambah Resep
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SessionService _sessionService = SessionService();
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _allRecipes = [];
  List<dynamic> _filteredRecipes = [];

  Future<void> fetchRecipes() async {
    final token = await _sessionService.getToken();
    final response = await http.get(
      Uri.parse("https://recipe.incube.id/api/recipes"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['data'];
      setState(() {
        _allRecipes = data;
        _filteredRecipes = data;
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    final token = await _sessionService.getToken();
    final response = await http.delete(
      Uri.parse("https://recipe.incube.id/api/recipes/$recipeId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _filteredRecipes.removeWhere((recipe) => recipe['id'] == recipeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Recipe deleted successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorData['message']),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _searchController.addListener(() {
      filterRecipes();
    });
  }

  void filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        final title = recipe['title'].toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 113, 42, 1),
        title: Text("Resep Makanan",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(255, 224, 179, 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari resep...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.orange[50],
                ),
              ),
            ),
            Expanded(
              child: _filteredRecipes.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.orange))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _filteredRecipes.length > 6
                          ? 6
                          : _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _filteredRecipes[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                "${recipe['photo_url']}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              "${recipe['title']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            subtitle: Text(
                              "by ${recipe['user']['name']}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Tooltip(
                                  message: 'Detail Resep',
                                  child: IconButton(
                                    icon: Icon(Icons.remove_red_eye,
                                        color: Colors.green),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RecipeDetailScreen(
                                                  recipe: recipe),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: 'Edit Resep',
                                  child: IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditRecipeScreen(recipe: recipe),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: 'Hapus Resep',
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      deleteRecipe(recipe['id'].toString());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Tambah Resep',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecipeScreen()),
            );
          },
          backgroundColor: Color.fromRGBO(
              255, 113, 42, 1), // Warna background menjadi orange
          shape: CircleBorder(), // Membuat tombol berbentuk bulat
          child: Icon(
            Icons.add,
            color: Colors.white, // Warna icon tetap putih
          ),
        ),
      ),
    );
  }
}
