import 'package:flutter/material.dart';
import 'package:pl2_kasir/login.dart';
import 'package:pl2_kasir/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://nnwssjksazpzovipomdu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ud3NzamtzYXpwem92aXBvbWR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MjEyMTcsImV4cCI6MjA1NDM5NzIxN30.NaRYqY9ruxt-oLlQ_KlInJptbYtmRT3P2z6mhZ1KIjQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return MaterialApp(
      title: 'Kasir Mini',
      home: user != null ? const HomePage() : const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
