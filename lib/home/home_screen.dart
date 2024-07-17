import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/home/cart_screen.dart';
import 'package:flutter_moving_screen/home/product_add_screen.dart';
import 'package:flutter_moving_screen/home/widget/home_widget.dart';
import 'package:flutter_moving_screen/home/widget/seller_widget.dart';
import 'package:go_router/go_router.dart';

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
          if (_menuIndex == 0)
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.search)
            )
        ],
      ),
      body: IndexedStack(
        index: _menuIndex,
        children: [
          HomeWidget(),
          SellerWidget()
        ],
      ),

      floatingActionButton: switch(_menuIndex){
        0 => FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return CartScreen(
                uid: "",
              );
            }));
          },
          child: Icon(Icons.shopping_cart_outlined),
        ),

        1 => FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ProductAddScreen();
            }));
          },
          child: Icon(Icons.add),
        ),
        _ => Container()
      },


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
