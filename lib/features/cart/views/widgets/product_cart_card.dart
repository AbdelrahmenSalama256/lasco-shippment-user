import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';

class ProductCartCard extends StatelessWidget {
  final String? image;
  final String category;
  final String productName;
  final String price;
  final int quantity;
  final VoidCallback? onTap;
  final bool? isOrder;
  const ProductCartCard({
    super.key,
    this.image,
    required this.category,
    required this.productName,
    required this.price,
    required this.quantity,
    this.onTap,
    this.isOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Added onTap functionality
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(12.r),
            topStart: Radius.circular(12.r),
            bottomStart: Radius.circular(12.r),
            bottomEnd: Radius.circular(36.r),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: _buildImageSection()),
            SizedBox(width: 8.w),
            // Offer Details
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                width: double.infinity,
                // height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(12.r),
                    topStart: Radius.circular(12.r),
                    bottomStart: Radius.circular(12.r),
                    bottomEnd: Radius.circular(36.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secoundry,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 30.w,
                          height: 30.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffF7F7F7),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/svg/heart.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            price,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.orange,
                            ),
                          ),
                        ),
                        Spacer(),
                        // Quantity Selector
                        Container(
                          width: 83.w,
                          height: 32.h,
                          alignment: Alignment.center,
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: 10.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.secoundry,
                            borderRadius: BorderRadius.circular(12.r),

//            borderRadius: BorderRadiusDirectional.only(
                            //   topEnd: Radius.circular(12.r),
                            //   topStart: Radius.circular(12.r),
                            //   bottomStart: Radius.circular(12.r),
                            //   bottomEnd: Radius.circular(36.r),
                            // ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.remove,
                                  size: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.add,
                                  size: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    child: Image.asset(
                      image!,
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
