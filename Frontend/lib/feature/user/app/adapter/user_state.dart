part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {
  const UserInitial();
}

final class GetUserData extends UserState {
  const GetUserData();
}

final class UpdateUserData extends UserState {
  const UpdateUserData();
}

final class GetUserPaymentProfiles extends UserState {
  const GetUserPaymentProfiles();
}

final class FetchedUser extends UserState {
  const FetchedUser(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

final class FetchedUserPaymentProfile extends UserState {
  const FetchedUserPaymentProfile(this.paymentProfileUrl);

  final String paymentProfileUrl;

  @override
  List<Object> get props => [paymentProfileUrl];
}

final class UserError extends UserState {
  const UserError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
