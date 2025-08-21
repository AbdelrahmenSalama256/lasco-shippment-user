import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';
import 'package:lasco/features/package/views/cubit/package_cubit.dart';
import 'package:lasco/features/package/views/cubit/package_state.dart';
import 'package:lasco/features/package/views/reciver_details_screen.dart';
import 'package:lasco/features/package/views/widgets/send_package_form.dart';

import '../../../core/component/widgets/app_button.dart';

class SendPackageScreen extends StatelessWidget {
  const SendPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PackageCubit(),
      child: BlocConsumer<PackageCubit, PackageState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<PackageCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(title: "send_package".tr(context)),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  /// Extracted form section
                  SendPackageForm(cubit: cubit, state: state),

                  /// Bottom button
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: AppButton(
                        onPressed: () {
                          // if (cubit.validateForm(context)) {
                          //   debugPrint("Form submitted");
                          // }
                          navigateTo(
                            context,
                            ReciverDetailsScreen(),
                          );
                        },
                        text: "continue".tr(context),
                        backgroundColor: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
