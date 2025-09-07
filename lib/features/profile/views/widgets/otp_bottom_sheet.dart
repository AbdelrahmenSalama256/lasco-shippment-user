// widgets/otp_bottom_sheet.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';

class OtpBottomSheet extends StatefulWidget {
  final String email;
  final bool isLoading;

  final Function(String) onVerify;
  final Function() onResend;

  const OtpBottomSheet({
    super.key,
    required this.email,
    required this.onVerify,
    required this.onResend,
    required this.isLoading,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _resendCountdown = 20;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 20;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  void _handleResend() {
    widget.onResend();
    _startResendTimer();
  }

  void _handleVerify() {
    if (_formKey.currentState!.validate()) {
      widget.onVerify(_otpController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Color(0xffF7F7F7),
        // border: Border.all(color: Color(0xffF7F7F7)),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(50.r),
          topEnd: Radius.circular(50.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          Center(
            child: Text(
              "otp_title".tr(context),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.orange,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Center(
            child: Text(
              "otp_subtitle".tr(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // OTP Input
          Form(
            key: _formKey,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: Pinput(
                  length: 4,
                  controller: _otpController,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: Color(0xffF7F7F7),
                      border: Border.all(color: Color(0xffF7F7F7)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  onCompleted: (pin) => _handleVerify(),
                  validator: (value) {
                    if (value == null || value.length != 4) {
                      return "otp_invalid".tr(context);
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Resend Code Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _canResend
                  ? Text(
                      "otp_no_code".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                      ),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "00:${_resendCountdown.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
              if (_canResend)
                InkWell(
                  onTap: _handleResend,
                  child: Text(
                    "otp_resend".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 32.h),

          // Verify Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: _handleVerify,
              isLoading: widget.isLoading,
              backgroundColor: AppColors.orange,
              text: "otp_verify".tr(context),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16.h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }
}
