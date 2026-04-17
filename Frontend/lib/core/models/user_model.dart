import 'dart:convert';

import 'package:angkor_store/core/common/entities/user.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/wishlist/data/models/wishlist_product_model.dart';

import '../../../../core/common/entities/address.dart';
import '../../feature/wishlist/domain/entities/wishlist_product.dart';
import 'address_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isAdmin,
    required super.wishlist,
    super.address,
    super.phone,
  });

  const UserModel.empty()
    : this(
        id: "test",
        name: "test",
        email: "test",
        isAdmin: true,
        wishlist: const [],
        address: null,
        phone: null,
      );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    List<WishlistProduct>? wishlist,
    Address? address,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      wishlist: wishlist ?? this.wishlist,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'wishlist': wishlist
          .map((product) => (product as WishlistProductModel).toMap())
          .toList(),
      if (address != null) 'address': (address as AddressModel).toMap(),
      if (phone != null) 'phone': phone,
    };
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  factory UserModel.fromMap(DataMap map) {
    final address = AddressModel.fromMap({
      if (map case {'street': String street}) 'street': street,
      if (map case {'city': String city}) 'city': city,
      if (map case {'country': String country}) 'country': country,
      if (map case {'postalCode': String postalCode}) 'postalCode': postalCode,
    });

    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      wishlist: List<DataMap>.from(
        map['wishlist'] as List,
      ).map(WishlistProductModel.fromMap).toList(),
      address: address.isEmpty ? address : null,
      phone: map['phone'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());
}
