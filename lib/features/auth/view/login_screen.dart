import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/auth/view/cubit/login_state.dart';
import 'package:lasco/features/auth/view/sign_up_screen.dart';
import 'package:lasco/features/base/views/base_screen.dart';

import '../../../core/component/custom_toast.dart';
import '../../../core/constants/navigation.dart';
import '../../../core/utils/validator.dart';
import 'cubit/login_cubit.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                showToast(context,
                    message: "${state.response.message}",
                    state: ToastStates.success);
                navigateAndFinish(context, BaseScreen());
              }
              if (state is LoginError) {
                showToast(context,
                    message: state.errorMessage, state: ToastStates.error);
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffD4CFED),
              body: Stack(
                children: [
                  Positioned.fill(
                    bottom: null,
                    top: -16.h,
                    left: 41.w,
                    right: 0,
                    child: Image.asset(
                      "assets/images/png/shopping-cart-with-bag.jpg",
                      width: 291.w,
                      fit: BoxFit.cover,
                      height: 291.h,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 230.h,
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
                      // This is the main content of the login screen
                      child: SingleChildScrollView(
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            children: [
                              // Login as guest
                              InkWell(
                                onTap: () {
                                  navigateAndFinish(context, BaseScreen());
                                },
                                child: Text(
                                  "login_as_guest".tr(context),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.orange,
                                    color: AppColors.orange,
                                  ),
                                ),
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
                              SizedBox(height: 25.h),

                              Text(
                                "text_login".tr(context),
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.orange,
                                ),
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
                              SizedBox(height: 25.h),

                              // Confirm Password Field
                              AppTextField(
                                controller: cubit.passwordController,
                                radius: BorderRadiusDirectional.circular(12.r),
                                hintText: "enter_your_password".tr(context),
                                labelText: "password".tr(context),
                                obscureText: true,
                                validator: (value) =>
                                    Validators.validatePassword(value, context),
                              ),
                              // Forgot Password Text with inkwell
                              SizedBox(height: 25.h),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to forgot password screen
                                    navigateTo(context, ForgotPasswordScreen());
                                  },
                                  child: Text(
                                    "forgot_password".tr(context),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.h),

                              // Sign Up Button
                              AppButton(
                                text: "text_login".tr(context),
                                isLoading: state is LoginLoading,
                                onPressed: () => cubit.userLogin(context),
                                backgroundColor: AppColors.orange,
                              ),
                              SizedBox(height: 25.h),

                              // Already have account text
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "dont_have_an_account".tr(context),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context, SignUpScreen());
                                    },
                                    child: Text(
                                      "sign_up".tr(context),
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
                              // SizedBox(height: 25.h),

                              // // Divider with "or"
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Divider(
                              //         color: Color(0xffF7F7F7),
                              //         height: 1.h,
                              //       ),
                              //     ),
                              //     SizedBox(width: 8.w),
                              //     Text(
                              //       "or".tr(context),
                              //       style: TextStyle(
                              //         fontSize: 10.sp,
                              //         fontWeight: FontWeight.w400,
                              //         color: AppColors.black,
                              //       ),
                              //     ),
                              //     SizedBox(width: 8.w),
                              //     Expanded(
                              //       child: Divider(
                              //         color: Color(0xffF7F7F7),
                              //         height: 1.h,
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // // Login as guest
                              // SizedBox(height: 25.h),
                              // InkWell(
                              //   onTap: () {
                              //     navigateAndFinish(context, BaseScreen());
                              //   },
                              //   child: Text(
                              //     "login_as_guest".tr(context),
                              //     style: TextStyle(
                              //       fontSize: 14.sp,
                              //       fontWeight: FontWeight.w400,
                              //       decoration: TextDecoration.underline,
                              //       decorationColor: AppColors.orange,
                              //       color: AppColors.orange,
                              //     ),
                              //   ),
                              // ),

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
