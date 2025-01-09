import 'package:flutter/material.dart';
import 'package:resep_makanan2/services/session_service.dart';

class HomeScreen extends StatelessWidget {
  SessionService _sessionService = SessionService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ElevatedButton(
          onPressed: () async {
            final user = await _sessionService.getUser();
            final token = await _sessionService.getToken();
            print(user);
            print(token);
          },
          child: Text("get session")),
    );
  }
}
