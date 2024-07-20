import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/model/product.dart';

class CartScreen extends StatefulWidget {
  final String uid;
  const CartScreen({required this.uid,super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCartItems(){
    return FirebaseFirestore.instance.collection("cart")
        .where("uid", isEqualTo: widget.uid).snapshots();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장바구니"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: streamCartItems(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  //item이라는 변수는 위에서 정의한 함수 return값을 가지고 있고
                  //그러한 items를 순회하며 데이터를 가져온다
                  List<Cart> items = snapshot.data?.docs.map((e){
                    final foo = Cart.fromJson(e.data());
                    return foo.copyWith(cartDocId: e.id);
                  }).toList() ?? [];

                  return ListView.separated(
                      itemBuilder: (c, i) {
                        final item = items[i];

                        //이 부분은 가격계산인데,, 그냥 보자,,
                        num price = (item.product?.isSale ?? false)
                        ?((item.product!.price! * (item.product!.saleRate! / 100)) * (item.count ?? 1))
                        : (item.product!.price! * (item.count ?? 1));

                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item.product?.imgUrl ?? ""),
                                    fit: BoxFit.cover
                                  ),
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
                                            Text("${item.product?.title}"),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.delete)),
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("${price.toStringAsFixed(0)}")),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  int count = item.count ?? 1;
                                                  count--;
                                                  if (count < 1) {
                                                    count = 1;
                                                  }
                                                  FirebaseFirestore.instance.collection("cart")
                                                  .doc("${item.cartDocId}").update({"count" : count});
                                                },
                                                icon: Icon(Icons.remove_circle_outline)),
                                            Text("${item.count}"),
                                            IconButton(
                                                onPressed: () {
                                                  int count = item.count ?? 1;
                                                  count++;
                                                  if (count >= 99) {
                                                    count = 99;
                                                  }
                                                  FirebaseFirestore.instance.collection("cart")
                                                      .doc("${item.cartDocId}").update({"count" : count});
                                                },
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
                      itemCount: items.length);
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }
            ),
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
                  StreamBuilder(
                    stream: streamCartItems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        
                        List<Cart> items = snapshot.data?.docs.map((e){
                          final foo = Cart.fromJson(e.data());
                          return foo.copyWith(cartDocId: e.id);
                        }).toList() ?? [];
                        
                        double totalPrice = 0;
                        for(var element in items){
                          if (element.product?.isSale ?? false) {
                            totalPrice += ((element.product!.price! * (element.product!.saleRate! / 100)) * (element.count ?? 1));
                          } else{
                            totalPrice += element.product!.price! * (element.count ?? 1);
                          }
                        }
                        return Text(
                          "${totalPrice.toStringAsFixed(0)}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        );
                      };
                      return Center(child: CircularProgressIndicator(),);
                    }
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
