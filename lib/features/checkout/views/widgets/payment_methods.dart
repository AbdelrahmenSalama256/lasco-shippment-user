import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../cubit/checkout_cubit.dart';

class PaymentMethods extends StatelessWidget {
  final CheckoutCubit cubit;

  const PaymentMethods({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "payment_methods".tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.radio_button_checked,
                color: AppColors.primary,
                size: 18.w,
              ),
              SizedBox(width: 8.w),
              Text(
                cubit.selectedPaymentMethod == 'full'
                    ? "full_payment".tr(context)
                    : "partial_payment".tr(context),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (cubit.selectedPaymentMethod == 'partial')
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.orange,
                    size: 14.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "remaining_balance_due_on_delivery".tr(context),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
