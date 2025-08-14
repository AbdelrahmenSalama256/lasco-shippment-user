import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';

import '../../../../../core/component/widgets/app_button.dart'; // Import your button

class SpecialOffersSection extends StatelessWidget {
  final List<OfferModel> offers;
  final VoidCallback? onViewAllPressed;

  const SpecialOffersSection({
    super.key,
    required this.offers,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        _buildSectionHeader(),
        SizedBox(height: 16.h),

        // Offers List
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: offers.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return OfferCard(
                offer: offers[index],
                onPressed: () => _onOfferPressed(offers[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Special Offers',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: onViewAllPressed,
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onOfferPressed(OfferModel offer) {
    // Handle offer card press
    if (kDebugMode) {
      print('Offer pressed: ${offer.title}');
    }
  }
}

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback? onPressed;

  const OfferCard({
    super.key,
    required this.offer,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          _buildProductImage(),

          SizedBox(width: 16.w),

          // Offer Details
          Expanded(
            child: _buildOfferDetails(),
          ),

          SizedBox(width: 12.w),

          // Action Button
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 60.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: offer.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                offer.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink[200]!,
            Colors.pink[300]!,
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          Icons.local_offer,
          color: Colors.white,
          size: 24.w,
        ),
      ),
    );
  }

  Widget _buildOfferDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          offer.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          offer.category,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return AppButton(
      text: '',
      onPressed: onPressed,
      type: AppButtonType.primary,
      isFullWidth: false,
      width: 40,
      height: 40,
      backgroundColor: Colors.orange,
      suffixIcon: Icon(
        Icons.arrow_forward,
        color: Colors.white,
        size: 16.w,
      ),
    );
  }
}

// Offer Model
class OfferModel {
  final String id;
  final String title;
  final String category;
  final String? imageUrl;
  final String? description;
  final DateTime? validUntil;

  OfferModel({
    required this.id,
    required this.title,
    required this.category,
    this.imageUrl,
    this.description,
    this.validUntil,
  });
}
