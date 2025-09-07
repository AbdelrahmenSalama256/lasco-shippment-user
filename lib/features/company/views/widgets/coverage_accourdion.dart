import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/home/data/model/company_model.dart';

import '../../../../core/constants/app_colors.dart';
import 'coverage_item.dart';

class CoverageSection extends StatelessWidget {
  final Map<String, Coverage>? coverage;
  const CoverageSection({super.key, required this.coverage});

  @override
  Widget build(BuildContext context) {
    if (coverage == null || coverage!.isEmpty) return const SizedBox.shrink();

    // Flatten to list of Coverage for display
    final List<Coverage> states = coverage!.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            "branches".tr(
                context), // Or change to "coverage_areas".tr(context) if you add translation
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // List of states
        ListView.separated(
          itemCount: states.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemBuilder: (context, index) {
            return CoverageItem(coverage: states[index]);
          },
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
        ),
      ],
    );
  }
}
