import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("패캠 마트"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.logout)
          ),
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.search)
          )
        ],
      ),
      body: IndexedStack(
        index: _menuIndex,
        children: [
          Container(color: Colors.green,),
          Container(color: Colors.indigo,),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _menuIndex,
        onDestinationSelected: (idx){
          setState(() {
            _menuIndex = idx;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.store_outlined), label: "홈"),
          NavigationDestination(icon: Icon(Icons.storefront), label: "사장님"),
        ],
      ),
    );
  }
}
