import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_moving_screen/home/camera_example.dart';
import 'package:flutter_moving_screen/model/category.dart';
import 'package:flutter_moving_screen/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // dart:typed_data에 별칭을 붙입니다.

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

  Uint8List? imageData;
  XFile? image;

  Category? selectedCategory;

  TextEditingController titleTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController priceTEC = TextEditingController();
  TextEditingController stockTEC = TextEditingController();
  TextEditingController salePercentTEC = TextEditingController();

  List<Category> categoryItems = [];

  //카테고리 가져오기
  Future<List<Category>> _fetchCategories() async {
    final db = FirebaseFirestore.instance;
    final resp = await db.collection("category").get();
    for (var doc in resp.docs) {
      categoryItems.add(Category(docId: doc.id, title: doc.data()['title']));
    }
    setState(() {
      selectedCategory = categoryItems.first;
    });
    return categoryItems;
  }

  Future<Uint8List> imageCompressList(Uint8List list) async{
    var result = await FlutterImageCompress.compressWithList(list, quality: 50);
    return result;
  }

  Future addProduct()async{
    if (imageData != null) {
      final storageRef = storage.ref()
      //파일명 지정하기
          .child("${DateTime.now().millisecondsSinceEpoch} _${
          image?.name ?? "??"
      }.jpg");

      final compressData = await imageCompressList(imageData!);
      //이미지 데이터를 받아와서 집어넣기
      await storageRef.putData(compressData);
      //다운로드 링크를 얻어와야 한다
      final downloadLink = await storageRef.getDownloadURL();
      //이거 그거랑 비슷하네
      //안드로이드 개발할 때 매개변수에 해당하는 값을 넣어주고 그걸 최종적으로 변수로 만들어서 값을 파베에 저장하는거
      final sampleData = Product(
        title: titleTEC.text,
        description: descriptionTEC.text,
        price: int.parse(priceTEC.text),
        stock: int.parse(stockTEC.text),
        isSale: inSale,
        //할인율은 있을 수도 없을 수도 있다
        saleRate: salePercentTEC.text.isNotEmpty
          ? double.parse(salePercentTEC.text) : 0,
        
        imgUrl: downloadLink,
        timeStamp: DateTime.now().millisecondsSinceEpoch
      );
      final doc = await db.collection("product").add(sampleData.toJson());
      await doc.collection("category").add(selectedCategory?.toJson() ?? {});
      final categoryRef = db.collection("category").doc(selectedCategory?.docId);
      await categoryRef.collection("product").add({"docId" : doc.id});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품 추가"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CameraExample();
                }));
              },
              icon: Icon(Icons.camera)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.batch_prediction)
          ),
          IconButton(
              onPressed: () {
                addProduct();
              },
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
                  final picker = ImagePicker();
                  image = await picker.pickImage(source: ImageSource.gallery);
                  //긁어온 이미지를 바이트로 변환해준다
                  imageData = await image?.readAsBytes();
                  setState(() {});
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 240,
                      width: 240,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey)),
                      child: imageData == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Text("제품(상품) 이미지 추가"),
                              ],
                            )
                          : Image.memory(
                              imageData!,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "기본정보",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
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
                            hintText: "상품명을 입력하세요"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: descriptionTEC,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "상품 설명",
                        ),
                        maxLength: 254,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: priceTEC,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "가격(단가)",
                            hintText: "1개 가격 입력"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: stockTEC,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "수량",
                            hintText: "입고 및 재고 수량"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다";
                          }
                          return null;
                        },
                      ),
                      SwitchListTile.adaptive(
                        value: inSale,
                        onChanged: (v) {
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
                          validator: (value) {
                            return null;
                          },
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "카테고리 선택",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      categoryItems.isNotEmpty
                          ? DropdownButton<Category>(
                              isExpanded: true,
                              value: selectedCategory,
                              items: categoryItems
                                  .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text('${e.title}')))
                                  .toList(),
                              onChanged: (s) {
                                setState(() {
                                  selectedCategory = s;
                                });
                              })
                          : Center(
                              child: CircularProgressIndicator(),
                            )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
