import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/auth/view/cubit/login_cubit.dart';
import 'package:lasco/features/auth/view/otp_verification_screen.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/utils/validator.dart';
import 'cubit/login_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              navigateTo(
                  context,
                  BlocProvider(
                    create: (context) =>
                        LoginCubit()..sendForgotPasswordOtp(context),
                    child: OtpVerificationScreen(
                      phoneNumber:
                          context.read<LoginCubit>().phoneController.text,
                    ),
                  ));
            } else if (state is ForgotPasswordError) {
              showToast(
                context,
                message: state.errorMessage,
                state: ToastStates.error,
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
                      'forgot_password_title'.tr(context),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'forgot_password_subtitle'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    // Phone Field
                    AppTextField(
                      radius: BorderRadiusDirectional.circular(12.r),
                      controller: cubit.phoneController,
                      hintText: "enter_your_phone".tr(context),
                      labelText: "phone".tr(context),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          Validators.validatePhone(value, context),
                    ),
                    SizedBox(height: 50.h),

                    // Submit Button
                    AppButton(
                      text: "send_otp".tr(context),
                      backgroundColor: AppColors.orange,
                      isLoading: state is ForgotPasswordLoading,
                      onPressed: () {
                        if (cubit.phoneController.text.isNotEmpty) {
                          cubit.sendForgotPasswordOtp(context);
                        } else {
                          showToast(
                            context,
                            message: "please_enter_your_phone".tr(context),
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
