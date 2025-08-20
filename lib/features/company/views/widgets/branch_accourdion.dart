import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/branch_model.dart';
import 'branch_item.dart';

class BranchesSection extends StatelessWidget {
  final List<BranchModel> branches;
  const BranchesSection({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "branches".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: branches.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          itemBuilder: (context, index) {
            return BranchItem(branch: branches[index]);
          },
        ),
      ],
    );
  }
}
