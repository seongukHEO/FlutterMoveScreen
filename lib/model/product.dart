import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
sealed class Product with _$Product {
  factory Product(
      {String? docId,
      String? title,
      String? description,
      int? price,
      bool? isSale,
      int? stock,
      double? saleRate,
      String? imgUrl,
      int? timeStamp
      }) = _Product;
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
