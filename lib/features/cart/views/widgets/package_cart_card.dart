import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';

class PackageCartCard extends StatelessWidget {
  final String orderId;
  final String fromLocation;
  final String toLocation;
  final int days; // ⬅️ instead of price
  final VoidCallback? onTap;
  final bool? isOrder;

  const PackageCartCard({
    super.key,
    required this.orderId,
    required this.fromLocation,
    required this.toLocation,
    required this.days, // ⬅️ required
    this.onTap,
    this.isOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            /// Icon Circle
            Expanded(
              child: Container(
                width: 43.w,
                height: 43.h,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0XFFfdeae3),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/svg/order_box.svg",
                      width: 20.w,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 8.w),

            /// Order Details Card
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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
                  children: [
                    /// Order ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "id_number".tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          orderId,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5.h),

                    /// From → To
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fromLocation,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                        Icon(Icons.arrow_forward,
                            size: 20.sp, color: AppColors.black),
                        Text(
                          toLocation,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    /// Estimated Days
                    Row(
                      children: [
                        Text(
                          "est_days".tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "$days ${"days".tr(context)}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 36.w,
                          height: 35.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(12.r),
                              topStart: Radius.circular(12.r),
                              bottomStart: Radius.circular(12.r),
                              bottomEnd: Radius.circular(36.r),
                            ),
                          ),
                          child: Icon(Icons.arrow_forward,
                              size: 20.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
