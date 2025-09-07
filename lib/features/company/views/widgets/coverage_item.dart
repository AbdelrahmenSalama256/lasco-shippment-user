import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../home/data/model/company_model.dart';

class CoverageItem extends StatefulWidget {
  final Coverage coverage;
  const CoverageItem({super.key, required this.coverage});

  @override
  State<CoverageItem> createState() => _CoverageItemState();
}

class _CoverageItemState extends State<CoverageItem> {
  bool isStateExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // State Header (expandable)
          ListTile(
            leading: SvgPicture.asset(
              "assets/images/svg/location.svg", // Reuse location icon
              width: 20.w,
            ),
            minLeadingWidth: 0.w,
            title: Text(
              widget.coverage.stateName ?? "state_unknown".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            trailing: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              child: IconButton(
                icon: Icon(
                  isStateExpanded
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 17.sp,
                  color: isStateExpanded ? AppColors.orange : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isStateExpanded = !isStateExpanded;
                  });
                },
              ),
            ),
          ),
          // Expanded Areas List
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isStateExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.coverage.areas != null &&
                      widget.coverage.areas!.isNotEmpty)
                    ...widget.coverage.areas!
                        .map((area) => _buildAreaItem(area))
                  else
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("no_areas".tr(context),
                          style: TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaItem(CoverageArea area) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Area Name and Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${area.name ?? "area_unknown".tr(context)} (${area.type ?? ""})",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.map_pin_ellipse,
                size: 14.sp,
                color: AppColors.orange,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Availability
          Row(
            children: [
              Icon(CupertinoIcons.circle_filled,
                  size: 8.sp, color: AppColors.orange),
              SizedBox(width: 6.w),
              Text(
                "${"pickup".tr(context)}: ${area.pickupAvailable == true ? 'available'.tr(context) : 'not_available'.tr(context)} | "
                "${"delivery".tr(context)}: ${area.deliveryAvailable == true ? 'available'.tr(context) : 'not_available'.tr(context)}",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          if (area.eta != null) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(CupertinoIcons.clock, size: 8.sp, color: AppColors.orange),
                SizedBox(width: 6.w),
                Text(
                  "${"eta".tr(context)}: ${area.eta!.minDays ?? 0}-${area.eta!.maxDays ?? 0} ${"days".tr(context)}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
          if (area.pricing != null && area.pricing!.etaPrice != null) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(CupertinoIcons.money_dollar_circle,
                    size: 8.sp, color: AppColors.orange),
                SizedBox(width: 6.w),
                Text(
                  "${"price".tr(context)}: ${area.pricing!.etaPrice}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
          if (area.notes != null && area.notes!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              "${"notes".tr(context)}: ${area.notes}",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
