import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/core/network/local_network.dart';
import 'package:lasco/core/services/service_locator.dart';

import '../../../core/constants/app_colors.dart';
import 'cubit/pickup_address_cubit.dart';
import 'cubit/pickup_address_state.dart';
import 'widgets/address_bottom_sheet.dart';
import 'widgets/current_location_button.dart';
import 'widgets/location_search_field.dart';
import 'widgets/map_widget.dart';

class PickupAddressScreen extends StatelessWidget {
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;

  const PickupAddressScreen({
    super.key,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickupAddressCubit(
        initialAddress: initialAddress,
        initialLat: initialLat,
        initialLng: initialLng,
      ),
      child: const PickupAddressContent(),
    );
  }
}

class PickupAddressContent extends StatelessWidget {
  const PickupAddressContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<PickupAddressCubit, PickupAddressState>(
        listener: (context, state) {
          if (state is PickupAddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PickupAddressInitial) {
            // Initialize location when widget is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<PickupAddressCubit>().initializeLocation(
                    defaultLat: context.read<GlobalCubit>().currentLat ?? 0.0,
                    defaultLng: context.read<GlobalCubit>().currentLong ?? 0.0,
                    defaultAddress: 'unknown_address'.tr(context),
                  );
            });
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PickupAddressLoaded) {
            return Stack(
              children: [
                MapWidget(
                  cameraPosition: state.cameraPosition,
                  markers: state.markers,
                  onMapCreated: (controller) {
                    context.read<PickupAddressCubit>().setMapLoaded();
                  },
                  onCameraMove: (position) {
                    context.read<PickupAddressCubit>().updateLocation(
                          LatLng(position.target.latitude,
                              position.target.longitude),
                        );
                  },
                ),
                if (!state.isMapLoaded)
                  Container(
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                //! Marker
                Positioned(
                    child: Container(
                  margin: EdgeInsets.only(bottom: 40.h),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.orange,
                      size: 50.sp,
                    ),
                  ),
                )),
                Positioned(
                  top: 45.h,
                  left: 20.w,
                  right: 20.w,
                  child: SingleChildScrollView(
                    child: const LocationSearchField(),
                  ),
                ),
                Positioned(
                  top: 150.h,
                  right: isRTL ? null : 20.w,
                  left: isRTL ? 20.w : null,
                  child: const CurrentLocationButton(),
                ),
                AddressBottomSheet(
                  address: state.address,
                  isAddressSelected: state.isAddressSelected,
                  markerPosition: state.markerPosition,
                ),
              ],
            );
          }

          if (state is PickupAddressError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
