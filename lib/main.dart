import 'package:flutter/material.dart';
import 'package:pl2_kasir/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  //setup supabase
   await Supabase.initialize(
    url: 'https://bbwqnewusgvvdoysgdlv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJid3FuZXd1c2d2dmRveXNnZGx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMjU0ODIsImV4cCI6MjA1MTcwMTQ4Mn0.wpZyGtRfwPboj9A5bRSm8li8lW9fY76b_Z6-rTyGxo0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Mini',
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
