import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/features/profile/views/cubit/profile_cubit.dart';
import 'package:lasco/features/profile/views/cubit/profile_state.dart';

class ProfileImageSection extends StatelessWidget {
  final ProfileCubit cubit;
  final VoidCallback onChangeImage;

  const ProfileImageSection(
      {super.key, required this.onChangeImage, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final currentImage = cubit.profileImage;
        final serverImageUrl = cubit.serverImageUrl;

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
              child: _buildProfileImage(currentImage,
                  context.read<GlobalCubit>().userProfile?.data?.image),
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
                    border: Border.all(
                      color: Colors.white,
                      width: 2.w,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.pen,
                    size: 16.w,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ),
            if (currentImage != null || serverImageUrl != null)
              PositionedDirectional(
                top: 0,
                start: 0,
                child: GestureDetector(
                  onTap: () => cubit.clearProfileImage(),
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage(XFile? currentImage, String? serverImageUrl) {
    if (currentImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.file(
          File(currentImage.path),
          fit: BoxFit.cover,
          width: 112.w,
          height: 112.w,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    }

    // Priority 2: Server image from URL
    if (serverImageUrl != null && serverImageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: serverImageUrl,
          fit: BoxFit.cover,
          width: 112.w,
          height: 112.w,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: AppColors.orange,
            ),
          ),
          errorWidget: (context, url, error) => _buildDefaultAvatar(),
        ),
      );
    }

    // Priority 3: Default avatar
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 112.w,
      height: 112.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.person,
        size: 50.w,
        color: Colors.grey[400],
      ),
    );
  }
}
