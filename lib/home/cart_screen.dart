import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final String uid;
  const CartScreen({required this.uid,super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장바구니"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (c, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("플러터"),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("100000원")),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.remove_circle_outline)),
                                  Text("12"),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.add_circle_outline))
                                ],
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, _) {
                  return Divider();
                },
                itemCount: 10),
          ),
          Divider(),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "합계",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "100000000원",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.red.shade200,
            ),
            child: Center(child: Text("배달 주문", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)),
          )
        ],
      ),
    );
  }
}
