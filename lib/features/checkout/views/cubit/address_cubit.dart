import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';

import '../widgets/address_bottom_sheet.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  String selectedAddressType = 'Home';
  final List<String> addressTypes = ['Home', 'Office', 'Other'];

  void updateAddressType(String type) {
    selectedAddressType = type;
    emit(AddressUpdated());
  }

  void handleSaveAddress(
    BuildContext context,
    Function(AddressModel)? onAddressSaved,
  ) {
    if (_validateForm(context)) {
      final address = AddressModel(
        address: addressController.text,
        city: cityController.text,
        street: streetController.text,
        building: buildingController.text,
        floor: floorController.text,
        landmark: landmarkController.text,
        type: selectedAddressType,
      );

      onAddressSaved?.call(address);
      Navigator.pop(context);
      showToast(context,
          message: "Address saved successfully!",
          state: ToastStates.success,
          style: ToastStyle.minimal);

      emit(AddressUpdated());
    }
  }

  bool _validateForm(BuildContext context) {
    if (addressController.text.isEmpty) {
      _showError(context, "Please enter your address");
      return false;
    }
    if (cityController.text.isEmpty) {
      _showError(context, "Please select a city");
      return false;
    }
    if (streetController.text.isEmpty) {
      _showError(context, "Please enter street name");
      return false;
    }
    return true;
  }

  void _showError(BuildContext context, String message) {
    showToast(context,
        message: message, state: ToastStates.error, style: ToastStyle.minimal);
  }

  void pickExactLocation() {
    if (kDebugMode) {
      PrintUtil.info("Pick exact location tapped");
    }
    emit(AddressUpdated());
  }

  @override
  Future<void> close() {
    addressController.dispose();
    cityController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    landmarkController.dispose();
    return super.close();
  }
}
