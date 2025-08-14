import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String imagePath;
  final VoidCallback onEditPressed;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.imagePath,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 112.w,
          height: 112.w,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: const Color(0xffD9D9D9),
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 50.w,
                  color: Colors.grey[400],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          userName,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onEditPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "edit_profile".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.orange,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.edit,
                size: 16.w,
                color: AppColors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
