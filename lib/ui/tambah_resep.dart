import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:resep_makanan2/services/session_service.dart';
import 'package:http/http.dart' as http;

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  SessionService _sessionService = SessionService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _cookingMethodController = TextEditingController();
  TextEditingController _ingredientsController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _image;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Pilih gambar dari galeri

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Menyimpan gambar yang dipilih
      });
    }
  }

  // Fungsi untuk mengirim form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final token = await _sessionService.getToken();
      final request = http.MultipartRequest(
          'POST', Uri.parse("https://recipe.incube.id/api/recipes"))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['title'] = _titleController.text
        ..fields['cooking_method'] = _cookingMethodController.text
        ..fields['ingredients'] = _ingredientsController.text
        ..fields['description'] = _descriptionController.text
        ..files.add(await http.MultipartFile.fromPath(
            'photo', _image!.path)); // Mengirim gambar

      final response = await request.send();

      if (response.statusCode == 201) {
        Navigator.pop(context); // Kembali ke halaman sebelumnya setelah sukses
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Recipe created successfully'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create recipe'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields and select an image'),
        backgroundColor: Colors.orange,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Resep')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _cookingMethodController,
                decoration: InputDecoration(labelText: 'Cooking Method'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a cooking method';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ingredients';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(
                  height: 20.0), // Jarak antara tombol Pick Image dan Submit
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background biru
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded button
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
