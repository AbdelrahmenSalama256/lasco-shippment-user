import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/component/widgets/app_button.dart';
import '../cubit/address_cubit.dart';

class AddressBottomSheet extends StatelessWidget {
  final Function(AddressModel)? onAddressSaved;

  const AddressBottomSheet({
    super.key,
    this.onAddressSaved,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<AddressCubit>();
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(top: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          "enter_address_manually".tr(context),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Address/Area Field
                        _buildTextField(
                          controller: cubit.addressController,
                          label: "address_area".tr(context),
                          hint: "enter_your_address".tr(context),
                        ),

                        SizedBox(height: 16.h),

                        // City Field
                        _buildTextField(
                          controller: cubit.cityController,
                          label: "city".tr(context),
                          hint: "select_city".tr(context),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[400],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Street Name Field
                        _buildTextField(
                          controller: cubit.streetController,
                          label: "street_name".tr(context),
                          hint: "enter_street_name".tr(context),
                        ),

                        SizedBox(height: 16.h),

                        // Building Name/Number Field
                        _buildTextField(
                          controller: cubit.buildingController,
                          label: "building_name_number".tr(context),
                          hint: "enter_building_name_number".tr(context),
                        ),

                        SizedBox(height: 16.h),

                        // Floor/Apartment and Landmark Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: cubit.floorController,
                                label: "floor_apartment".tr(context),
                                hint: "floor_apt".tr(context),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildTextField(
                                controller: cubit.landmarkController,
                                label: "landmark".tr(context),
                                hint: "landmark".tr(context),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Address Type Selection
                        _buildAddressTypeSelection(cubit),

                        SizedBox(height: 20.h),

                        // OR Divider
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "or".tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Pick Exact Location
                        GestureDetector(
                          onTap: cubit.pickExactLocation,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: AppColors.orange, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                "pick_exact_location".tr(context),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.orange,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Save Button
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: AppButton(
                    text: "save".tr(context),
                    onPressed: () {
                      cubit.handleSaveAddress(context, onAddressSaved);
                    },
                    backgroundColor: AppColors.orange,
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          controller: controller,
          hintText: hint,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }

  Widget _buildAddressTypeSelection(AddressCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: cubit.addressTypes.map((type) {
            bool isSelected = cubit.selectedAddressType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  cubit.updateAddressType(type);
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                    end: type != cubit.addressTypes.last ? 8.w : 0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.orange : const Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? AppColors.white : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AddressModel {
  final String address;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String landmark;
  final String type;

  AddressModel({
    required this.address,
    required this.city,
    required this.street,
    required this.building,
    required this.floor,
    required this.landmark,
    required this.type,
  });

  @override
  String toString() {
    return '$building, $street, $address, $city';
  }
}
