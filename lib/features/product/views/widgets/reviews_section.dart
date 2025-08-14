import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import 'review_item.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

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
            "reviews".tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 49.h,
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadiusDirectional.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      CupertinoIcons.star_fill,
                      color: const Color(0xffFFB543),
                      size: 20.w,
                    );
                  }),
                ),
                Text(
                  "reviews_count".tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          const ReviewItem(
            image: "assets/images/png/user2.png",
            name: "Jonas Sousa",
            rating: "4.5",
            review:
                "This body lotion is enriched with Glycerin and Vitamin E to deeply moisturize and nourish your skin.",
          ),
          SizedBox(height: 12.h),
          const ReviewItem(
            image: "assets/images/png/user1.jpg",
            name: "Jonas Sousa",
            rating: "4.0",
            review:
                "This body lotion is enriched with Glycerin and Vitamin E to deeply moisturize and nourish your skin.",
          ),
        ],
      ),
    );
  }
}
