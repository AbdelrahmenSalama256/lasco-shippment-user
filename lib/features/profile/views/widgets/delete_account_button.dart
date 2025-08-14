import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class DeleteAccountButton extends StatelessWidget {
  final VoidCallback onDeletePressed;

  const DeleteAccountButton({super.key, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDeletePressed,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.delete,
            color: AppColors.orange,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            "delete_account".tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.orange,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
