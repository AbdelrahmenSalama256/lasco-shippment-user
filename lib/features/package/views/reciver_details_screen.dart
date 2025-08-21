import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart'; // <-- for .tr(context)
import 'package:lasco/features/cart/views/cart_screen.dart';

import '../../offers/views/widgets/custom_app_bar.dart';

class ReciverDetailsScreen extends StatelessWidget {
  const ReciverDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final notesController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "",
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              "receiver_details".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            /// Name Field
            AppTextField(
              controller: nameController,
              hintText: "enter_name".tr(context),
              radius: BorderRadiusDirectional.circular(12.r),
            ),
            SizedBox(height: 16.h),

            /// Mobile Field
            AppTextField(
              controller: phoneController,
              hintText: "enter_mobile".tr(context),
              keyboardType: TextInputType.phone,
              radius: BorderRadiusDirectional.circular(12.r),
            ),
            SizedBox(height: 16.h),

            /// Address Field
            AppTextField(
              controller: addressController,
              hintText: "enter_address".tr(context),
              radius: BorderRadiusDirectional.circular(12.r),
            ),
            SizedBox(height: 16.h),

            /// Notes Field
            AppTextField(
              controller: notesController,
              hintText: "additional_notes".tr(context),
              maxLines: 4,
              radius: BorderRadiusDirectional.circular(12.r),
            ),

            const Spacer(),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      // Handle Checkout
                    },
                    text: "checkout".tr(context),
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.orange,
                    ),
                    borderRadius: BorderRadiusDirectional.circular(12.r),
                    backgroundColor: AppColors.orange.withOpacity(0.2),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      navigateTo(context, CartScreen());
                    },
                    text: "add_to_cart".tr(context),
                    backgroundColor: AppColors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
