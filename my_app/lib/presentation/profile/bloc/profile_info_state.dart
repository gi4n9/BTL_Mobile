// lib/presentation/profile/bloc/profile_info_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_app/domain/entities/auth/user.dart';

abstract class ProfileInfoState extends Equatable {
  const ProfileInfoState();

  @override
  List<Object?> get props => [];
}

class ProfileInfoLoading extends ProfileInfoState {}

class ProfileInfoLoaded extends ProfileInfoState {
  final UserEntity userEntity;

  const ProfileInfoLoaded(this.userEntity);

  @override
  List<Object?> get props => [userEntity];
}

class ProfileInfoFailure extends ProfileInfoState {
  final String error;

  const ProfileInfoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
