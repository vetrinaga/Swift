import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  final String _baseUrl = 'http://localhost:8080'; // Use localhost for web/desktop

  Future<void> signUp({required String email, required String password}) async {
    final url = Uri.parse('$_baseUrl/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  // TODO: Implement sign in with email and password

  // TODO: Implement sign in with Google

  // TODO: Implement sign in with Apple

  // TODO: Implement sign out
}
