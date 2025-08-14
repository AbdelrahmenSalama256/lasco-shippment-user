// lib/features/auth/presentation/screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/core/utils/password_strength_toggle.dart';
import 'package:lasco/core/utils/validator.dart';
import 'package:lasco/features/base/views/base_screen.dart';

import '../../../core/component/widgets/app_text_field.dart';
import '../../offers/views/widgets/custom_app_bar.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is OtpVerificationSuccess) {
              showToast(
                context,
                message: 'password_changed_successfully'.tr(context),
                state: ToastStates.success,
              );
              navigateAndFinish(context, BaseScreen());
            } else if (state is OtpVerificationError) {
              showToast(
                context,
                message: state.errorMessage,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();
            return Center(
              child: SingleChildScrollView(
                child: Padding(
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
                        PasswordFieldWithToggle(
                          isEnabled: true,
                          isPasswordObscure: cubit.isPasswordObscure,
                          togglePasswordVisibility:
                              cubit.togglePasswordVisibility,
                          onChanged: (value) {},
                          controller: cubit.passwordController,
                          hintText: "enter_your_password".tr(context),
                          labelText: "password".tr(context),
                        ),
                        SizedBox(height: 25.h),
                        AppTextField(
                          controller: cubit.confirmPasswordController,
                          radius: BorderRadiusDirectional.circular(12.r),
                          hintText: "confirm_your_password".tr(context),
                          labelText: "confirm_password".tr(context),
                          obscureText: true,
                          validator: (value) =>
                              Validators.validateConfirmPassword(value,
                                  cubit.passwordController.text, context),
                        ),
                        SizedBox(height: 50.h),
                        AppButton(
                          text: "save".tr(context),
                          backgroundColor: AppColors.orange,
                          isLoading: state is OtpVerificationLoading,
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.changePassword(context);
                            } else {
                              showToast(
                                context,
                                message:
                                    "please_enter_valid_passwords".tr(context),
                                state: ToastStates.error,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
