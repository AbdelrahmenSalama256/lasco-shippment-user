import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/features/profile/views/cubit/profile_cubit.dart';

class ProfileImageSection extends StatelessWidget {
  final ProfileCubit cubit;
  final VoidCallback onChangeImage;

  const ProfileImageSection(
      {super.key, required this.onChangeImage, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 112.w,
          height: 112.w,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: cubit.profileImage != null
              ? Image.file(
                  File(cubit.profileImage!.path),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50.w,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50.w,
                    color: Colors.grey[400],
                  ),
                ),
        ),
        PositionedDirectional(
          bottom: -20,
          end: 10,
          child: GestureDetector(
            onTap: onChangeImage,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                CupertinoIcons.pen,
                size: 16.w,
                color: AppColors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
