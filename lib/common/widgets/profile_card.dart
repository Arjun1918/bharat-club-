import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/utils/app_text.dart';

class ProfileCard extends StatelessWidget {
  final String welcomeText;
  final String userName;
  final String membershipType;
  final String profileImageUrl;

  const ProfileCard({
    super.key,
    required this.welcomeText,
    required this.userName,
    required this.membershipType,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA726), Colors.white, Color(0xFF66BB6A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  welcomeText,
                  style: getTextSemiBold(
                    size: 14.sp,
                    colors: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  userName,
                  style: getTextBold(
                    size: 20.sp,
                    colors: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    membershipType,
                    style: getTextSemiBold(
                      size: 12.sp,
                      colors: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Hero(
            tag: 'profile_image',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.r),
                child: Image.network(
                  profileImageUrl,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
