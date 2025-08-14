import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  void signUp(BuildContext context) {
    if (!formKey.currentState!.validate()) return;
    Future.delayed(const Duration(seconds: 2), () {
      emit(SignUpSuccess());
    });
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
