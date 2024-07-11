import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/home/cart_screen.dart';
import 'package:flutter_moving_screen/home/home_screen.dart';
import 'package:flutter_moving_screen/home/product_add_screen.dart';
import 'package:flutter_moving_screen/home/product_detail_screen.dart';
import 'package:flutter_moving_screen/login/login_screen.dart';
import 'package:flutter_moving_screen/login/sign_up_screen.dart';
import 'package:go_router/go_router.dart';


void main() {
  runApp(MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final router = GoRouter(
      initialLocation: "/login",
      routes: [
        GoRoute(
            path: "/",
            builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
                path: "cart/:uid",
              builder: (context, state) => CartScreen(uid : state.pathParameters["Uid"] ?? "")
            ),
            GoRoute(
                path: "product",
                builder: (context, state) => ProductDetailScreen()
            ),
            GoRoute(
                path: "product/add",
                builder: (context, state) => ProductDetailScreen()
            ),
          ]
        ),
        GoRoute(
            path: "/login",
            builder: (context, state) => LoginScreen()
        ),
        GoRoute(
            path: "/sign up",
            builder: (context, state) => SignUpScreen()
        ),

  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "패캠 마트",
      routerConfig: router,
    );
  }
}


