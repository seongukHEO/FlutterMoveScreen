import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';

Future addCategory(String title) async {
  final db = FirebaseFirestore.instance;
  final ref = db.collection("category");
  await ref.add({"title" : title});
}


Future<List<Product>> fetchProduct()async{
  final db = FirebaseFirestore.instance;
  final resp = await db.collection("product").orderBy("timestamp").get();
  List<Product> items = [];
  for(var doc in resp.docs){
    final item = Product.fromJson(doc.data());
    final realItem = item.copyWith(docId: doc.id);
    items.add(item);
  }
  return items;
}


Stream<QuerySnapshot> streamProduct(String query){
  final db = FirebaseFirestore.instance;
  if (query.isNotEmpty) {
    return db.collection("product").orderBy("title")
        .startAt([query]).endAt([query + "\uf8ff"]).snapshots();
  }
  return db.collection("product").orderBy("timeStamp").snapshots();
}


class SellerWidget extends StatefulWidget {
  const SellerWidget({super.key});

  @override
  State<SellerWidget> createState() => _SellerWidgetState();
}

class _SellerWidgetState extends State<SellerWidget> {
  TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            controller: textEditingController,
            leading: Icon(Icons.search),
            onChanged: (s){
              setState(() {

              });
            },
            hintText: "상품명 입력",
          ),
          SizedBox(height: 16,),
          ButtonBar(
            children: [
              //굳아 필요 없을듯,,
              ElevatedButton(
                  onPressed: ()async{
                    List<String> categories = [
                      "정육",
                      "과자",
                      "아이스크림",
                      "유제품",
                      "과일",
                      "라면",
                      "빵",
                      "쿠키"
                    ];
                    final ref = FirebaseFirestore.instance.collection("category");
                    final tmp = await ref.get();

                    //이게 무슨 함수냐하면
                    //위의 리스트를 순회하면서 일단 값을 가져오고
                    //그걸 다 삭제해준다? (중복을 제거하기 위해서)
                    for(var element in tmp.docs){
                      await element.reference.delete();
                    }

                    for(var element in categories){
                      await ref.add({"title" : element});
                    }
                  },
                  child: Text("카테고리 일괄등록")
              ),
              ElevatedButton(
                  onPressed: (){
                    TextEditingController tec = TextEditingController();
                    showAdaptiveDialog(context: context, builder: (context){
                      return AlertDialog(
                        content: TextField(
                          controller: tec,
                        ),
                        actions: [
                          TextButton(
                              onPressed: ()async{
                                if (tec.text.isNotEmpty) {
                                  await addCategory(tec.text.trim());
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("등록")
                          )
                        ],
                      );
                    });
                  },
                  child: Text("카테고리 등록")
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text("상품목록", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),

          Expanded(
              child: StreamBuilder(
                stream: streamProduct(textEditingController.text),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data?.docs.map((e) =>
                    Product.fromJson(e.data() as Map<String, dynamic>).copyWith(docId: e.id)
                    ).toList();
                    return ListView.builder(
                      itemCount: items?.length,
                        itemBuilder: (c, i){
                        final item = items?[i];
                        print("test1234 : ${item?.title}");
                          //데이터가 있을때
                          return GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                              height: 120,
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Container(width: 120,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(item?.imgUrl ?? ""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item?.title?? "제품명", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                            PopupMenuButton(
                                                itemBuilder: (context) => [
                                              PopupMenuItem(child: Text("리뷰")),
                                              PopupMenuItem(
                                                  child: Text("수정하기"),
                                                onTap: ()async {
                                                    final db = FirebaseFirestore.instance;
                                                    final ref = db.collection("product");
                                                    await ref.doc(item?.docId).update(
                                                      item!.copyWith(
                                                        title: "milk",
                                                        price: 20000,
                                                        stock: 10
                                                      ).toJson()
                                                    );
                                                },
                                              ),
                                              PopupMenuItem(
                                                  child: Text("삭제"),
                                                //데이터 삭제 코드
                                                onTap: ()async{
                                                    FirebaseFirestore.instance.collection("product").doc(
                                                      item?.docId
                                                    ).delete();
                                                },
                                              ),
                                            ]),
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text("${item?.price}원")
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              switch(item?.isSale){
                                                true => "할인 중",
                                                false => "할인 없음",
                                                _ => "??"
                                            }
                                            )
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text("재고 수량 : ${item?.stock}")
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                }
              ))
        ],
      ),
    );
  }
}
