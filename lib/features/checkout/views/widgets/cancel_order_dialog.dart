import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_custom_dialog.dart';

import '../../../../core/constants/app_colors.dart';

class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      imagePath: "assets/images/svg/cancel.svg",
      title: "cancel_order_confirmation",
      subtitle: "are_you_sure_cancel_order",
      buttons: [
        DialogButton(
          text: "cancel_order",
          backgroundColor: const Color(0xffFEEBE3),
          textStyle: TextStyle(
            color: AppColors.orange,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        DialogButton(
          text: "go_back",
          backgroundColor: AppColors.orange,
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          height: 56.h,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
