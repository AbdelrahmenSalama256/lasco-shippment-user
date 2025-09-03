import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/auth/view/login_screen.dart';
import 'package:lasco/features/profile/views/cubit/profile_cubit.dart';
import 'package:lasco/features/profile/views/edit_profile_screen.dart';
import 'package:lasco/features/profile/views/my_orders_screen.dart';

import '../../../core/component/widgets/app_custom_dialog.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/widgets/print_util.dart';
import '../../../core/cubit/global_state.dart';
import '../../offers/views/widgets/custom_app_bar.dart';
import 'cubit/profile_state.dart';
import 'widgets/logout_button.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_items.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  String selectedLanguage = "العربية";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "profile".tr(context),
        onTap: () {
          context.read<GlobalCubit>().changeBottomNavIndex(0);
        },
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, globalState) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final cubit = context.read<ProfileCubit>();
                final globalCubit = context.read<GlobalCubit>();
                return BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is LogoutSuccessState) {
                      showToast(context,
                          message: state.massage, state: ToastStates.success);
                      Navigator.pop(context);
                      navigateAndFinish(context, LoginScreen());
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileHeader(
                          onEditPressed: _editProfile,
                          userName:
                              globalCubit.userProfile?.data?.username ?? "",
                          imagePath: "${globalCubit.userProfile?.data?.image}",
                        ),
                        SizedBox(height: 20.h),
                        ProfileMenuItems(
                          notificationsEnabled: notificationsEnabled,
                          selectedLanguage: selectedLanguage,
                          onNotificationChanged: (value) {
                            setState(() => notificationsEnabled = value);
                          },
                          onLanguageChanged: (language) {
                            setState(() => selectedLanguage = language);
                            context.read<GlobalCubit>().changeLanguage();
                          },
                          onOrdersPressed: _navigateToOrders,
                          onTermsPressed: _navigateToTerms,
                        ),
                        SizedBox(height: 20.h),
                        LogoutButton(
                          onPressed: () => _showLogoutDialog(cubit),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _editProfile() => navigateTo(context, const EditProfileScreen());
  void _navigateToOrders() => navigateTo(context, MyOrdersScreen());
  void _navigateToTerms() => PrintUtil.debug("Terms & Privacy tapped");

  void _showLogoutDialog(ProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        imagePath: context.read<GlobalCubit>().language == "ar"
            ? "assets/images/svg/exit-ar.svg"
            : "assets/images/svg/exit.svg",
        title: "are_you_sure_logout",
        subtitle: "",
        buttons: [
          DialogButton(
            text: "logout",
            backgroundColor: const Color(0xffFEEBE3),
            textStyle: TextStyle(
              color: AppColors.orange,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            onPressed: () async {
              await cubit.userLogout();
            },
          ),
          DialogButton(
            text: "keep_me_in",
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
