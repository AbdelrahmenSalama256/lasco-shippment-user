import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/widgets/print_util.dart';
import 'cubit/checkout_cubit.dart';
import 'widgets/cancel_order_dialog.dart';
import 'widgets/delivery_section.dart';
import 'widgets/order_details_section.dart';
import 'widgets/order_info.dart';
import 'widgets/order_items.dart';
import 'widgets/order_progress.dart';
import 'widgets/payment_methods.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CheckoutCubit>(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CheckoutCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(title: "order_confirmation".tr(context)),
            body: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height - kToolbarHeight,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      OrderProgress(cubit: cubit),
                      SizedBox(height: 20.h),
                      OrderInfo(cubit: cubit),
                      SizedBox(height: 16.h),
                      const DeliverySection(),
                      SizedBox(height: 16.h),
                      PaymentMethods(cubit: cubit),
                      SizedBox(height: 16.h),
                      OrderItems(cubit: cubit),
                      SizedBox(height: 16.h),
                      OrderDetailsSection(
                        subtotal: cubit.subtotal,
                        shipping: cubit.shipping,
                        discount: cubit.discount,
                        total: cubit.total,
                      ),
                      SizedBox(height: 16.h),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: "cancel_order".tr(context),
              backgroundColor: const Color(0xffFEEBE3),
              textStyle: TextStyle(
                color: AppColors.orange,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              borderRadius: BorderRadius.circular(12.r),
              onPressed: () => _showCancelOrderDialog(context),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 2,
            child: AppButton(
              text: "continue_shopping".tr(context),
              onPressed: () => PrintUtil.debug("Continue Shopping pressed"),
              type: AppButtonType.primary,
              backgroundColor: AppColors.orange,
              height: 56.h,
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CancelOrderDialog(),
    );
  }
}
