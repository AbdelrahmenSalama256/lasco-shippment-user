import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/locale/app_loacl.dart'; // عشان نستعمل tr(context)
import 'package:lasco/features/home/view/component/widgets/order_status_bar.dart';

import '../../../../../core/constants/app_colors.dart';

class RecentOrderCard extends StatelessWidget {
  final String orderId;
  final int currentStep;
  final int totalSteps;
  final String fromDate;
  final String fromLocation;
  final String toDate;
  final String toLocation;
  final VoidCallback? onPickupPressed;
  final VoidCallback? onViewDetailsPressed;

  const RecentOrderCard({
    super.key,
    required this.orderId,
    required this.currentStep,
    required this.totalSteps,
    required this.fromDate,
    required this.fromLocation,
    required this.toDate,
    required this.toLocation,
    this.onPickupPressed,
    this.onViewDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Order ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "id_number".tr(context), // بدل ID Number
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

          SizedBox(height: 15.h),

          // Order status bar
          OrderStatusBar(currentStep: currentStep, totalSteps: totalSteps),

          SizedBox(height: 15.h),

          // Locations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // From
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fromDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    fromLocation,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),

              Icon(
                Icons.arrow_right_alt,
                size: 28.sp,
                color: AppColors.black,
              ),

              // To
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
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
            ],
          ),

          SizedBox(height: 15.h),

          Divider(
            color: const Color(0xffF2F2F2),
            height: 1.h,
            thickness: 1.h,
          ),

          SizedBox(height: 15.h),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: AppButton(
                  text: "pickup".tr(context), // بدل Pickup
                  height: 29.h,
                  onPressed: onPickupPressed,
                  borderRadius: BorderRadius.circular(9.r),
                  backgroundColor: AppColors.secoundry,
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: onViewDetailsPressed,
                    child: Text(
                      "view_details".tr(context), // بدل View Details
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
