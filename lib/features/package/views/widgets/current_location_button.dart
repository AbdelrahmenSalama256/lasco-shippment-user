import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lasco/core/cubit/global_cubit.dart';

import '../cubit/pickup_address_cubit.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      mini: true,
      onPressed: () => _moveToCurrentLocation(context),
      child: const Icon(Icons.my_location, color: Colors.orange),
    );
  }

  Future<void> _moveToCurrentLocation(BuildContext context) async {
    final globalCubit = context.read<GlobalCubit>();
    final pickupCubit = context.read<PickupAddressCubit>();

    final currentLat = globalCubit.currentLat;
    final currentLong = globalCubit.currentLong;

    if (currentLat != null && currentLong != null) {
      pickupCubit.updateLocation(LatLng(currentLat, currentLong));
    }
  }
}
