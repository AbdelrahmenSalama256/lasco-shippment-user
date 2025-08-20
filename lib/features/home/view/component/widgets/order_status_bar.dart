import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';

class OrderStatusBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OrderStatusBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isActive = stepIndex == currentStep;
          bool isCompleted = stepIndex < currentStep;

          return Container(
            width: isActive ? 43.5906982421875.w : 10.w,
            height: isActive ? 43.5906982421875.h : 10.h,
            padding: EdgeInsets.all(isActive ? 6.w : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isActive
                  ? Color(0XFFfdeae3)
                  : Colors.transparent,
            ),
            child: Container(
              width: isActive ? 29.6636962890625.w : 16.w,
              height: isActive ? 29.6636962890625.h : 16.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isCompleted || isActive)
                    ? Colors.orange
                    : const Color(0xffF7F7F7),
              ),
              child: isActive
                  ? Center(
                      child: SvgPicture.asset(
                        "assets/images/svg/order_box.svg",
                        width: 20.w,
                      ),
                    )
                  : null,
            ),
          );
        } else {
          int leftStep = (index - 1) ~/ 2;
          bool isCompleted = leftStep < currentStep;

          return Expanded(
            child: Container(
              height: 1.h,
              color: isCompleted ? AppColors.orange : Color(0xffF7F7F7),
            ),
          );
        }
      }),
    );
  }
}
