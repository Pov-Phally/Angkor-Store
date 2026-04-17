import 'dart:convert';

import 'package:angkor_store/core/utils/type_defs.dart';

import '../../domain/entities/wishlist_product.dart';

class WishlistProductModel extends WishlistProduct {
  const WishlistProductModel({
    required super.productId,
    required super.productName,
    required super.productPrice,
    required super.productImage,
    required super.productOutOfStock,
    required super.productExists,
  });

  const WishlistProductModel.empty()
    : this(
        productId: "test",
        productName: "test",
        productPrice: 0.0,
        productImage: "test",
        productExists: true,
        productOutOfStock: false,
      );

  WishlistProduct copyWith({
    String? productId,
    String? productName,
    double? productPrice,
    String? productImage,
    bool? productExists,
    bool? productOutOfStock,
  }) {
    return WishlistProduct(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImage: productImage ?? this.productImage,
      productExists: productExists ?? this.productExists,
      productOutOfStock: productOutOfStock ?? this.productOutOfStock,
    );
  }

  factory WishlistProductModel.fromJson(String source) =>
      WishlistProductModel.fromMap(jsonDecode(source) as DataMap);

  WishlistProductModel.fromMap(DataMap map)
    : this(
        productId: map['productId'] as String,
        productName: map['productName'] as String,
        productPrice: map['productPrice'] as double,
        productImage: map['productImage'] as String,
        productExists: map['productExists'] as bool,
        productOutOfStock: map['productOutOfStock'] as bool,
      );

  DataMap toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'productExists': productExists,
      'productOutOfStock': productOutOfStock,
    };
  }

  String toJson() => jsonEncode(toMap());
}
