import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class PromoCodeSection extends StatelessWidget {
  final TextEditingController promoController;
  final Function(String)? onPromoApplied; // Added parameter

  const PromoCodeSection({
    super.key,
    required this.promoController,
    this.onPromoApplied,
  });

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
            "apply_promo_code".tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  controller: promoController,
                  hintText: "enter_promo_code".tr(context), // Assuming a key
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    if (onPromoApplied != null) {
                      onPromoApplied!(promoController.text);
                    }
                  },
                  backgroundColor: AppColors.orange,
                  text: "apply".tr(context), // Assuming a key
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
