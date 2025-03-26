// lib/presentation/profile/bloc/profile_info_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/auth/get_user.dart';
import 'package:my_app/presentation/profile/bloc/profile_info_state.dart';
import 'package:my_app/service_locator.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit() : super(ProfileInfoLoading());

  Future<void> getUser() async {
    try {
      emit(ProfileInfoLoading());
      final result = await sl<GetUserUseCase>().call();
      result.fold(
        (error) => emit(ProfileInfoFailure(error)),
        (user) => emit(ProfileInfoLoaded(user)),
      );
    } catch (e) {
      emit(ProfileInfoFailure(e.toString()));
    }
  }
}
