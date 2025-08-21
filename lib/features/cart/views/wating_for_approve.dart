import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/checkout/views/checkout_screen.dart';

class WatingForApprove extends StatelessWidget {
  const WatingForApprove({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateTo(context, CheckoutScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/png/tuned.png",
                width: 374.w,
                height: 374.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "thanks_for_joining".tr(context),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.orange,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "account_under_review".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
