import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/checkout/views/cubit/checkout_state.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import 'cubit/checkout_cubit.dart';
import 'widgets/cart_items_section.dart';
import 'widgets/delivery_section.dart';
import 'widgets/order_details_section.dart';
import 'widgets/payment_methods_section.dart';
import 'widgets/promo_code_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(),
      child:
          BlocBuilder<CheckoutCubit, CheckoutState>(builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "checkout".tr(context),
          ),
          body: SafeArea(
            // Added SafeArea to avoid overlap with status bar
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      // Ensure the Column has a constrained height
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            kToolbarHeight - // AppBar height
                            20.h -
                            20.h - // SizedBox height
                            10.h - // Vertical padding of AppButton
                            10.h, // Vertical padding of AppButton
                      ),
                      child: Column(
                        children: [
                          const CartItemsSection(),
                          SizedBox(height: 16.h),
                          const DeliverySection(),
                          SizedBox(height: 16.h),
                          PaymentMethodsSection(
                            selectedPaymentMethod: cubit.selectedPaymentMethod,
                            onPaymentSelected: (method) {
                              cubit.updatePaymentMethod(method);
                            },
                          ),
                          SizedBox(height: 16.h),
                          PromoCodeSection(
                            promoController: cubit.promoController,
                            onPromoApplied: (code) {
                              cubit.applyPromoCode(code);
                            },
                          ),
                          SizedBox(height: 16.h),
                          OrderDetailsSection(
                            subtotal: cubit.subtotal,
                            shipping: cubit.shipping,
                            discount: cubit.discount,
                            total: cubit.total,
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: AppButton(
                    onPressed: () {
                      cubit.handleConfirmOrder(context);
                    },
                    backgroundColor: AppColors.orange,
                    text: "confirm_order".tr(context),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
