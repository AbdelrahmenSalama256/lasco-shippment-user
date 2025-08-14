import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart'; // Ensure AppColors is imported
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/cart/views/cart_screen.dart';
import 'package:lasco/features/profile/views/profile_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../core/cubit/global_cubit.dart';
import '../../../core/cubit/global_state.dart';
import '../../favourite/views/favourite_screen.dart';
import '../../home/view/home_screen.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<GlobalCubit>(context);

        return WillPopScope(
          onWillPop: () async {
            if (cubit.currentNavIndex != 0) {
              cubit.changeBottomNavIndex(0);
            } else {
              return true;
            }
            return false;
          },
          child: Scaffold(
            body: IndexedStack(
              index: cubit.currentNavIndex,
              children: [
                HomeScreen(),
                CartScreen(),
                FavouriteScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 15,
                  spreadRadius: 0,
                  color: const Color.fromARGB(190, 10, 9, 11).withOpacity(0.1),
                )
              ]),
              child: SalomonBottomBar(
                currentIndex: cubit.currentNavIndex,
                onTap: (index) => cubit.changeBottomNavIndex(index),
                items: [
                  /// Home
                  SalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/svg/home.svg",
                      color: cubit.currentNavIndex == 0
                          ? AppColors.orange
                          : const Color(0xffB2B2B2),
                    ),
                    title: Text(
                      "home".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orange,
                      ),
                    ),
                    selectedColor: AppColors.orange,
                    activeIcon: SvgPicture.asset(
                      "assets/images/svg/home_fill.svg",
                      color: AppColors.orange,
                    ),
                  ),

                  /// Cart
                  SalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/svg/shopping-bag_outline.svg",
                      color: cubit.currentNavIndex == 1
                          ? AppColors.orange
                          : const Color(0xffB2B2B2),
                    ),
                    title: Text(
                      "cart".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orange,
                      ),
                    ),
                    selectedColor: AppColors.orange,
                    activeIcon: SvgPicture.asset(
                      "assets/images/svg/cart.svg",
                      color: AppColors.orange,
                    ),
                  ),

                  /// Profile
                  SalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/svg/wishlist.svg",
                      color: cubit.currentNavIndex == 2
                          ? AppColors.orange
                          : const Color(0xffB2B2B2),
                    ),
                    title: Text(
                      "favourite".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orange,
                      ),
                    ),
                    selectedColor: AppColors.orange,
                    activeIcon: SvgPicture.asset(
                      "assets/images/svg/fav-fill.svg",
                      color: AppColors.orange,
                    ),
                  ),

                  /// Settings
                  SalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/svg/profile.svg",
                      color: cubit.currentNavIndex == 3
                          ? AppColors.orange
                          : const Color(0xffB2B2B2),
                    ),
                    title: Text(
                      "profile".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.orange,
                      ),
                    ),
                    selectedColor: AppColors.orange,
                    activeIcon: SvgPicture.asset(
                      "assets/images/svg/profile-fill.svg",
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to demonstrate screen generation (optional, kept for reference)
}
