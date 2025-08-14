import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'widgets/delete_account_button.dart';
import 'widgets/profile_form_field.dart';
import 'widgets/profile_image_section.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "edit_profile".tr(context),
        ),
        body: _ProfileBody(),
        bottomNavigationBar: _SaveChangesButton(),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          showToast(context, message: state.message, state: ToastStates.error);
        } else if (state is ProfileUpdated) {
          showToast(
            context,
            message: "profile_updated_successfully".tr(context),
            state: ToastStates.success,
          );
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: 30.h),
            ProfileImageSection(
              onChangeImage: () => cubit.changeProfileImage(context),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _NameField(),
                  SizedBox(height: 20.h),
                  _EmailField(),
                  SizedBox(height: 20.h),
                  _PhoneField(),
                  SizedBox(height: 20.h),
                  _PasswordField(),
                  SizedBox(height: 40.h),
                  DeleteAccountButton(
                    onDeletePressed: () =>
                        cubit.showDeleteConfirmation(context),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return ProfileFormField(
      label: "name".tr(context),
      controller: cubit.nameController,
      hasEditIcon: true,
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileLoaded,
      builder: (context, state) {
        final isValid = state is ProfileLoaded ? state.isEmailValid : true;
        return ProfileFormField(
          label: "email".tr(context),
          controller: cubit.emailController,
          hintText: "enter_email".tr(context),
          hasValidationIcon: true,
          isValid: isValid,
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.validateEmail,
        );
      },
    );
  }
}

class _PhoneField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return ProfileFormField(
      label: "phone_number".tr(context),
      controller: cubit.phoneController,
      hasEditIcon: true,
      keyboardType: TextInputType.phone,
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileLoaded,
      builder: (context, state) {
        final isVisible =
            state is ProfileLoaded ? state.isPasswordVisible : false;
        return ProfileFormField(
          label: "password".tr(context),
          controller: cubit.passwordController,
          hasEditIcon: true,
          isPassword: true,
          isPasswordVisible: isVisible,
          onPasswordToggle: cubit.togglePasswordVisibility,
        );
      },
    );
  }
}

class _SaveChangesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileLoaded,
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final isValid = state is ProfileLoaded ? state.isEmailValid : true;

        return Container(
          padding: EdgeInsets.all(16.w),
          child: AppButton(
            text: "save_changes".tr(context),
            onPressed: () {
              if (!isValid) {
                showToast(
                  context,
                  message: "please_enter_valid_email".tr(context),
                  state: ToastStates.error,
                );
                return;
              }
              cubit.updateProfile();
            },
            backgroundColor: AppColors.orange,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
