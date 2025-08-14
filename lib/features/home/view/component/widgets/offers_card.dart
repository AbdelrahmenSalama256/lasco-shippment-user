import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';

class OfferGridCard extends StatelessWidget {
  final String title;
  final String category;
  final String? imageUrl; // Optional image URL, similar to ProductCard
  final VoidCallback? onPressed;

  const OfferGridCard({
    super.key,
    required this.title,
    required this.category,
    this.imageUrl,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 213.w,
        minHeight: 106.h,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(12.61.r),
          topStart: Radius.circular(12.61.r),
          bottomStart: Radius.circular(12.61.r),
          bottomEnd: Radius.circular(36.r),
        ),
      ),
      child: Row(
        children: [
          _buildImageSection(),

          SizedBox(width: 8.w),

          // Offer Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grey,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: onPressed,
                      child: Container(
                        width: 35.83268356323242.w,
                        height: 34.999366760253906.h,
                        alignment: Alignment.center,
                        // padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(10.r),
                            topStart: Radius.circular(10.r),
                            bottomStart: Radius.circular(10.r),
                            bottomEnd: Radius.circular(25.r),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          color: AppColors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      // height: 75.h,
      width: 56.w,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Stack(
        children: [
          // Product Image
          Center(
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    child: Image.asset(
                      imageUrl!,
                      // height: 84.h,
                      // width: 60.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    ),
                  )
                : _buildPlaceholderImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 80.h,
      width: 60.w,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Colors.orange[400],
        size: 30.w,
      ),
    );
  }
}
