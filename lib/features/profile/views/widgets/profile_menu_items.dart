import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class ProfileMenuItems extends StatelessWidget {
  final bool notificationsEnabled;
  final String selectedLanguage;
  final ValueChanged<bool> onNotificationChanged;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onOrdersPressed;
  final VoidCallback onTermsPressed;

  const ProfileMenuItems({
    super.key,
    required this.notificationsEnabled,
    required this.selectedLanguage,
    required this.onNotificationChanged,
    required this.onLanguageChanged,
    required this.onOrdersPressed,
    required this.onTermsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _buildMenuItem(
            icon: SvgPicture.asset(
              "assets/images/svg/notification.svg",
              width: 22.w,
              height: 22.h,
            ),
            title: "notification".tr(context),
            trailing: SizedBox(
              width: 40.w,
              child: FittedBox(
                child: CupertinoSwitch(
                  value: notificationsEnabled,
                  onChanged: onNotificationChanged,
                  activeTrackColor: AppColors.orange,
                ),
              ),
            ),
            onTap: () => onNotificationChanged(!notificationsEnabled),
          ),
          _buildMenuItem(
            icon: SvgPicture.asset(
              "assets/images/svg/orders.svg",
              width: 22.w,
              height: 22.h,
            ),
            title: "my_orders".tr(context),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: const Color(0XffB2B2B2),
            ),
            onTap: onOrdersPressed,
          ),
          _buildMenuItem(
            icon: SvgPicture.asset(
              "assets/images/svg/translate.svg",
              width: 22.w,
              height: 22.h,
            ),
            title: "language".tr(context),
            trailing: Text(
              selectedLanguage,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => _showLanguageDialog(context),
          ),
          _buildMenuItem(
            icon: SvgPicture.asset(
              "assets/images/svg/security.svg",
              width: 22.w,
              height: 22.h,
            ),
            title: "terms_privacy".tr(context),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: const Color(0XffB2B2B2),
            ),
            onTap: onTermsPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(padding: EdgeInsets.all(8.w), child: icon),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("select_language".tr(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, "العربية", "Arabic"),
            _buildLanguageOption(context, "English", "English"),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, String englishName) {
    return ListTile(
      title: Text(language),
      subtitle: Text(englishName),
      trailing: selectedLanguage == language
          ? Icon(Icons.check, color: AppColors.orange)
          : null,
      onTap: () {
        onLanguageChanged(language);
        Navigator.pop(context);
      },
    );
  }
}
