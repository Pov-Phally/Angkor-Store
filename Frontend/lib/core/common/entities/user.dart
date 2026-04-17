import 'package:equatable/equatable.dart';

import '../../../feature/wishlist/domain/entities/wishlist_product.dart';
import 'address.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.wishlist,
    this.address,
    this.phone,
  });

  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final List<WishlistProduct> wishlist;
  final Address? address;
  final String? phone;

  const User.empty()
    : this(
        id: "test",
        name: "test",
        email: "test",
        isAdmin: true,
        wishlist: const [],
        address: null,
        phone: null,
      );

  @override
  List<Object?> get props => [id, name, email, isAdmin, wishlist.length];
}
