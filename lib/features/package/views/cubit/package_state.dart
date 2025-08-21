import 'dart:io';

class PackageState {
  final String? shipmentType;
  final String? consignmentType;
  final String? deliveryType;
  final String? selectedPackageSize;
  final List<File?> selectedImages;

  PackageState({
    this.shipmentType,
    this.consignmentType,
    this.deliveryType,
    this.selectedPackageSize,
    List<File?>? selectedImages,
  }) : selectedImages = selectedImages ?? [null, null, null];

  PackageState copyWith({
    String? shipmentType,
    String? consignmentType,
    String? deliveryType,
    String? selectedPackageSize,
    List<File?>? selectedImages,
  }) {
    return PackageState(
      shipmentType: shipmentType ?? this.shipmentType,
      consignmentType: consignmentType ?? this.consignmentType,
      deliveryType: deliveryType ?? this.deliveryType,
      selectedPackageSize: selectedPackageSize ?? this.selectedPackageSize,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }
}
