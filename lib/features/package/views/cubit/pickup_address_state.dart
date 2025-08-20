import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PickupAddressState {
  const PickupAddressState();
}

class PickupAddressInitial extends PickupAddressState {
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;

  const PickupAddressInitial({
    this.initialAddress,
    this.initialLat,
    this.initialLng,
  });
}

class PickupAddressLoaded extends PickupAddressState {
  final LatLng markerPosition;
  final CameraPosition cameraPosition;
  final String address;
  final Set<Marker> markers;
  final bool isAddressSelected;
  final bool isMapLoaded;

  const PickupAddressLoaded({
    required this.markerPosition,
    required this.cameraPosition,
    required this.address,
    required this.markers,
    required this.isAddressSelected,
    this.isMapLoaded = false,
  });

  PickupAddressLoaded copyWith({
    LatLng? markerPosition,
    CameraPosition? cameraPosition,
    String? address,
    Set<Marker>? markers,
    bool? isAddressSelected,
    bool? isMapLoaded,
  }) {
    return PickupAddressLoaded(
      markerPosition: markerPosition ?? this.markerPosition,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      address: address ?? this.address,
      markers: markers ?? this.markers,
      isAddressSelected: isAddressSelected ?? this.isAddressSelected,
      isMapLoaded: isMapLoaded ?? this.isMapLoaded,
    );
  }
}

class PickupAddressError extends PickupAddressState {
  final String message;

  const PickupAddressError({required this.message});
}
