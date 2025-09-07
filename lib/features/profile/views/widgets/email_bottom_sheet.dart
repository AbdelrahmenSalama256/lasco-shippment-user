import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/component/widgets/app_button.dart';

class EmailBottomSheet extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final Function(String) onConfirm;

  const EmailBottomSheet(
      {super.key,
      required this.emailController,
      required this.onConfirm,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(50.r),
          topEnd: Radius.circular(50.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          Center(
            child: Text(
              "email_verify_title".tr(context),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.orange,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Center(
            child: Text(
              "email_verify_subtitle".tr(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Label
          Text(
            "email".tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 5.h),

          AppTextField(
            controller: emailController,
            hintText: 'enter_email'.tr(context),
            radius: BorderRadiusDirectional.circular(12.r),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 24.h),

          // Verify Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              isLoading: isLoading,
              onPressed: () => onConfirm(emailController.text.trim()),
              backgroundColor: AppColors.orange,
              text: "send_otp".tr(context),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16.h),
        ],
      ),
    );
  }
}
