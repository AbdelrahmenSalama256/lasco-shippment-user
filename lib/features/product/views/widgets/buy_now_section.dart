import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/cart/views/cart_screen.dart';

class BuyNowSection extends StatelessWidget {
  final int quantity;

  const BuyNowSection({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Container(
            width: 91.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xfff97847).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: SvgPicture.asset(
                "assets/images/svg/bag.svg",
                color: AppColors.orange,
                width: 20.w,
                height: 20.h,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: AppButton(
              text: "buy_now".tr(context),
              onPressed: () {
                PrintUtil.debug("Buy Now pressed - Quantity: $quantity");
                navigateTo(context, CartScreen());
              },
              type: AppButtonType.primary,
              backgroundColor: AppColors.orange,
              height: 56.h,
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
