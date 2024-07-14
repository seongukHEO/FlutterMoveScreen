import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future addCategory(String title) async {
  final db = FirebaseFirestore.instance;
  final ref = db.collection("category");
  await ref.add({"title" : title});
}



class SellerWidget extends StatefulWidget {
  const SellerWidget({super.key});

  @override
  State<SellerWidget> createState() => _SellerWidgetState();
}

class _SellerWidgetState extends State<SellerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(),
          SizedBox(height: 16,),
          ButtonBar(
            children: [
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
              child: ListView.builder(
                  itemBuilder: (c, i){
                    return Container(
                      height: 120,
                      margin: EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(width: 120, 
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)
                            ),),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("제품명", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                    PopupMenuButton(itemBuilder: (context) => [
                                      PopupMenuItem(child: Text("리뷰")),
                                      PopupMenuItem(child: Text("삭제")),
                                    ]),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                    child: Text("가격")
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("할인중")
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("재고 수량")
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    );
                  }
              ))
        ],
      ),
    );
  }
}
