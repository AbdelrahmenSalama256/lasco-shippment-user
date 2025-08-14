import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class DescriptionSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const DescriptionSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "description_and_ingredients".tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'The Strawberry & Cream Ultra Rich Body Lotion has a long-lasting fragrance that is sweet and fruity, reminiscent of fresh ripe strawberries. This body lotion is enriched with Glycerin and Panthenol to lock in moisture and keep your skin smooth and supple for 24 hours.',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
              height: 1.5.h,
            ),
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              isExpanded ? "show_less".tr(context) : "read_more".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
