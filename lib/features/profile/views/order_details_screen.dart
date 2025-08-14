import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';
import 'package:lasco/features/profile/views/share_experince_sheet.dart';

import '../../checkout/views/cubit/checkout_cubit.dart';
import '../../checkout/views/widgets/order_details_section.dart';
import '../../checkout/views/widgets/order_info.dart';
import '../../checkout/views/widgets/order_items.dart';
import '../../checkout/views/widgets/order_progress.dart';
import '../data/models/order_details_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderDetailModel orderDetail;

  const OrderDetailsScreen({
    super.key,
    required this.orderDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "order_details".tr(context),
      ),
      body: BlocProvider(
        create: (context) => CheckoutCubit()..setOrderDetails(orderDetail),
        child: Builder(
          builder: (context) {
            final cubit = context.read<CheckoutCubit>();
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Order Status Progress
                    orderDetail.status != OrderDetailStatus.cancelled
                        ? OrderProgress(cubit: cubit)
                        : SizedBox.shrink(),

                    SizedBox(height: 24.h),

                    // Order Status Banner (for cancelled orders)
                    if (orderDetail.status == OrderDetailStatus.cancelled)
                      _buildCancelledBanner(context),

                    // Order Info
                    OrderInfo(cubit: cubit),

                    SizedBox(height: 20.h),

                    // Delivery Information
                    _buildDeliverySection(context, cubit),

                    SizedBox(height: 20.h),

                    // Payment Methods
                    _buildPaymentSection(context, cubit),

                    SizedBox(height: 24.h),

                    // Order Items
                    OrderItems(cubit: cubit),

                    SizedBox(height: 20.h),
                    orderDetail.status == OrderDetailStatus.delivered
                        ? Column(
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
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        topEnd: Radius.circular(50.r),
                                        topStart: Radius.circular(50.r),
                                      ),
                                    ),
                                    builder: (context) {
                                      return ShareExperienceBottomSheet();
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
                              )),
                              SizedBox(height: 20.h),
                            ],
                          )
                        : SizedBox.shrink(),
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

  Widget _buildDeliverySection(BuildContext context, CheckoutCubit cubit) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0XFFF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.orange,
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "deliver_to".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            orderDetail.deliveryAddress,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    color: AppColors.orange,
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "mobile_number".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            orderDetail.mobileNumber,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context, CheckoutCubit cubit) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "payment_methods".tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          ...orderDetail.paymentMethods.map((method) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      color: method.isCompleted
                          ? AppColors.secoundry
                          : AppColors.primary,
                      size: 18.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      method.title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              SvgPicture.asset(
                "assets/images/svg/cash-on-delivery.svg",
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                "remaining_balance_due_on_delivery".tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// New StatefulWidget for the bottom sheet

// Models (unchanged)
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
