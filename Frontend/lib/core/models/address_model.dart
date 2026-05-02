import 'dart:convert';

import 'package:angkor_store/core/common/entities/address.dart';
import 'package:angkor_store/core/utils/type_defs.dart';

class AddressModel extends Address {
  const AddressModel({
    super.street,
    super.city,
    super.country,
    super.postalCode,
  });

  const AddressModel.empty()
    : this(street: "test", city: "test", country: "test", postalCode: "test");

  // factory AddressModel.fromEntity(Address entity)
  AddressModel copyWith({
    String? street,
    String? city,
    String? country,
    String? postalCode,
  }) {
    return AddressModel(
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(jsonDecode(source) as DataMap);

  AddressModel.fromMap(DataMap map)
    : this(
        street: map['street'] as String?,
        city: map['city'] as String?,
        country: map['country'] as String?,
        postalCode: map['postalCode'] as String?,
      );

  DataMap toMap() {
    return <String, dynamic>{
      'street': street,
      'city': city,
      'country': country,
      'postalCode': postalCode,
    };
  }

  String toJson() => jsonEncode(toMap());
}
