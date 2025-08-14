import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String category;
  final double rating;
  final String price;
  final String? imageUrl;
  final bool isOnSale;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? ontap;
  final VoidCallback? onAddToCartPressed;
  final Color? saleTagColor;
  final Color? addToCartColor;

  const ProductCard({
    super.key,
    required this.productName,
    required this.category,
    required this.rating,
    required this.price,
    this.imageUrl,
    this.isOnSale = false,
    this.ontap,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onAddToCartPressed,
    this.saleTagColor,
    this.addToCartColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Color(0xffF7F7F7),
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(12.61.r),
            topStart: Radius.circular(12.61.r),
            bottomStart: Radius.circular(12.61.r),
            bottomEnd: Radius.circular(36.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Sale Badge and Favorite Icon
            _buildImageSection(context),

            // Product Details
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              margin: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(12.61.r),
                  topStart: Radius.circular(12.61.r),
                  bottomStart: Radius.circular(12.61.r),
                  bottomEnd: Radius.circular(36.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                    // maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // SizedBox(height: 4.h),

                  // Category
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secoundry,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // SizedBox(height: 8.h),
                  Row(
                    children: [
                      // Rating and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    rating.toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                              // Price
                              Text(
                                price,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // SizedBox(height: 6.h),

                      Spacer(),
                      // Add to Cart Button
                      _buildAddToCartButton(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      height: 120.h,
      width: double.infinity,
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

          // Sale Badge
          if (isOnSale)
            PositionedDirectional(
              top: 8.h,
              start: 8.w,
              child: Container(
                height: 18.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
                decoration: BoxDecoration(
                  color: saleTagColor ?? AppColors.secoundry,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  'sale'.tr(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

          // Favorite Icon
          PositionedDirectional(
            top: 8.h,
            end: 8.w,
            child: GestureDetector(
              onTap: onFavoritePressed,
              child: Container(
                width: 24.w,
                height: 24.h,
                alignment: Alignment.center,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  isFavorite
                      ? "assets/images/svg/heart-fill.svg"
                      : "assets/images/svg/heart.svg",
                ),
              ),
            ),
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

  Widget _buildAddToCartButton() {
    return GestureDetector(
      onTap: onAddToCartPressed,
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
        child: SvgPicture.asset(
          "assets/images/svg/bag.svg",
          width: 18.3330020904541.w,
          height: 19.999637603759766.h,
        ),
      ),
    );
  }
}
