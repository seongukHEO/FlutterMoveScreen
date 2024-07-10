import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  onPressed: (){},
                  child: Text("카테고리 일괄등록")
              ),
              ElevatedButton(
                  onPressed: (){},
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
