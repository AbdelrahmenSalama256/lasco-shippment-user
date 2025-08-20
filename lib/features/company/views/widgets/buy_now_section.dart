import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../package/views/pick_up_screen.dart';

class BuyNowSection extends StatelessWidget {
  final int quantity;

  const BuyNowSection({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: AppButton(
        text: "send_package".tr(context),
        onPressed: () {
          PrintUtil.debug("Buy Now pressed - Quantity: $quantity");
          navigateTo(
            context,
            PickupAddressScreen(),
          );
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
    );
  }
}
