abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final bool isPasswordVisible;
  final bool isEmailValid;

  ProfileLoaded({
    required this.isPasswordVisible,
    required this.isEmailValid,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdated extends ProfileState {}

class ProfileDeleted extends ProfileState {}
