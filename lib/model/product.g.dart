// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      docId: json['docId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toInt(),
      isSale: json['isSale'] as bool?,
      stock: (json['stock'] as num?)?.toInt(),
      saleRate: (json['saleRate'] as num?)?.toDouble(),
      imgUrl: json['imgUrl'] as String?,
      timeStamp: (json['timeStamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'isSale': instance.isSale,
      'stock': instance.stock,
      'saleRate': instance.saleRate,
      'imgUrl': instance.imgUrl,
      'timeStamp': instance.timeStamp,
    };
