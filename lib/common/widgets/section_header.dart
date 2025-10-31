import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/utils/app_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllPressed;
  final bool showViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAllPressed,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: getTextSemiBold(
              colors: AppColors.secondaryGreen,
              size: 18.sp,
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: onViewAllPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: getTextMedium(
                  colors: AppColors.secondaryGreen,
                  size: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}