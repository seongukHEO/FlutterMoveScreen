import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  PageController pageController = PageController();
  int bannerIndex = 0;
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
                  color: Colors.red,
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
                              onPressed: (){},
                              child: Text("더보기")
                          )
                        ],
                      ),
                      Container(
                        height: 240,
                        color: Colors.orange,
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
