
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter/scheduler.dart';

void main() {
 
  runApp(const RihlaApp());

   // test seulement

}

class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rihla',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
