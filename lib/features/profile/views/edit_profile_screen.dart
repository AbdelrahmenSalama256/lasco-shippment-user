import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';
import 'package:lasco/features/profile/views/cubit/profile_cubit.dart';
import 'package:lasco/features/profile/views/cubit/profile_state.dart';

import '../../../core/constants/widgets/print_util.dart';
import 'widgets/delete_account_button.dart';
import 'widgets/email_bottom_sheet.dart';
import 'widgets/otp_bottom_sheet.dart';
import 'widgets/profile_form_field.dart';
import 'widgets/profile_image_section.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "edit_profile".tr(context),
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit()..initializeControllers(),
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoading) {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is ProfileError) {
              // Close loading dialog if open
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
            } else if (state is ProfileUpdated) {
              showToast(
                context,
                message: "profile_updated_successfully".tr(context),
                state: ToastStates.success,
              );
              // Navigate back after a short delay to show the toast
              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              });
            } else if (state is ProfileDeleted) {
              // Handle account deletion - navigate to login or home
              if (context.mounted) {
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   '/login', // or '/home' depending on your navigation
                //   (route) => false,
                // );
              }
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final cubit = context.read<ProfileCubit>();
              final isLoading = state is ProfileLoading;

              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        _ProfileBody(cubit: cubit),
                      ],
                    ),
                  ),
                  _SaveChangesButton(
                    cubit: cubit,
                    isLoading: isLoading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ProfileCubit cubit;

  const _ProfileBody({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileImageSection(
            cubit: cubit,
            onChangeImage: () => cubit.changeProfileImage(context),
          ),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _NameField(cubit: cubit),
                SizedBox(height: 20.h),
                _EmailField(cubit: cubit),
                SizedBox(height: 20.h),
                _PhoneField(cubit: cubit),
                SizedBox(height: 20.h),
                _PasswordField(cubit: cubit),
                SizedBox(height: 40.h),
                DeleteAccountButton(
                  onDeletePressed: () => cubit.showDeleteConfirmation(context),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final ProfileCubit cubit;

  const _NameField({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return ProfileFormField(
          label: "name".tr(context),
          controller: cubit.nameController,
          hasEditIcon: true,
          isEnabled: state is! ProfileLoading, // Disable during loading
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final ProfileCubit cubit;

  const _EmailField({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isEnabled = state is! ProfileLoading;
        final globalCubit = context.read<GlobalCubit>();
        final isEmailVerified =
            globalCubit.userProfile?.data?.emailVerifiedAt != null;
        final email = cubit.emailController.text.trim();

        return BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is EmailVerificationSuccess) {
              Navigator.pop(context);

              // Show OTP verification sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => OtpBottomSheet(
                  email: email,
                  isLoading: state is OtpVerificationLoading,
                  onVerify: (otp) async {
                    // Verify the OTP
                    await cubit.verifyEmailOtp(email, otp);
                    Navigator.pop(context);
                  },
                  onResend: () {
                    // Resend OTP
                    cubit.sendEmailVerificationOtp();
                  },
                ),
              );
            }
            if (state is OtpVerificationSuccess) {
              showToast(context,
                  message: state.message, state: ToastStates.success);
              Navigator.pop(context);
            }
          },
          child: GestureDetector(
            onTap: !isEmailVerified
                ? () async {
                    PrintUtil.debug(
                        'Email field tapped - showing verification flow');

                    // Show email confirmation bottom sheet first
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EmailBottomSheet(
                        isLoading: state is EmailVerificationLoading,
                        emailController: cubit.emailController,
                        onConfirm: (email) async {
                          await cubit.sendEmailVerificationOtp();
                        },
                      ),
                    );
                  }
                : null,
            child: AbsorbPointer(
              // This prevents all interactions with the text field
              // but still allows the GestureDetector to work
              absorbing: !isEmailVerified,
              child: ProfileFormField(
                label: "email".tr(context),
                controller: cubit.emailController,
                hintText: "enter_email".tr(context),
                hasValidationIcon: true,
                isValid: isEmailVerified,
                isEnabled: isEmailVerified
                    ? isEnabled
                    : true, // Keep enabled for visual consistency
                keyboardType: TextInputType.emailAddress,
                onChanged: isEnabled ? cubit.validateEmail : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PhoneField extends StatelessWidget {
  final ProfileCubit cubit;

  const _PhoneField({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return ProfileFormField(
          label: "phone_number".tr(context),
          controller: cubit.phoneController,
          hasEditIcon: true,
          isEnabled: state is! ProfileLoading,
          keyboardType: TextInputType.phone,
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final ProfileCubit cubit;

  const _PasswordField({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isVisible =
            state is ProfileLoaded ? state.isPasswordVisible : false;
        final isEnabled = state is! ProfileLoading;

        return ProfileFormField(
          label: "password".tr(context),
          controller: cubit.passwordController,
          hasEditIcon: true,
          isPassword: true,
          isPasswordVisible: isVisible,
          isEnabled: isEnabled,
          onPasswordToggle: isEnabled ? cubit.togglePasswordVisibility : null,
        );
      },
    );
  }
}

class _SaveChangesButton extends StatelessWidget {
  final ProfileCubit cubit;
  final bool isLoading;

  const _SaveChangesButton({
    required this.cubit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileLoaded,
      builder: (context, state) {
        final isValid = state is ProfileLoaded ? state.isEmailValid : true;

        return Container(
          padding: EdgeInsets.all(16.w),
          child: AppButton(
            text: isLoading
                ? "saving_changes".tr(context)
                : "save_changes".tr(context),
            onPressed:
                isLoading || !isValid ? null : () => cubit.updateProfile(),
            backgroundColor: isLoading
                ? AppColors.grey
                : (isValid ? AppColors.orange : AppColors.grey),
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            isLoading: isLoading,
          ),
        );
      },
    );
  }
}
