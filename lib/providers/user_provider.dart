// providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://your-api.com/api/me'),
      headers: {'Authorization': 'Bearer yourToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _user = User.fromJson(data['user']);
      notifyListeners();
    } else {
      throw Exception('Failed to load user');
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
