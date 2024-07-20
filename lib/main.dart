import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/home/cart_screen.dart';
import 'package:flutter_moving_screen/home/home_screen.dart';
import 'package:flutter_moving_screen/home/product_add_screen.dart';
import 'package:flutter_moving_screen/home/product_detail_screen.dart';
import 'package:flutter_moving_screen/login/login_screen.dart';
import 'package:flutter_moving_screen/login/sign_up_screen.dart';
import 'package:flutter_moving_screen/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';


late List<CameraDescription> cameras = [];
UserCredential? userCredential;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  cameras = await availableCameras();

  if (kDebugMode) {
    try {
      // await FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
      // FirebaseFirestore.instance.useFirestoreEmulator("10.0.2.2", 8080);
      // FirebaseStorage.instance.useStorageEmulator("10.0.2.2", 9199);
    }catch(e){

    }
  }

  runApp(ProviderScope(child: FastCampusMarketApp()),
  );
}

class FastCampusMarketApp extends StatelessWidget {
  FastCampusMarketApp({super.key});
  final router = GoRouter(
      initialLocation: "/login",
      routes: [
        GoRoute(
            path: "/",
            builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
                path: "cart/:uid",
              builder: (context, state) => CartScreen(uid : state.pathParameters["uid"] ?? "")
            ),
            GoRoute(
                path: "product",
                builder: (context, state) => ProductDetailScreen(product: state.extra as Product,)
            ),
            GoRoute(
                path: "product/add",
                builder: (context, state) => ProductAddScreen()
            ),
          ]
        ),
        GoRoute(
            path: "/login",
            builder: (context, state) => LoginScreen()
        ),
        GoRoute(
            path: "/sign_up",
            builder: (context, state) => SignUpScreen()
        ),

  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "패캠 마트",
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



