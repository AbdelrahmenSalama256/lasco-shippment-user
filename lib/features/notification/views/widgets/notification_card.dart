import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';

import '../notifications_screen.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     spreadRadius: 1,
          //     blurRadius: 8,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon
            _buildNotificationIcon(),

            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (notification.description.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        children: _buildDescriptionSpans(),
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Text(
                    notification.timestamp,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            // Product Image
            if (notification.productImageUrl != null)
              Container(
                width: 50.w,
                height: 50.w,
                margin: EdgeInsets.only(left: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    notification.productImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.local_offer,
                          color: Colors.pink[300],
                          size: 24.w,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    if (notification.type == NotificationType.brand) {
      return Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: notification.brandColor ?? Colors.black,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            notification.brandLogoText ?? "B",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.local_offer_outlined,
          color: AppColors.orange,
          size: 20.w,
        ),
      );
    }
  }

  List<TextSpan> _buildDescriptionSpans() {
    final regex = RegExp(r'(\d+%\s*off)');
    final parts = notification.description.split(regex);
    final matches = regex.allMatches(notification.description).toList();

    List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }

      if (i < matches.length) {
        spans.add(
          TextSpan(
            text: matches[i].group(0),
            style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }

    return spans;
  }
}
