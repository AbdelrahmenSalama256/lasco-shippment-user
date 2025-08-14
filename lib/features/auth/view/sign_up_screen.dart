import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/core/utils/password_strength_toggle.dart';
import 'package:lasco/features/auth/view/login_screen.dart';
import 'package:lasco/features/auth/view/otp_verification_screen.dart';

import '../../../core/constants/navigation.dart';
import '../../../core/utils/validator.dart';
import '../../base/views/base_screen.dart';
import 'cubit/sign_up_cubit.dart';
import 'cubit/sign_up_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          final cubit = context.read<SignUpCubit>();
          return BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                navigateTo(
                    context,
                    OtpVerificationScreen(
                        isResetPassword: true,
                        phoneNumber: cubit.phoneController.text));
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffE9E2DA),
              body: Stack(
                children: [
                  Positioned.fill(
                    bottom: 0,
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/images/png/auth.jpg",
                      width: 376.w,
                      fit: BoxFit.contain,
                      height: 235.h,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 200.w,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(100.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15.r,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            children: [
                              Text(
                                "text_sign_up".tr(context),
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.orange,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Name Field
                              AppTextField(
                                radius: BorderRadiusDirectional.circular(12.r),
                                controller: cubit.nameController,
                                hintText: "enter_your_name".tr(context),
                                labelText: "name".tr(context),
                                validator: (value) =>
                                    Validators.validateName(value, context),
                              ),
                              SizedBox(height: 25.h),

                              // Phone Field
                              AppTextField(
                                controller: cubit.phoneController,
                                radius: BorderRadiusDirectional.circular(12.r),
                                hintText: "enter_your_phone".tr(context),
                                labelText: "phone".tr(context),
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    Validators.validatePhone(value, context),
                              ),
                              SizedBox(height: 25.h),

                              // Password Field
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

                              // Confirm Password Field
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
                              SizedBox(height: 25.h),

                              // Sign Up Button
                              AppButton(
                                text: "text_sign_up".tr(context),
                                onPressed: () => cubit.signUp(context),
                                backgroundColor: AppColors.orange,
                              ),
                              SizedBox(height: 25.h),

                              // Already have account text
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context, LoginScreen());
                                    },
                                    child: Text(
                                      "already_have_an_account".tr(context),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context, LoginScreen());
                                    },
                                    child: Text(
                                      "text_login".tr(context),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.orange,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.h),

                              // Divider with "or"
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Color(0xffF7F7F7),
                                      height: 1.h,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "or".tr(context),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Divider(
                                      color: Color(0xffF7F7F7),
                                      height: 1.h,
                                    ),
                                  ),
                                ],
                              ),

                              // Login as guest
                              SizedBox(height: 25.h),
                              InkWell(
                                onTap: () {
                                  navigateAndFinish(context, BaseScreen());
                                },
                                child: Text(
                                  "login_as_guest".tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.orange,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),

                              // Space for keyboard
                              SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
