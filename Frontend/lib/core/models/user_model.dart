import 'dart:convert';

import 'package:angkor_store/core/common/entities/user.dart';
import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/wishlist/data/models/wishlist_product_model.dart';
import 'package:flutter/cupertino.dart';

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
    try {
      final addressData = map['address'] as DataMap?;
      final address = addressData == null
          ? null
          : AddressModel.fromMap(addressData);

      return UserModel(
        id: (map['id'] ?? map['_id'] ?? '') as String,
        name: (map['name'] ?? '') as String,
        email: (map['email'] ?? '') as String,
        isAdmin: (map['isAdmin'] ?? false) as bool,
        wishlist: map['wishlist'] == null
            ? []
            : List<DataMap>.from(
                map['wishlist'] as List,
              ).map(WishlistProductModel.fromMap).toList(),
        address: address?.isNotEmpty == true ? address : null,
        phone: map['phone'] as String?,
      );
    } catch (e) {
      debugPrint("Error parsing UserModel: $e");
      debugPrint("Map content: $map");
      rethrow;
    }
  }

  String toJson() => jsonEncode(toMap());
}
