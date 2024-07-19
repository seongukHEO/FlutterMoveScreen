import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/home/product_detail_screen.dart';

import '../../model/category.dart';
import '../../model/product.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  PageController pageController = PageController();
  int bannerIndex = 0;

  //카테고리 목록 가져오기
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCategory(){
    return FirebaseFirestore.instance.collection("category").snapshots();
  }

  List<Category> categoryItems = [];

  Future<List<Product>> fetchSaleProducts() async {
    final db = FirebaseFirestore.instance;
    final resp = await db.collection("product").where('isSale', isEqualTo: true).get();
    List<Product> items = [];
    for (var doc in resp.docs) {
      final item = Product.fromJson(doc.data());
      final realItem = item.copyWith(docId: doc.id);
      items.add(realItem);
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 140,
            margin: EdgeInsets.only(bottom: 8),
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  child: Image.asset("assets/bm_logo.png"),
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                ),
                Container(
                  child: Image.asset("assets/bm_logo.png"),
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                ),
                Container(
                  child: Image.asset("assets/bm_logo.png"),
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                ),
              ],
              onPageChanged: (idx){
                setState(() {
                  bannerIndex = idx;
                });
              },
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: bannerIndex,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("카테고리", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                    TextButton(
                        onPressed: (){},
                        child: Text("더보기")
                    )
                  ],
                ),
                SizedBox(height: 16,),

                //여기에는 카테고리 목록을 받아오는 위젯 구현
                Container(
                  height: 200,
                  child: StreamBuilder(
                    stream: streamCategory(),
                    builder: (context, snapshot){
                      if (snapshot.hasData) {
                        categoryItems.clear();
                        //  데이터를 한 번 초기화 해준다
                        final docs = snapshot.data;
                        final docItems = docs?.docs ?? [];
                        for(var doc in docItems){
                          categoryItems.add(Category(docId: doc.id, title: doc.data()["title"]));
                        }
                        return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemCount: categoryItems.length,
                            itemBuilder: (c, i){
                              final item = categoryItems[i];
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                  ),
                                  SizedBox(height: 8,),
                                  Text(item.title ?? "카테고리", style: TextStyle(fontWeight: FontWeight.bold),),

                                ],
                              );
                            }
                        );
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.only(top: 8, bottom: 16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("오늘의 특가", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                          TextButton(
                              onPressed: (){

                              },
                              child: Text("더보기")
                          )
                        ],
                      ),
                      Container(
                        height: 240,
                        child: FutureBuilder(
                          future: fetchSaleProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final items = snapshot.data ?? [];
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: items.length,
                                  itemBuilder: (c, i) {
                                    final item = items[i];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return ProductDetailScreen();
                                                }));
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: 160,
                                              margin: EdgeInsets.only(
                                                  right: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                //이미지 데이터 넣어주기
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        item.imgUrl ?? ""),
                                                    fit: BoxFit.cover
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                              child: Text(item.title ?? ""),
                                            alignment: Alignment.center,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
