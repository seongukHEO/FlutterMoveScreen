import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/login/provider/login_provider.dart';
import 'package:flutter_moving_screen/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {


  Stream<QuerySnapshot<Map<String, dynamic>>> streamReview(){
    final db = FirebaseFirestore.instance;
    return db.collection("product").doc("${widget.product.docId}").collection("reviews").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.title}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 320,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.product.imgUrl ?? ""),
                            fit: BoxFit.cover)),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          switch (widget.product.isSale) {
                            true => Container(
                                decoration: BoxDecoration(color: Colors.red),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Text(
                                  "할인중",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            _ => Container(),
                          }
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.title ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            PopupMenuButton(itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("리뷰등록"),
                                  onTap: () {
                                    int reviewScore = 0;
                                    showDialog(
                                      barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          TextEditingController reviewTex =
                                              TextEditingController();
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text("리뷰 등록"),
                                              content: Column(
                                                //Colume의 사이즈를 핏하게 맞춘다!
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: reviewTex,
                                                  ),
                                                  Row(
                                                      children: List.generate(
                                                          5,
                                                          (index) => IconButton(
                                                              onPressed: () {
                                                                setState(() =>
                                                                    reviewScore =
                                                                        index);
                                                              },
                                                              icon: Icon(
                                                                  Icons.star,
                                                                  color: index <=
                                                                          reviewScore
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .grey))))
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("취소")),
                                                Consumer(
                                                  builder: (context, ref, child) {
                                                    final user = ref.watch(userCredentialProvider);
                                                    return TextButton(
                                                        onPressed: () async{
                                                          await FirebaseFirestore.instance.collection("product").doc("${widget.product.docId}")
                                                              .collection("reviews").add({
                                                            "uid" : user?.user?.uid ?? "",
                                                            "email" : user?.user?.email ?? "",
                                                            "review" : reviewTex.text.trim(),
                                                            "timeStamp" : Timestamp.now(),
                                                            "score" : reviewScore + 1
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("등록"));
                                                  }
                                                ),
                                              ],
                                            );
                                          });
                                        });
                                  },
                                )
                              ];
                            })
                          ],
                        ),
                        Text("제품 상세 정보"),
                        Text("${widget.product.description}"),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${widget.product.price}원"),
                            Spacer(),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text("4.5")
                          ],
                        )
                      ],
                    ),
                  ),
                  DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(tabs: [
                            Tab(
                              text: "제품 상세",
                            ),
                            Tab(
                              text: "리뷰",
                            ),
                          ]),
                          Container(
                            height: 500,
                            child: TabBarView(
                              children: [
                                Container(
                                  child: Text("제품 상세"),
                                ),
                                StreamBuilder(
                                  stream: streamReview(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final items = snapshot.data?.docs ?? [];
                                      return ListView.separated(
                                          itemBuilder: (c, i){
                                            final item = items[i];
                                            return ListTile(
                                              title: Text(item.data()["review"]),
                                              leading: Text(item.data()["email"]),
                                            );

                                          },
                                          separatorBuilder: (_, __) => Divider(),
                                          itemCount: items.length
                                      );
                                    }
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final db = FirebaseFirestore.instance;

              //그니까 밑의 코드를 설명하자면 처음에 우리가 글로벌하게 선언했던 유저 정보에 데이터가 있는지 확인하고
              //그러고 해당 컬렉션에서 내가 원하는 product.docId가 있는지 확인한다
              //즉 이미 카트라는 컬렉션에 값이 있는지 내가 저장하고자 하는 product가 있는지 확인한다
              final dupItem = await db
                  .collection("cart")
                  .where("uid", isEqualTo: userCredential?.user?.uid ?? "")
                  .where("product.docId", isEqualTo: widget.product.docId)
                  .get();

              if (dupItem.docs.isNotEmpty) {
                if (context.mounted) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("장바구니에 이미 등록이 되어 있습니다"),
                        );
                      });
                }
                return;
              }
              // 장바구니 추가
              await db.collection("cart").add({
                "uid": userCredential?.user?.uid ?? "",
                "email": userCredential?.user?.email ?? "",
                "timeStamp": DateTime.now().millisecondsSinceEpoch,
                "product": widget.product.toJson(),
                "count": 1
              });
              if (context.mounted) {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: Text("장바구니 등록 완료"),
                  );
                });
              }
            },
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
              ),
              child: Center(
                  child: Text(
                "장바구니",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )),
            ),
          )
        ],
      ),
    );
  }
}
