import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/package/views/cubit/package_cubit.dart';
import 'package:lasco/features/package/views/cubit/package_state.dart';
import 'package:lasco/features/package/views/widgets/dashed_border.dart';

class SendPackageForm extends StatelessWidget {
  final PackageCubit cubit;
  final PackageState state;

  const SendPackageForm({super.key, required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("shipment_type".tr(context)),
          _buildDropdownField(
            hint: "select_shipment_type".tr(context),
            value: state.shipmentType,
            items: cubit.shipmentTypes,
            onChanged: cubit.setShipmentType,
            context: context,
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle("shipment_images".tr(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => _buildImageUploadBox(
                context,
                index: index,
                state: state,
                cubit: cubit,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle("sender_details".tr(context)),
          AppTextField(
            controller: cubit.nameController,
            hintText: "enter_full_name".tr(context),
            radius: BorderRadiusDirectional.circular(12.r),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: cubit.mobileController,
            hintText: "enter_mobile_number".tr(context),
            keyboardType: TextInputType.phone,
            radius: BorderRadiusDirectional.circular(12.r),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: cubit.addressController,
            hintText: "enter_pickup_address".tr(context),
            maxLines: 2,
            radius: BorderRadiusDirectional.circular(12.r),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: cubit.pickupDateController,
                  hintText: "pickup_date".tr(context),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) cubit.setPickupDate(picked);
                  },
                  radius: BorderRadiusDirectional.circular(12.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField(
                  controller: cubit.pickupTimeController,
                  hintText: "pickup_time".tr(context),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) cubit.setPickupTime(picked, context);
                  },
                  radius: BorderRadiusDirectional.circular(12.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle("consignment_type".tr(context)),
          _buildDropdownField(
            hint: "select_consignment_type".tr(context),
            value: state.consignmentType,
            items: cubit.consignmentTypes,
            onChanged: cubit.setConsignmentType,
            context: context,
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle("package_size".tr(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPackageSizeCard(
                  context,
                  cubit,
                  state,
                  "assets/images/svg/single-pack.svg",
                  "less_than_1kg".tr(context)),
              _buildPackageSizeCard(
                  context,
                  cubit,
                  state,
                  "assets/images/svg/double-pack.svg",
                  "between_1_10kg".tr(context)),
              _buildPackageSizeCard(
                  context,
                  cubit,
                  state,
                  "assets/images/svg/trible-pack.svg",
                  "more_than_10kg".tr(context)),
            ],
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle("delivery_type".tr(context)),
          _buildDropdownField(
            hint: "select_delivery_type".tr(context),
            value: state.deliveryType,
            items: cubit.deliveryTypes,
            onChanged: cubit.setDeliveryType,
            context: context,
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle("additional_notes".tr(context)),
          AppTextField(
            controller: cubit.notesController,
            hintText: "add_special_instructions".tr(context),
            maxLines: 4,
            radius: BorderRadiusDirectional.circular(12.r),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
      );

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required BuildContext context,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e.tr(context))))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImageUploadBox(BuildContext context,
      {required int index,
      required PackageState state,
      required PackageCubit cubit}) {
    final hasImage = state.selectedImages[index] != null;
    return GestureDetector(
      onTap: () => _showImageSourceDialog(index, cubit, context),
      child: CustomPaint(
        painter: DashedBorderPainter(radius: 12.r),
        child: Container(
          width: 90.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: hasImage
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(state.selectedImages[index]!,
                            fit: BoxFit.cover),
                      ),
                    ),
                    PositionedDirectional(
                      end: 4,
                      top: 4,
                      child: GestureDetector(
                        onTap: () => cubit.removeImage(index),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Icon(CupertinoIcons.xmark,
                              size: 18.sp, color: Colors.red),
                        ),
                      ),
                    )
                  ],
                )
              : const Icon(Icons.add, color: Colors.grey),
        ),
      ),
    );
  }

  void _showImageSourceDialog(
      int index, PackageCubit cubit, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text("select_image_source".tr(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.pickImage(index, context, source: ImageSource.gallery);
            },
            child: Text("gallery".tr(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.pickImage(index, context, source: ImageSource.camera);
            },
            child: Text("camera".tr(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSizeCard(BuildContext context, PackageCubit cubit,
      PackageState state, String iconPath, String label) {
    final isSelected = state.selectedPackageSize == label;
    return GestureDetector(
      onTap: () => cubit.setPackageSize(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orange.withOpacity(0.1) : Colors.white,
          border: Border.all(
              color: isSelected ? AppColors.orange : const Color(0xffF7F7F7)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 40.w),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? AppColors.orange : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
