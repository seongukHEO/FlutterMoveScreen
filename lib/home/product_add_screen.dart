import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data' as Uint8List; // dart:typed_data에 별칭을 붙입니다.

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {

  final _formKey = GlobalKey<FormState>();

  //할인중인지
  bool inSale = false;

  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;


  //이미지 피커 라이브러리에 있는 것들

  Uint8List imageData;
  XFile? image;

  Category? selectedCategory;

  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController priceTEC = TextEditingController();
  TextEditingController stockTEC = TextEditingController();
  TextEditingController salePercentTEC = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품 추가"),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.batch_prediction)
          ),
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.add)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final  picker = ImagePicker();
                  image = await picker.pickImage(source: ImageSource.gallery);
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 240,
                    width: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text("제품(상품) 이미지 추가"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text("기본정보", style: Theme.of(context).textTheme.headlineSmall,),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleTEC,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "상품명",
                          hintText: "상품명을 입력하세요"
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16,),
                      TextFormField(
                        controller: descriptionTEC,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "상품 설명",
                        ),
                        maxLength: 254,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16,),
                      TextFormField(
                        controller: priceTEC,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "가격(단가)",
                          hintText: "1개 가격 입력"
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16,),
                      TextFormField(
                        controller: stockTEC,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "수량",
                            hintText: "입고 및 재고 수량"
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SwitchListTile.adaptive(value: inSale, onChanged: (v){
                        setState(() {
                          inSale = v;
                        });
                      },
                      title: Text('할인 여부'),
                      ),
                      if (inSale)
                        TextFormField(
                          controller: salePercentTEC,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "할인률",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value){
                            return null;
                          },
                        ),
                      SizedBox(height: 16,),
                      Text("카테고리 선택", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16
                      ),),
                      DropdownButton(
                          isExpanded: true,
                          items: [],
                          onChanged: (s){}
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
