import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';
import 'package:lasco/features/profile/views/share_experince_sheet.dart';

import '../../checkout/views/cubit/checkout_cubit.dart';
import '../../checkout/views/widgets/order_details_section.dart';
import '../../checkout/views/widgets/order_progress.dart';
import '../data/models/order_details_model.dart';
import 'widgets/my_orders_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderDetailModel orderDetail;

  OrderDetailsScreen({
    super.key,
    required this.orderDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "view_details".tr(context),
      ),
      body: BlocProvider(
        create: (context) => CheckoutCubit()..setOrderDetails(orderDetail),
        child: Builder(
          builder: (context) {
            context.read<CheckoutCubit>();
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with company image and name
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(16.w),
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: AppColors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.asset(
                              "assets/images/png/com-1.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "LASCO Shipping",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Order Card
                    OrderCard(
                      orderId: orderDetail.orderId,
                      currentStep: _getCurrentStep(orderDetail.status),
                      totalSteps: 5, // Assuming 5 steps for the progress bar
                      fromDate: orderDetail.orderDate,
                      fromLocation:
                          "Unknown", // Replace with actual data if available
                      toDate: orderDetail.orderDate,
                      toLocation: orderDetail.deliveryAddress.split(',')[0],
                      status: orderDetail.status
                          .toString()
                          .split('.')
                          .last
                          .capitalize(),
                      onViewDetailsPressed: () {
                        // Already on details screen, so no action needed or could trigger a refresh
                      },
                    ),
                    SizedBox(height: 24.h),

                    orderDetail.status != OrderDetailStatus.cancelled
                        ? OrderProgress(
                            steps: steps,
                            date: "18 Jul, 2024",
                          )
                        : const SizedBox.shrink(),

                    SizedBox(height: 24.h),

                    // Order Status Banner (for cancelled orders)
                    if (orderDetail.status == OrderDetailStatus.cancelled)
                      _buildCancelledBanner(context),

                    SizedBox(height: 24.h),

                    SizedBox(height: 20.h),

                    // Share Experience for Delivered Orders
                    if (orderDetail.status == OrderDetailStatus.delivered)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(50.r),
                                      topStart: Radius.circular(50.r),
                                    ),
                                  ),
                                  builder: (context) {
                                    return const ShareExperienceBottomSheet();
                                  },
                                );
                              },
                              child: Text(
                                "share_you_experience".tr(context),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.orange,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),

                    // Order Details Summary
                    OrderDetailsSection(
                      subtotal: double.parse(
                          orderDetail.subtotal.replaceAll(' LE', '')),
                      shipping: double.parse(
                          orderDetail.shipping.replaceAll(' LE', '')),
                      discount: 0,
                      total:
                          double.parse(orderDetail.total.replaceAll(' LE', '')),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to determine currentStep based on status
  int _getCurrentStep(OrderDetailStatus status) {
    switch (status) {
      case OrderDetailStatus.processing:
        return 1;
      case OrderDetailStatus.onWay:
        return 3;
      case OrderDetailStatus.delivered:
        return 5;
      case OrderDetailStatus.cancelled:
        return 1;
    }
  }

  final List<TrackingStep> steps = [
    TrackingStep("Pending", "01:00 PM Nasr City", true),
    TrackingStep("Accepted", "01:00 PM Nasr City", true),
    TrackingStep("Picked Up", "01:00 PM Nasr City", true),
    TrackingStep("On way (ID: F124G375 )", "01:00 PM Nasr City", false),
    TrackingStep("Delivered", "01:00 PM Nasr City", false),
  ];

  Widget _buildCancelledBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cancel,
            color: Colors.red,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Text(
            "order_cancelled".tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize status string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// Models
enum OrderDetailStatus {
  processing,
  onWay,
  delivered,
  cancelled,
}

extension OrderDetailStatusValue on OrderDetailStatus {
  int get value {
    switch (this) {
      case OrderDetailStatus.processing:
        return 0;
      case OrderDetailStatus.onWay:
        return 1;
      case OrderDetailStatus.delivered:
        return 2;
      case OrderDetailStatus.cancelled:
        return -1;
    }
  }
}

enum OrderStepStatus {
  completed,
  current,
  inactive,
}

class OrderStep {
  final String title;
  final OrderStepStatus status;

  OrderStep({
    required this.title,
    required this.status,
  });
}

class PaymentMethodModel {
  final String title;
  final bool isCompleted;

  PaymentMethodModel({
    required this.title,
    required this.isCompleted,
  });
}

class TrackingStep {
  final String status;
  final String time;
  final bool isCompleted;

  TrackingStep(this.status, this.time, this.isCompleted);
}
