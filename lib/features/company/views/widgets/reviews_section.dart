import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import 'review_item.dart';

class ReviewsSection extends StatelessWidget {
  final List<dynamic>? reviews;
  final int? countReviews;
  final double? averageRating;

  const ReviewsSection({
    super.key,
    this.reviews,
    this.countReviews,
    this.averageRating,
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
          // العنوان
          Text(
            "reviews".tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 10.h),

          // البوكس اللي فيه التقييم العام وعدد الريفيوهات
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
                    final rating = averageRating ?? 0.0;
                    return Icon(
                      CupertinoIcons.star_fill,
                      color: index < rating.round()
                          ? const Color(0xffFFB543)
                          : Colors.grey.shade300,
                      size: 20.w,
                    );
                  }),
                ),
                Text(
                  "${countReviews ?? 0} ${"reviews_count".tr(context)}",
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

          // لو في ريفيوهات
          if (reviews != null && reviews!.isNotEmpty)
            Column(
              children: reviews!.map((review) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ReviewItem(
                    image:
                        "assets/images/png/user1.jpg", // لو الـ API بيرجع صورة بدال static
                    name: review['user']?['name'] ?? "Anonymous",
                    rating: review['rating']?.toString() ?? "0.0",
                    review: review['comment'] ?? "",
                  ),
                );
              }).toList(),
            )
          else
            Text(
              "no_reviews".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
