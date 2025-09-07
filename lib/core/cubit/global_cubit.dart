import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lasco/core/constants/app_constant.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';
import 'package:lasco/core/network/local_network.dart';
import 'package:lasco/core/services/service_locator.dart';
import 'package:lasco/features/auth/data/models/sign_up_models.dart';
import 'package:location/location.dart' as loc;

import '../../features/profile/data/repo/profile_repo.dart';
import 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  ResponseModel? userProfile;
  String? username;
  String? email;
  String? phone;
  String? countryCode;
  String? image;
  String? createdAt;
  String? updatedAt;

  void init() {
    getProfile();
    getCurrentLocation();
  }

  int currentNavIndex = 0;
  ScrollController controller = ScrollController();

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      emit(BottomNavChangeState());
    }
  }

  String language = sl<CacheHelper>().getCachedLanguage();
  Future<void> changeLanguage() async {
    emit(LanguageChangingState());
    await Future.delayed(const Duration(milliseconds: 300));
    final newLanguage = language == "en" ? "ar" : "en";
    await sl<CacheHelper>().cacheLanguage(newLanguage);
    language = newLanguage;
    PrintUtil.debug("Language changed to $language");
    emit(LanguageChangedState());
  }

  void updateToken(String token) {
    final cacheHelper = sl<CacheHelper>();
    cacheHelper.setData(AppConstants.token, token);
    PrintUtil.success("Global token updated: $token");
    emit(GlobalTokenUpdated());
  }

  /// Update user profile after successful profile update
  void updateUserProfile(ResponseModel? updatedProfile) {
    if (updatedProfile != null) {
      userProfile = updatedProfile;
      _updateUserData(updatedProfile);
      
      // Cache the updated profile
      sl<CacheHelper>().setData(
        AppConstants.userProfile, 
        jsonEncode(updatedProfile.toJson())
      );
      
      PrintUtil.success("Global user profile updated: ${updatedProfile.data?.username}");
      emit(ProfileUpdated()); // Emit state to notify UI
    }
  }

  /// Update user profile with individual fields (fallback method)
  void updateUserProfileWithFields({
    String? username,
    String? email,
    String? phone,
    String? imageUrl,
    String? countryCode,
  }) {
    if (userProfile?.data != null) {
      userProfile = ResponseModel(
        data: UserData(
          username: username ?? this.username ?? '',
          email: email ?? this.email ?? '',
          phone: phone ?? this.phone ?? '',
          image: imageUrl ?? image,
          countryCode: countryCode ?? this.countryCode,
          createdAt: createdAt,
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );
      
      _updateUserData(userProfile!);
      
      // Cache the updated profile
      sl<CacheHelper>().setData(
        AppConstants.userProfile, 
        jsonEncode(userProfile!.toJson())
      );
      
      PrintUtil.success("Global user profile updated with fields: $username");
      emit(ProfileUpdated());
    }
  }

  Future<void> getProfile({bool forceRefresh = false}) async {
    emit(ProfileLoading());

    final cacheHelper = sl<CacheHelper>();
    final token = cacheHelper.getDataString(key: AppConstants.token);

    if (token == null) {
      PrintUtil.error("No token found, user is not logged in.");
      emit(ProfileError(message: "No token found, please log in."));
      return;
    }

    // Load from cache if available and not forcing refresh
    if (!forceRefresh &&
        cacheHelper.getDataString(key: AppConstants.userProfile) != null) {
      try {
        userProfile = ResponseModel.fromJson(jsonDecode(
            cacheHelper.getDataString(key: AppConstants.userProfile)!));
        _updateUserData(userProfile!);
        PrintUtil.success(
            "Loaded user profile from cache: ${userProfile!.data?.username}");
        emit(ProfileLoaded());
        // Fetch fresh data in the background
        _fetchAndUpdateProfile();
        return;
      } catch (e) {
        PrintUtil.error("Error parsing cached profile: $e");
      }
    }

    // Fetch from server if no cache or forceRefresh is true
    await _fetchAndUpdateProfile();
  }

  Future<void> _fetchAndUpdateProfile() async {
    final response = await sl<ProfileRepo>().getUserProfile();
    response.fold(
      (failure) {
        PrintUtil.error("Failed to get profile: $failure");
        emit(ProfileError(message: failure));
      },
      (profileResponse) {
        userProfile = profileResponse;
        _updateUserData(profileResponse);
        sl<CacheHelper>().setData(
            AppConstants.userProfile, jsonEncode(profileResponse.toJson()));
        PrintUtil.success(
            "User profile fetched successfully: ${profileResponse.data?.username}");
        PrintUtil.info(
            "Cached user profile: ${sl<CacheHelper>().getDataString(key: AppConstants.userProfile)}");
        emit(ProfileLoaded());
      },
    );
  }

  void _updateUserData(ResponseModel userData) {
    username = userData.data?.username;
    email = userData.data?.email;
    phone = userData.data?.phone;
    countryCode = userData.data?.countryCode;
    image = userData.data?.image;
    createdAt = userData.data?.createdAt;
    updatedAt = userData.data?.updatedAt;
  }

  /// Refresh profile after update - this will fetch the latest data from server
  Future<void> refreshProfile() async {
    await getProfile(forceRefresh: true);
  }

  String? currentLocation;
  double? currentLat;
  double? currentLong;
  Future<void> getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        log('Location permission denied.');
        return;
      }
    }

    try {
      loc.LocationData locationData = await location.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      final newAddress =
          "${place.subThoroughfare}${place.subThoroughfare == '' ? '' : ', '}"
                  "${place.thoroughfare}${place.thoroughfare == '' ? '' : ', '}"
                  "${place.subAdministrativeArea}${place.subAdministrativeArea == '' ? '' : ', '}"
                  "${place.administrativeArea}${place.administrativeArea == '' ? '' : ', '}"
                  "${place.country}"
              .trim();

      log('Current Location: $newAddress');
      log('Lat: $latitude, Lng: $longitude');
      currentLocation = newAddress;
      currentLat = latitude;
      currentLong = longitude;
      emit(LocationUpdated());
    } on Exception catch (e) {
      log('Location request: $e');
      emit(LocationError(message: e.toString()));
    }
  }

  /// Clear user profile data (used on logout)
  void clearUserProfile() {
    userProfile = null;
    username = null;
    email = null;
    phone = null;
    countryCode = null;
    image = null;
    createdAt = null;
    updatedAt = null;
    sl<CacheHelper>().removeData(key: AppConstants.userProfile);
    emit(ProfileCleared());
  }
}