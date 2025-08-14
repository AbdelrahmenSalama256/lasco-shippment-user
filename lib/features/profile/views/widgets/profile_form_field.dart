import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';

class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool hasEditIcon;
  final bool hasValidationIcon;
  final bool isValid;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onPasswordToggle;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.hasEditIcon = false,
    this.hasValidationIcon = false,
    this.isValid = true,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onPasswordToggle,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: hasValidationIcon && !isValid
                  ? Colors.red
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: AppTextField(
            controller: controller,
            radius: BorderRadiusDirectional.circular(12.r),
            obscureText: isPassword && !isPasswordVisible,
            onChanged: onChanged,
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (isPassword) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: onPasswordToggle,
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[400],
                size: 20.w,
              )),
          SizedBox(width: 8.w),
          Icon(
            CupertinoIcons.pen,
            color: const Color(0xffB2B2B2),
            size: 20.sp,
          ),
          SizedBox(width: 16.w),
        ],
      );
    }

    if (hasValidationIcon) {
      return Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(
          isValid ? Icons.check_circle : Icons.error,
          color: isValid ? Colors.green : const Color(0xffFF4400),
          size: 20.w,
        ),
      );
    }

    if (hasEditIcon) {
      return Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(
          Icons.edit,
          color: Colors.grey[400],
          size: 20.w,
        ),
      );
    }

    return null;
  }
}
