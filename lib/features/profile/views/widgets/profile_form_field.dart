import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';

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
  final VoidCallback? onTap;

  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isEnabled; // New property for enabling/disabling
  final bool? hasError; // Optional for explicit error state

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
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.isEnabled = true, // Default to enabled
    this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final bool showError = hasError ?? (!isValid && hasValidationIcon);
    final bool isDisabled = !isEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with disabled styling if needed
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: isDisabled ? Colors.grey[400] : AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey[50] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: showError
                  ? Colors.red
                  : (isDisabled ? Colors.grey[300]! : Colors.transparent),
              width: 1,
            ),
            // Add subtle shadow for enabled state
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: AppTextField(
            controller: controller,
            enabled: isEnabled,
            radius: BorderRadiusDirectional.circular(12.r),
            obscureText: isPassword && !isPasswordVisible,
            onTap: onTap != null
                ? () {
                    PrintUtil.debug('AppTextField onTap triggered');
                    onTap!();
                  }
                : null,

            onChanged:
                isEnabled ? onChanged : null, // Disable onChanged when disabled
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            // Error styling
            // errorText: showError ? "Invalid input" : null,
            // Visual feedback for disabled state
            suffixIcon:
                isDisabled ? _buildDisabledSuffixIcon() : _buildSuffixIcon(),
          ),
        ),
        // Show error message below field if there's an error
        if (showError)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 16.w),
            child: Text(
              _getErrorMessage(),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Build suffix icons in a row with proper spacing
    List<Widget> icons = [];

    // Password visibility toggle
    if (isPassword && onPasswordToggle != null) {
      icons.add(
        GestureDetector(
          onTap: onPasswordToggle,
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[400],
              size: 20.w,
            ),
          ),
        ),
      );
      icons.add(SizedBox(width: 8.w));
    }

    // Validation icon
    if (hasValidationIcon) {
      icons.add(
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green : const Color(0xffFF4400),
            size: 20.w,
          ),
        ),
      );
    }

    // Edit icon
    if (hasEditIcon) {
      icons.add(
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Icon(
            Icons.edit,
            color: Colors.grey[400],
            size: 20.w,
          ),
        ),
      );
    }

    if (icons.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }

  Widget? _buildDisabledSuffixIcon() {
    if (hasEditIcon) {
      return Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(
          Icons.lock_outline,
          color: Colors.grey[300],
          size: 20.w,
        ),
      );
    }
    return null;
  }

  String _getErrorMessage() {
    if (!isValid && hasValidationIcon) {
      switch (label.toLowerCase()) {
        case 'email':
          return 'Please enter a valid email address';
        case 'phone':
        case 'phone number':
          return 'Please enter a valid phone number';
        case 'name':
          return 'Please enter a valid name';
        case 'password':
          return 'Password must be at least 6 characters';
        default:
          return 'Invalid input';
      }
    }
    return 'Invalid input';
  }
}
