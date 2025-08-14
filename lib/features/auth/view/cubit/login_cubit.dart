// lib/features/auth/presentation/bloc/login_cubit.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  // Controllers
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Password visibility
  bool isPasswordObscure = true;

  // Timer for OTP resend
  Timer? _resendTimer;
  int _resendCountdown = 20;
  bool _canResendOtp = false;

  int get resendCountdown => _resendCountdown;
  bool get canResendOtp => _canResendOtp;

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(LoginUpdated());
  }

  void login(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());
    Future.delayed(const Duration(seconds: 2), () {
      emit(LoginSuccess());
    });
  }

  void sendForgotPasswordOtp(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());

    startResendTimer();
    Future.delayed(const Duration(seconds: 2), () {
      emit(ForgotPasswordSuccess());
    });
  }

  void changePassword(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    emit(OtpVerificationLoading());
    Future.delayed(const Duration(seconds: 2), () {
      if (passwordController.text == confirmPasswordController.text) {
        // Example condition
        emit(OtpVerificationSuccess());
      } else {
        emit(OtpVerificationError("Passwords do not match"));
      }
    });
  }

  void verifyOtp(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());
    Future.delayed(const Duration(seconds: 2), () {
      emit(OtpVerificationSuccess());
    });
  }

  void resendOtp(String phoneNumber) {
    if (!_canResendOtp) return;

    emit(LoginLoading());
    startResendTimer();
    Future.delayed(const Duration(seconds: 2), () {
      emit(LoginSuccess());
    });
  }

  void startResendTimer() {
    _resendTimer?.cancel();
    _resendCountdown = 20;
    _canResendOtp = false;
    emit(LoginUpdated());

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 0) {
        _canResendOtp = true;
        timer.cancel();
      } else {
        _resendCountdown--;
      }
      emit(LoginUpdated());
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    return super.close();
  }
}
