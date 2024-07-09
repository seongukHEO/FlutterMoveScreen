import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/home/home_screen.dart';
import 'package:flutter_moving_screen/login/login_screen.dart';


void main() {
  runApp(MaterialApp(
    home:  HomeScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoginScreen(),
    );
  }
}


