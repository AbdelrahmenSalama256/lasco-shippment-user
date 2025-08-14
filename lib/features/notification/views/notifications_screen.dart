import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/notification/views/widgets/notification_card.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.w,
      appBar: CustomAppBar(
        title: "notification".tr(context),
        bgColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Today Section
            _buildNotificationSection(
              context,
              "today".tr(context),
              _getTodayNotifications(context),
            ),

            SizedBox(height: 24.h),

            // Recently Section
            _buildNotificationSection(
              context,
              "recently".tr(context), // Translated
              _getRecentNotifications(context),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    String title,
    List<NotificationModel> notifications,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ),
        ),

        SizedBox(height: 12.h),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                notification: notification,
                onTap: () {
                  // Handle notification tap
                },
              );
            },
          ),
        ),
      ],
    );
  }

  List<NotificationModel> _getTodayNotifications(BuildContext context) {
    return [
      NotificationModel(
        id: '1',
        type: NotificationType.promotion,
        title: 'ramadan_offers_title'.tr(context),
        brandColor: Color(0xfff97847),
        description: 'ramadan_offers_description'.tr(context),
        timestamp: '11:00 AM',
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.brand,
        title: 'mazaya_new_offer_title'.tr(context),
        description: '',
        timestamp: '13:00 AM',
        brandLogoText: 'mazaYa',
        brandColor: Color(0xfff97847),
        productImageUrl:
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-K1ndKugOM0ftNCLMlmwQgYcPJPeK3y.png',
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.promotion,
        title: 'ramadan_offers_title'.tr(context),
        description: 'ramadan_offers_description'.tr(context),
        timestamp: '11:00 AM',
      ),
    ];
  }

  List<NotificationModel> _getRecentNotifications(BuildContext context) {
    return [
      NotificationModel(
        id: '4',
        type: NotificationType.brand,
        title: 'mazaya_new_offer_title'.tr(context),
        description: '',
        timestamp: '11:00 AM',
        brandLogoText: 'Mazaya',
        brandColor: AppColors.orange,
        productImageUrl:
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-K1ndKugOM0ftNCLMlmwQgYcPJPeK3y.png',
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.promotion,
        title: 'ramadan_offers_title'.tr(context),
        description: 'ramadan_offers_description'.tr(context),
        timestamp: '11:00 AM',
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.promotion,
        title: 'ramadan_offers_title'.tr(context),
        description: 'ramadan_offers_description'.tr(context),
        timestamp: '11:00 AM',
      ),
    ];
  }
}

// Notification Models
enum NotificationType {
  promotion,
  brand,
  order,
  general,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final String timestamp;
  final String? brandLogoText;
  final Color? brandColor;
  final String? productImageUrl;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.brandLogoText,
    this.brandColor,
    this.productImageUrl,
    this.isRead = false,
  });
}
