import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({this.street, this.city, this.country, this.postalCode});

  final String? street;
  final String? city;
  final String? country;
  final String? postalCode;

  const Address.empty()
    : this(street: "test", city: "test", country: "test", postalCode: "test");

  bool get isEmpty =>
      street == null && city == null && country == null && postalCode == null;

  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [street, city, country, postalCode];
}
