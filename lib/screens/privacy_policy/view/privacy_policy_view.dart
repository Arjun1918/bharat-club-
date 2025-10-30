// Privacy Policy Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/screens/privacy_policy/controller/privacy_controller.dart';
import 'package:organization/utils/app_text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: "Privacy Policy"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 24.h),

                // Main Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.shade50,
                                Colors.green.shade100.withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.shield_outlined,
                                  size: 48.sp,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Your Privacy Matters',
                                style: getTextBold(
                                  colors: Colors.black87,
                                  size: 24.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'We value and protect your personal information',
                                style: getTextRegular(
                                  colors: Colors.grey.shade600,
                                  size: 14.sp,
                                  heights: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Description
                        Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            'We are committed to protecting your privacy and ensuring the security of your personal information. Our comprehensive privacy policy outlines how we collect, use, store, and safeguard your data with the highest standards of security.',
                            style: getTextRegular(
                              colors: Colors.grey.shade700,
                              size: 15.sp,
                              heights: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Feature Cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      _buildFeatureCard(
                        icon: Icons.security_rounded,
                        title: 'Data Protection',
                        description:
                            'Your personal information is encrypted and stored securely with industry-standard protocols.',
                        gradient: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      SizedBox(height: 16.h),
                      _buildFeatureCard(
                        icon: Icons.lock_outline_rounded,
                        title: 'Privacy Control',
                        description:
                            'You have complete control over your data and privacy settings at all times.',
                        gradient: [
                          Colors.purple.shade400,
                          Colors.purple.shade600,
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildFeatureCard(
                        icon: Icons.verified_user_rounded,
                        title: 'Secure Transactions',
                        description:
                            'All transactions are processed through encrypted secure channels.',
                        gradient: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildFeatureCard(
                        icon: Icons.no_accounts_rounded,
                        title: 'No Data Sharing',
                        description:
                            'We never share your personal data with third parties without consent.',
                        gradient: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Obx(
                    () => Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.tertiaryGreen,
                            AppColors.cAppColorsGreen,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryGreen,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.launchPrivacyPolicy,
                          borderRadius: BorderRadius.circular(16.r),
                          child: Center(
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'View Full Privacy Policy',
                                        style: getTextSemiBold(
                                          colors: Colors.white,
                                          size: 16.sp,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.open_in_new_rounded,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Footer
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.link,
                            size: 16.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Opens in external browser',
                              style: getTextRegular(
                                colors: Colors.grey.shade500,
                                size: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextSemiBold(colors: Colors.black87, size: 16.sp),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    description,
                    style: getTextRegular(
                      colors: Colors.grey.shade600,
                      size: 13.sp,
                      heights: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
