import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("패캠 제품 상세"),
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
                      color: Colors.orange,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.red),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              "할인중",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
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
                              "패캠 플러터",
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
                                        context: context,
                                        builder: (context) {
                                          TextEditingController reviewTex = TextEditingController();
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
                                                            5, (index) => IconButton(
                                                            onPressed: (){
                                                              setState(
                                                                  () => reviewScore = index
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.star,
                                                              color: index <= reviewScore
                                                                           ? Colors.orange
                                                                           : Colors.grey
                                                            )
                                                        )
                                                        )
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("취소")
                                                  ),
                                                  TextButton(
                                                      onPressed: () {},
                                                      child: Text("등록")
                                                  ),
                                                ],
                                              );
                                            }
                                          );
                                        });
                                  },
                                )
                              ];
                            })
                          ],
                        ),
                        Text("제품 상세 정보"),
                        Text("상세 상세"),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("1000000원"),
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
                                Container(
                                  child: Text("리뷰"),
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
