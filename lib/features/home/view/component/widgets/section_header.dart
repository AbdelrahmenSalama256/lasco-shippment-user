import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.showViewAll = false,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black, // بدلها بـ AppColors.black عندك
          ),
        ),
        const Spacer(),
        if (showViewAll)
          TextButton(
            onPressed: onViewAll ??
                () {
                  if (kDebugMode) {
                    print('View all pressed for: $title');
                  }
                },
            child: Text(
              "view_all".tr(context),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                color: AppColors.secoundry,
              ),
            ),
          ),
      ],
    );
  }
}
