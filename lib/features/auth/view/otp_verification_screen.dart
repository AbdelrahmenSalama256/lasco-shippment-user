// lib/features/auth/presentation/screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/core/utils/validator.dart';
import 'package:lasco/features/auth/view/change_password_screen.dart';
import 'package:lasco/features/base/views/base_screen.dart';
import 'package:pinput/pinput.dart';

import '../../offers/views/widgets/custom_app_bar.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final bool? isResetPassword;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.isResetPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: BlocProvider(
        create: (context) => LoginCubit()..startResendTimer(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is OtpVerificationSuccess) {
              if (isResetPassword == false) {
                navigateTo(context, ChangePasswordScreen());
              } else {
                navigateAndFinish(context, BaseScreen());
              }
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
            } else if (state is OtpVerificationError) {
              showToast(
                context,
                message: state.errorMessage,
                state: ToastStates.error,
              );
            } else if (state is LoginSuccess) {
              showToast(
                context,
                message: 'otp_resent'.tr(context),
                state: ToastStates.success,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'enter_verification_code'.tr(context),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'otp_sent_to'.tr(context),
                      style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        controller: cubit.otpController,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(
                                color: const Color(0xffF7F7F7), width: 1.w),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xfff97847).withOpacity(0.3),
                                blurRadius: 8.r,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        onCompleted: (pin) {
                          cubit.verifyOtp(context);
                        },
                        validator: (value) =>
                            Validators.validateOtp(value, context),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cubit.canResendOtp
                            ? Text(
                                'didnt_receive_code'.tr(context),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.grey,
                                ),
                              )
                            : Container(
                                width: 63.w,
                                height: 39.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      final offsetAnimation = Tween<Offset>(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero,
                                      ).animate(animation);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "00:${cubit.resendCountdown.toString().padLeft(2, '0')}",
                                      key: ValueKey<int>(cubit.resendCountdown),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.secoundry,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(width: 4.w),
                        cubit.canResendOtp
                            ? InkWell(
                                onTap: () {
                                  cubit.resendOtp(phoneNumber);
                                },
                                child: Text(
                                  'resend'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    AppButton(
                      text: "verify".tr(context),
                      backgroundColor: AppColors.orange,
                      isLoading: state is OtpVerificationLoading,
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.verifyOtp(context);
                        } else {
                          showToast(
                            context,
                            message: "please_enter_valid_otp".tr(context),
                            state: ToastStates.error,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
