// lib/features/auth/presentation/bloc/login_cubit.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';

import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/services/service_locator.dart';
import '../../data/repo/login_repo.dart';
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

  Future<void> verifyOtp(BuildContext context, String phoneNumber) async {
    emit(OtpVerificationLoading());
    final result = await sl<LoginRepo>().verifyOtp(
      phone: phoneNumber,
      code: otpController.text,
    );

    result.fold(
      (error) => emit(OtpVerificationError(error)),
      (response) {
        if (response.token != null && response.token!.isNotEmpty) {
          context.read<GlobalCubit>().updateToken(response.token!);
          PrintUtil.debug("Token cached: ${response.token}");
        } else {
          PrintUtil.error("No token found in response");
        }
        emit(OtpVerificationSuccess());
      },
    );
  }

  Future<void> resendOtp(String phoneNumber) async {
    if (!_canResendOtp) return;

    emit(ResendOtpCodeLoading());
    final result = await sl<LoginRepo>().resendOtp(
      phone: phoneNumber,
    );

    result.fold(
      (error) => emit(ResendOtpCodeError(error)),
      (response) {
        emit(ResendOtpCodeSuccess());
        startResendTimer();
      },
    );
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

  Future<void> userLogin(BuildContext context) async {
    emit(LoginLoading());
    final result = await sl<LoginRepo>().userLogin(
      phone: phoneController.text,
      password: passwordController.text,
    );

    result.fold(
      (error) => emit(LoginError(error)),
      (response) {
        if (response.token != null && response.token!.isNotEmpty) {
          context.read<GlobalCubit>().updateToken(response.token!);
          PrintUtil.debug("Token cached: ${response.token}");
        } else {
          PrintUtil.error("No token found in response");
        }

        emit(LoginSuccess(response));
      },
    );
  }
}
