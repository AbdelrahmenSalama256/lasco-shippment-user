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
  String? serverImageUrl;
  bool isPasswordVisible = false;
  bool isEmailValid = true;

  void initializeControllers() {
    final globalCubit = sl<GlobalCubit>();
    nameController.text = globalCubit.userProfile?.data?.username ?? '';
    emailController.text = globalCubit.userProfile?.data?.email ?? '';
    phoneController.text = globalCubit.userProfile?.data?.phone ?? '';
    serverImageUrl = globalCubit.userProfile?.data?.image;

    emit(ProfileLoaded(
        isEmailValid: isEmailValid,
        isPasswordVisible: isPasswordVisible,
        profileImage: profileImage,
        serverImageUrl: serverImageUrl));
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
        profileImage: profileImage,
        serverImageUrl: serverImageUrl));
  }

  void validateEmail(String email) {
    isEmailValid = email.isEmpty ||
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    emit(ProfileLoaded(
        isPasswordVisible: isPasswordVisible,
        isEmailValid: isEmailValid,
        profileImage: profileImage,
        serverImageUrl: serverImageUrl));
  }

  Future<void> updateProfile() async {
    if (!isEmailValid) {
      emit(ProfileError("Please enter a valid email address"));
      return;
    }

    // Validate password if provided
    final password = passwordController.text.trim();
    if (password.isNotEmpty && password.length < 8) {
      emit(ProfileError("Password must be at least 8 characters"));
      return;
    }

    emit(ProfileLoading());

    try {
      final globalCubit = sl<GlobalCubit>();

      final result = await sl<ProfileRepo>().updateProfile(
        username: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        image: profileImage,
        password: password.isNotEmpty ? password : null,
        countryCode: globalCubit.countryCode ?? '+20',
      );

      result.fold(
        (error) {
          PrintUtil.error("Profile update failed: $error");
          emit(ProfileError(error));
        },
        (updatedProfileResponse) {
          PrintUtil.success("Profile updated successfully");
          globalCubit.updateUserProfile(updatedProfileResponse);

          profileImage = null;

          nameController.text = updatedProfileResponse.data?.username ?? '';
          emailController.text = updatedProfileResponse.data?.email ?? '';
          phoneController.text = updatedProfileResponse.data?.phone ?? '';
          serverImageUrl = updatedProfileResponse.data?.image ?? '';

          emit(ProfileUpdated());
          emit(ProfileLoaded(
              isPasswordVisible: isPasswordVisible,
              isEmailValid: true,
              profileImage: profileImage,
              serverImageUrl: serverImageUrl));

          globalCubit.refreshProfile();
        },
      );
    } catch (e) {
      PrintUtil.error("Unexpected error during profile update: $e");
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
        sl<GlobalCubit>().clearUserProfile(); // Clear global data
        emit(LogoutSuccessState(r.message ?? ""));
      },
    );
  }

  Future<void> deleteAccount() async {
    // Fixed: Use repo instead of simulate
    emit(ProfileLoading());
    try {
      final result = await sl<ProfileRepo>().deleteAccount();
      result.fold(
        (error) {
          PrintUtil.error("Failed to delete account: $error");
          emit(ProfileError(error));
        },
        (response) {
          PrintUtil.success("Account deleted successfully");
          sl<GlobalCubit>().clearUserProfile(); // Clear global data
          emit(ProfileDeleted());
        },
      );
    } catch (e) {
      emit(ProfileError("Failed to delete account: $e"));
    }
  }

  /// Pick image from camera or gallery
  Future<void> changeProfileImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        onCameraPressed: () async {
          Navigator.pop(context);
          await _pickImage(context, ImageSource.camera);
        },
        onGalleryPressed: () async {
          Navigator.pop(context);
          await _pickImage(context, ImageSource.gallery);
        },
      ),
    );
  }

  /// Internal method to handle image picking
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // Check file size (limit to 5MB)
        final fileBytes = await image.length();
        final fileSizeInMB = fileBytes / (1024 * 1024);
        if (fileSizeInMB > 5) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Image size should be less than 5MB"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        profileImage = image;
        emit(ProfileLoaded(
          isPasswordVisible: isPasswordVisible,
          isEmailValid: isEmailValid,
          profileImage: profileImage,
        ));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("profile_image_selected".tr(context)),
              backgroundColor: AppColors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("failed_to_pick_image".tr(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
      PrintUtil.error("Error picking image: $e");
    }
  }

  /// Clear selected profile image
  void clearProfileImage() {
    profileImage = null;
    emit(ProfileLoaded(
      isPasswordVisible: isPasswordVisible,
      isEmailValid: isEmailValid,
      profileImage: profileImage,
    ));
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

  Future<void> sendEmailVerificationOtp() async {
    emit(EmailVerificationLoading());
    try {
      final result = await sl<ProfileRepo>()
          .sendEmailVerificationOtp(email: emailController.text);

      result.fold(
        (error) {
          PrintUtil.error("Failed to send OTP: $error");
          emit(EmailVerificationError(error));
        },
        (response) {
          PrintUtil.success("OTP sent successfully");
          emit(EmailVerificationSuccess(response.message ?? ""));
        },
      );
    } catch (e) {
      PrintUtil.error("Error sending OTP: $e");
      emit(EmailVerificationError("Failed to send OTP: $e"));
    }
  }

  Future<void> verifyEmailOtp(String email, String code) async {
    emit(OtpVerificationLoading()); // Specific state for OTP verification
    try {
      final result = await sl<ProfileRepo>().verifyEmailOtp(
        email: email,
        code: code,
      );

      result.fold(
        (error) {
          PrintUtil.error("OTP verification failed: $error");
          emit(OtpVerificationError(error)); // Specific error state
        },
        (response) {
          PrintUtil.success("Email verified successfully");

          emit(OtpVerificationSuccess(response.message ?? ""));
          final globalCubit = sl<GlobalCubit>();
          globalCubit.refreshProfile();
        },
      );
    } catch (e) {
      PrintUtil.error("Error verifying OTP: $e");
      emit(OtpVerificationError("Failed to verify OTP: $e"));
    }
  }
}
