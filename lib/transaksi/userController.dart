import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Controller {
  // Implementasi pola singleton
  static final Controller _instance = Controller._internal();
  factory Controller() => _instance;
  Controller._internal();

  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> userData = [];

  Future<void> login(String email, String password) async {
    final loginResponse = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final response = await supabase
        .from('user')
        .select()
        .eq('email', email);

    if (response.isNotEmpty) {
      // Ambil data user pertama dari list
      userData = [response.first];
    } else {
      userData = [];
    }

    // Debug jika diperlukan
    debugPrint('Login Response: $loginResponse');
    debugPrint('User Data: $userData');
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    userData = [];
  }
}
