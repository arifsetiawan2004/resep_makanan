import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resep_makanan2/services/session_service.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  SessionService _sessionService = SessionService();
  Future<List<dynamic>> tampilData() async {
    final token = await _sessionService.getToken();
    final response = await http
        .get(Uri.parse("https://recipe.incube.id/api/recipes"), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['data'];
      return data;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: FutureBuilder<List<dynamic>>(
            future: tampilData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Recipes Found'));
              } else {
                final recipe = snapshot.data!;
                return ListView.builder(
                  itemCount: recipe.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.network("${recipe[index]['photo_url']}"),
                        title: Text("${recipe[index]['title']}"),
                        subtitle: Text("by ${recipe[index]['user']['name']}"),
                      ),
                    );
                  },
                );
              }
            }));
  }
}
