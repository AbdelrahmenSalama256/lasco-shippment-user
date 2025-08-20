import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class AddressBottomSheet extends StatelessWidget {
  final String address;
  final bool isAddressSelected;
  final LatLng markerPosition;

  const AddressBottomSheet({
    super.key,
    required this.address,
    required this.isAddressSelected,
    required this.markerPosition,
  });

  @override
  Widget build(BuildContext context) {
    final landmarkController = TextEditingController();
    final phoneController = TextEditingController();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pickup_address'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: landmarkController,
              hintText: 'landmark'.tr(context),
              labelText: 'landmark'.tr(context),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: phoneController,
              hintText: 'phone_number'.tr(context),
              labelText: 'phone_number'.tr(context),
            ),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: isAddressSelected
                  ? () => _confirmLocation(
                      context, landmarkController.text, phoneController.text)
                  : null,
              text: 'confirm_location'.tr(context),
              height: 50.h,
              backgroundColor: Colors.orange,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLocation(BuildContext context, String landmark, String phone) {
    Navigator.pop(context, {
      'lat': markerPosition.latitude,
      'lng': markerPosition.longitude,
      'address': address,
      'landmark': landmark,
      'phone': phone,
    });
  }
}
