import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

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
                            decoration: BoxDecoration(
                              color: Colors.red
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text("할인중", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
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
                            Text("패캠 플러터", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                            PopupMenuButton(itemBuilder: (context){
                              return [
                                PopupMenuItem(child: Text("리뷰등록"))
                              ];
                            })
                          ],
                        ),
                        Text("제품 상세 정보"),
                        Text("상세 상세"),
                        SizedBox(height: 18,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("1000000원"),
                            Spacer(),
                            Icon(Icons.star, color: Colors.orange,),
                            Text("4.5")
                          ],
                        )

                      ],
                    ),
                  ),
                  DefaultTabController(length: 2, child: Column(
                    children: [
                      TabBar(tabs: [
                        Tab(text: "제품 상세",),
                        Tab(text: "리뷰",),
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
              child: Center(child: Text("장바구니", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)),
            ),
          )
        ],
      ),
    );
  }
}
