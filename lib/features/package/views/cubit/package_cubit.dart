import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/package/views/cubit/package_state.dart';
import 'package:permission_handler/permission_handler.dart';

class PackageCubit extends Cubit<PackageState> {
  PackageCubit() : super(PackageState());

  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();

  // Dropdown Options
  final shipmentTypes = ["document", "parcel", "fragile"];
  final consignmentTypes = ["documents", "electronics", "clothes", "food", "others"];
  final deliveryTypes = ["standard", "express", "same_day"];

  // Update dropdowns
  void setShipmentType(String? value) {
    emit(state.copyWith(shipmentType: value));
  }

  void setConsignmentType(String? value) {
    emit(state.copyWith(consignmentType: value));
  }

  void setDeliveryType(String? value) {
    emit(state.copyWith(deliveryType: value));
  }

  void setPackageSize(String value) {
    emit(state.copyWith(selectedPackageSize: value));
  }

  // Pick Image with Permission
  Future<void> pickImage(int index, BuildContext context, {ImageSource source = ImageSource.gallery}) async {
    try {
      PermissionStatus status;
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          status = await Permission.camera.request(); // For camera
          if (source == ImageSource.gallery) {
            status = await Permission.photos.request();
          }
        } else {
          status = await Permission.camera.request(); // For camera
          if (source == ImageSource.gallery) {
            status = await Permission.storage.request();
          }
        }
      } else {
        status = await Permission.camera.request(); // For camera
        if (source == ImageSource.gallery) {
          status = await Permission.photos.request();
        }
      }

      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );

        if (image != null) {
          final updatedImages = [...state.selectedImages];
          updatedImages[index] = File(image.path);
          emit(state.copyWith(selectedImages: updatedImages));
        }
      } else if (status.isDenied) {
        debugPrint("Permission denied for $source");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("permission_denied_for_${source.name}".tr(context))),
        );
      } else if (status.isPermanentlyDenied) {
        debugPrint("Permission permanently denied for $source");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("permission_permanently_denied_for_${source.name}".tr(context)),
            action: SnackBarAction(
              label: "settings".tr(context),
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error picking image from $source: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("error_picking_image_from_${source.name}".tr(context))),
      );
    }
  }

  void removeImage(int index) {
    final updatedImages = [...state.selectedImages];
    updatedImages[index] = null;
    emit(state.copyWith(selectedImages: updatedImages));
  }

  // Date / Time pickers
  void setPickupDate(DateTime picked) {
    pickupDateController.text = "${picked.day}/${picked.month}/${picked.year}";
    emit(state.copyWith());
  }

  void setPickupTime(TimeOfDay picked, BuildContext context) {
    pickupTimeController.text = picked.format(context);
    emit(state.copyWith());
  }

  // Validation
  bool validateForm(BuildContext context) {
    if (state.shipmentType == null ||
        nameController.text.isEmpty ||
        mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("fill_required_fields".tr(context))),
      );
      return false;
    }
    return true;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    notesController.dispose();
    pickupDateController.dispose();
    pickupTimeController.dispose();
    return super.close();
  }
}