import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:angkor_store/feature/user/domain/usecases/get_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/app/provider/user_provider.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/usecases/get_user_payment_profile.dart';
import '../../domain/usecases/update_user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required GetUser getUser,
    required UpdateUser updateUser,
    required GetUserPaymentProfile getUserPaymentProfile,
    required UserProvider currentUserProvider,
  }) : _getUser = getUser,
       _updateUser = updateUser,
       _getUserPaymentProfile = getUserPaymentProfile,
       _currentUserProvider = currentUserProvider,
       super(const UserInitial());

  final GetUser _getUser;
  final UpdateUser _updateUser;
  final GetUserPaymentProfile _getUserPaymentProfile;
  final UserProvider _currentUserProvider;

  Future<void> getUserById(String userId) async {
    emit(const GetUserData());
    final result = await _getUser(userId);
    result.fold((failure) => emit(UserError(failure.errorMessage)), (user) {
      _currentUserProvider.setUser(user);
      emit(FetchedUser(user));
    });
  }

  Future<void> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    emit(const UpdateUserData());
    final result = await _updateUser(
      UpdateUserParams(userId: userId, updateData: updateData),
    );
    result.fold((failure) => emit(UserError(failure.errorMessage)), (user) {
      _currentUserProvider.updateUser(user);
      emit(FetchedUser(user));
    });
  }

  Future<void> getUserPaymentProfile(String userId) async {
    emit(const GetUserPaymentProfiles());
    final result = await _getUserPaymentProfile(userId);
    result.fold(
      (failure) => emit(UserError(failure.errorMessage)),
      (paymentProfileUrl) => emit(FetchedUserPaymentProfile(paymentProfileUrl)),
    );
  }
}
