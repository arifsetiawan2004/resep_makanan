import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resep_makanan2/services/session_service.dart';
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
    final response = await http
        .get(Uri.parse("https://recipe.incube.id/api/recipes"), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

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
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari resep...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredRecipes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network("${recipe['photo_url']}"),
                          title: Text("${recipe['title']}"),
                          subtitle: Text("by ${recipe['user']['name']}"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
