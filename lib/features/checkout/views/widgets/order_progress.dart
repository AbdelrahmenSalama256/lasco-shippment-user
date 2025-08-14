import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../profile/views/order_details_screen.dart';
import '../cubit/checkout_cubit.dart';

class OrderProgress extends StatelessWidget {
  final CheckoutCubit cubit;

  const OrderProgress({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final status = cubit.orderDetail?.status ?? OrderDetailStatus.processing;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProgressStep(
            context,
            iconPath: "assets/images/svg/placed.svg",
            titleKey: "order_status_ordered",
            isActive: true,
            isCompleted: true,
          ),
          _buildProgressLine(
            isCompleted: status != OrderDetailStatus.processing,
          ),
          _buildProgressStep(
            context,
            iconPath: "assets/images/svg/proccing.svg",
            titleKey: "order_status_processing",
            isActive: status != OrderDetailStatus.processing,
            isCompleted: status != OrderDetailStatus.processing,
          ),
          _buildProgressLine(
            isCompleted: status == OrderDetailStatus.onWay ||
                status == OrderDetailStatus.delivered,
          ),
          _buildProgressStep(
            context,
            iconPath: "assets/images/svg/onway.svg",
            titleKey: "order_status_on_way",
            isActive: status == OrderDetailStatus.onWay ||
                status == OrderDetailStatus.delivered,
            isCompleted: status == OrderDetailStatus.onWay ||
                status == OrderDetailStatus.delivered,
          ),
          _buildProgressLine(
            isCompleted: status == OrderDetailStatus.delivered,
          ),
          _buildProgressStep(
            context,
            iconPath: "assets/images/svg/diliverd.svg",
            titleKey: "order_status_delivered",
            isActive: status == OrderDetailStatus.delivered,
            isCompleted: status == OrderDetailStatus.delivered,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(
    BuildContext context, {
    required String iconPath,
    required String titleKey,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xfff97847).withOpacity(0.2)
                : const Color(0xffF7F7F7),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.orange : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: SvgPicture.asset(
              iconPath,
              // color: isActive ? AppColors.orange : Colors.grey[400],
              width: 24.w,
              height: 24.w,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          titleKey.tr(context),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.orange : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20.h, left: 8.w, right: 8.w),
        child: isCompleted
            ? Container(
                height: 2.h,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              )
            : DottedLine(
                dashColor: Colors.grey[300]!,
                lineThickness: 2.h,
                dashLength: 6.w,
                dashGapLength: 4.w,
              ),
      ),
    );
  }
}
