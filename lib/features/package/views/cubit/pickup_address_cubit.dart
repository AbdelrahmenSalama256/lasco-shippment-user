import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';

import 'pickup_address_state.dart';

class PickupAddressCubit extends Cubit<PickupAddressState> {
  PickupAddressCubit({
    String? initialAddress,
    double? initialLat,
    double? initialLng,
  }) : super(PickupAddressInitial(
          initialAddress: initialAddress,
          initialLat: initialLat,
          initialLng: initialLng,
        ));

  Future<void> initializeLocation({
    required double defaultLat,
    required double defaultLng,
    required String defaultAddress,
  }) async {
    try {
      final currentState = state as PickupAddressInitial;
      final lat = currentState.initialLat ?? defaultLat;
      final lng = currentState.initialLng ?? defaultLng;
      final address = currentState.initialAddress ?? defaultAddress;

      final markerPosition = LatLng(lat, lng);
      final cameraPosition = CameraPosition(target: markerPosition, zoom: 17);

      emit(PickupAddressLoaded(
        markerPosition: markerPosition,
        cameraPosition: cameraPosition,
        address: address,
        isAddressSelected: currentState.initialAddress != null,
        markers: {
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: markerPosition,
            infoWindow: const InfoWindow(title: 'Selected Location'),
          ),
        },
      ));
    } catch (e) {
      PrintUtil.error("Location initialization failed: $e");
      emit(PickupAddressError(message: 'Failed to initialize location'));
    }
  }

  Future<void> updateLocation(LatLng position) async {
    if (state is! PickupAddressLoaded) return;

    final currentState = state as PickupAddressLoaded;
    final markers = {
      Marker(
        markerId: const MarkerId('selectedLocation'),
        position: position,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      ),
    };

    emit(currentState.copyWith(
      markerPosition: position,
      markers: markers,
      isAddressSelected: false,
    ));

    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    if (state is! PickupAddressLoaded) return;

    final currentState = state as PickupAddressLoaded;

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String address = '${place.name ?? ''}, ${place.street ?? ''}, '
            '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, '
            '${place.country ?? ''}';

        address = address
            .replaceAll(RegExp(r', ,'), ',')
            .replaceAll(RegExp(r',,'), ',')
            .replaceAll(RegExp(r'^, '), '');

        emit(currentState.copyWith(
          address: address,
          isAddressSelected: true,
        ));
      }
    } catch (e) {
      PrintUtil.error('Failed to get address: $e');
      emit(currentState.copyWith(
        address: 'Unknown address',
        isAddressSelected: false,
      ));
    }
  }

  void updateAddress(String address) {
    if (state is! PickupAddressLoaded) return;

    final currentState = state as PickupAddressLoaded;
    emit(currentState.copyWith(address: address));
  }

  void setMapLoaded() {
    if (state is! PickupAddressLoaded) return;

    final currentState = state as PickupAddressLoaded;
    emit(currentState.copyWith(isMapLoaded: true));
  }
}
