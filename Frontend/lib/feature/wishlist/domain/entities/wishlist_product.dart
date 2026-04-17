import 'package:equatable/equatable.dart';

class WishlistProduct extends Equatable {
  const WishlistProduct({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productExists,
    required this.productOutOfStock,
  });

  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final bool productExists;
  final bool productOutOfStock;

  const WishlistProduct.empty()
    : this(
        productId: "test",
        productName: "test",
        productPrice: 0.0,
        productImage: "test",
        productExists: true,
        productOutOfStock: false,
      );

  @override
  List<Object?> get props => [
    productId,
    productName,
    productPrice,
    productImage,
    productExists,
    productOutOfStock,
  ];
}
