import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/checkout/views/cubit/checkout_cubit.dart';
import 'package:lasco/features/checkout/views/cubit/checkout_state.dart';

class DeliverySection extends StatelessWidget {
  const DeliverySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0XFFF7F7F7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Address Section
              GestureDetector(
                onTap: () => cubit.showAddressBottomSheet(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        Icon(
                          Icons.edit,
                          color: AppColors.orange,
                          size: 18.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      cubit.currentAddress?.toString() ??
                          "Building 36, Street 308, Degla square, maadi, cairo governorate",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // Phone Number Section
              GestureDetector(
                onTap: () => cubit.showPhoneBottomSheet(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.phone,
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
                        Icon(
                          Icons.edit,
                          color: AppColors.orange,
                          size: 18.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      cubit.phoneNumber,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
