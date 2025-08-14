import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';

import '../../../../../core/constants/navigation.dart';
import '../../../../../core/cubit/global_cubit.dart';
import '../../../../notification/views/notifications_screen.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location icon
        Container(
          width: 36.5.w,
          height: 35.25068664550781.h,
          decoration: BoxDecoration(
            color: Color(0xffFEEBE4),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.location_on_outlined,
            size: 25.sp,
            color: AppColors.orange,
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Location",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                "${context.read<GlobalCubit>().currentLocation}",
                // maxLines: 1,
                style: TextStyle(
                    // overflow: TextOverflow.ellipsis,
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        // Spacer(),
        // Location icon
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: GestureDetector(
            onTap: () {
              navigateTo(context, NotificationScreen());
            },
            child: Container(
              width: 38.w,
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.orange,
                  width: 1.5.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                "assets/images/svg/notification.svg",
                width: 24.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
