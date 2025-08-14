import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class CustomDialog extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String? subtitle;
  final List<DialogButton> buttons;

  const CustomDialog({
    super.key,
    this.imagePath,
    this.title = "cancel_order_confirmation",
    this.subtitle = "are_you_sure_cancel_order",
    this.buttons = const [],
  });

  @override
  Widget build(BuildContext context) {
    final defaultButtons = [
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
        onPressed: () => Navigator.pop(context),
      ),
    ];

    final effectiveButtons = buttons.isNotEmpty ? buttons : defaultButtons;

    return AlertDialog(
      scrollable: true,
      actionsPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      title: Column(
        children: [
          if (imagePath != null)
            SvgPicture.asset(
              imagePath!,
              width: 95.w,
              height: 95.h,
            ),
          Text(
            title.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      content: subtitle != null
          ? Text(
              subtitle!.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xffB2B2B2),
              ),
            )
          : null,
      actions: [
        Row(
          children: _buildButtonRow(context, effectiveButtons),
        ),
      ],
    );
  }

  List<Widget> _buildButtonRow(
      BuildContext context, List<DialogButton> buttons) {
    final rowChildren = <Widget>[];

    for (int i = 0; i < buttons.length; i++) {
      if (i > 0) {
        rowChildren.add(SizedBox(width: 10.w));
      }

      rowChildren.add(
        Expanded(
          child: AppButton(
            text: buttons[i].text.tr(context),
            backgroundColor: buttons[i].backgroundColor ?? AppColors.grey,
            textStyle: buttons[i].textStyle ??
                TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
            borderRadius: i == 1
                ? BorderRadiusDirectional.only(
                    topEnd: Radius.circular(12.r),
                    topStart: Radius.circular(12.r),
                    bottomStart: Radius.circular(12.r),
                    bottomEnd: Radius.circular(36.r),
                  )
                : BorderRadius.circular(
                    12.r), // Default radius for other buttons
            height: buttons[i].height ?? 56.h,
            onPressed: buttons[i].onPressed ??
                (i == 0
                    ? () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    : () => Navigator.pop(context)),
          ),
        ),
      );
    }

    return rowChildren;
  }
}

class DialogButton {
  final String text;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? height;
  final VoidCallback? onPressed;

  const DialogButton({
    required this.text,
    this.backgroundColor,
    this.textStyle,
    this.height,
    this.onPressed,
  });
}
