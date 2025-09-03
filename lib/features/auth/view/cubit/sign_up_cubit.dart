import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/sign_up_repo.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepo signUpRepo;

  SignUpCubit(this.signUpRepo) : super(SignUpInitial());

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final countryCodeController = TextEditingController();

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Password visibility
  bool isPasswordObscure = true;
  bool isStrongPassword = false;

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(SignUpPasswordVisibilityChanged(isPasswordObscure));
  }

  void toggleStrongPassword(bool value) {
    isStrongPassword = value;
    emit(SignUpStrongPasswordChanged(isStrongPassword));
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    emit(SignUpLoading());

    final result = await signUpRepo.registerUser(
      username: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      countryCode: countryCodeController.text,
    );

    result.fold(
      (error) => emit(SignUpError(error)),
      (response) {
        emit(SignUpSuccess());
      },
    );
  }
}
