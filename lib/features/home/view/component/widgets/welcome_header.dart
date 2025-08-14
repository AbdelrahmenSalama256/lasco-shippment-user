import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/cubit/global_cubit.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return // Header info
        Row(
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
        Column(
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
              "${context.read<GlobalCubit>().c}",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}
