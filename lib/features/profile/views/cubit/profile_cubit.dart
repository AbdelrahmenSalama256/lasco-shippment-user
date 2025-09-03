import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/profile/data/repo/profile_repo.dart';

import '../../../../core/component/widgets/app_custom_dialog.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/database/api/end_points.dart';
import '../../../../core/network/local_network.dart';
import '../../../../core/services/service_locator.dart';
import '../widgets/image_picker_bottom_sheet.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    initializeControllers();
  }

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  XFile? profileImage;
  bool isPasswordVisible = false;
  bool isEmailValid = true;

  void initializeControllers() {
    final globalCubit = sl<GlobalCubit>();
    nameController.text = globalCubit.userProfile?.data?.username ?? '';
    emailController.text = globalCubit.userProfile?.data?.email ?? '';
    phoneController.text = globalCubit.userProfile?.data?.phone ?? '';
    emit(ProfileLoaded(
        isEmailValid: isEmailValid, isPasswordVisible: isPasswordVisible));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(ProfileLoaded(
      isPasswordVisible: isPasswordVisible,
      isEmailValid: isEmailValid,
    ));
  }

  void validateEmail(String email) {
    isEmailValid = email.isEmpty ||
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    emit(ProfileLoaded(
      isPasswordVisible: isPasswordVisible,
      isEmailValid: isEmailValid,
    ));
  }

  void updateProfile() {
    emit(ProfileLoading());
    try {
      // Here you would normally save the data
      PrintUtil.success("Profile updated successfully");
      emit(ProfileUpdated());
      emit(ProfileLoaded(
        isPasswordVisible: isPasswordVisible,
        isEmailValid: isEmailValid,
      ));
    } catch (e) {
      emit(ProfileError("Failed to update profile: $e"));
    }
  }

  //! Logout
  Future<void> userLogout() async {
    emit(LogoutLoadingState());
    final result = await sl<ProfileRepo>().userLogout();
    result.fold(
      (l) => emit(LogoutErrorState(l)),
      (r) {
        sl<CacheHelper>().removeData(key: ApiKey.token);
        // sl<CacheHelper>().removeData(key: AppConstants.cookie);
        // sl<CacheHelper>().removeData(key: ApiKey.wss_token);
        emit(LogoutSuccessState(r.message ?? ""));
      },
    );
  }

  void deleteAccount() {
    emit(ProfileLoading());
    try {
      // Simulate account deletion
      PrintUtil.success("Account deleted successfully");
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError("Failed to delete account: $e"));
    }
  }

  void changeProfileImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ImagePickerBottomSheet(
        onCameraPressed: () {
          Navigator.pop(context);
          // Handle camera
        },
        onGalleryPressed: () {
          Navigator.pop(context);
          // Handle gallery
        },
      ),
    );
  }

  void showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        imagePath: "assets/images/svg/delete-account.svg",
        title: "delete_account_confirmation_title".tr(context),
        buttons: [
          DialogButton(
            text: "delete_it".tr(context),
            backgroundColor: const Color(0xffFEEBE3),
            textStyle: TextStyle(
              color: AppColors.orange,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            onPressed: () {
              deleteAccount();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          DialogButton(
            text: "no_keep_it".tr(context),
            backgroundColor: AppColors.orange,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            height: 56.h,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
