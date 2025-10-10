import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/utils/color_constants.dart';

class MembershipDetailsScreen extends StatelessWidget {
  const MembershipDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Membership'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 32.h),
            _buildProfileSection(),
            SizedBox(height: 24.h),
            _membershipTypeUI(),
            SizedBox(height: 16.h),
            _membershipDetailsUI(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Container(
        width: 130.w,
        height: 130.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.indiaorange, AppColors.tertiaryGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        padding: EdgeInsets.all(4.r),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8.r),
          child: ClipOval(
            child: Image.asset("assets/images/pic.png", fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _membershipTypeUI() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            AppColors.indiaorange, // orange
            AppColors.white, // light gray
            AppColors.secondaryGreen, // green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              "Membership Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 20),

          _infoRow(Icons.card_membership, "Membership Id", "--"),
          const Divider(height: 24, thickness: 1, color: Colors.black26),
          _infoRow(Icons.stars, "Membership Type", "Premium"),
          const Divider(height: 24, thickness: 1, color: Colors.black26),
          _infoRow(Icons.calendar_today, "Valid Until", "31-12-2025"),

          const Divider(height: 24, thickness: 1, color: Colors.black26),
          _infoRow(
            Icons.verified,
            "Status",
            "Active",
            valueColor: Colors.green.shade800,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.blue,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _membershipDetailsUI() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ColorConstants.cAppColors, AppColors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.white, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  "Member Benefits & Offers",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.r),
            child: HtmlWidget(
              '''
<div style="line-height: 1.8;">
<p style="margin-bottom: 16px; color: #2C3E50; font-weight: 600;">Dear Bharat Club Members,</p>

<p style="margin-bottom: 16px; color: #E74C3C; font-weight: 700; font-size: 16px;">🎉 Countdown to 50th Anniversary</p>

<p style="margin-bottom: 20px; color: #34495E;">We are pleased to announce an updated list of restaurants offering exclusive discounts to Bharat Club registered members in 2024.</p>

<div style="background: linear-gradient(135deg, #FFF8F0 0%, #F0FFF4 100%); padding: 20px; border-radius: 12px; margin-bottom: 20px; border-left: 4px solid #ED9F54;">

<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Bombay Palace:</strong> 15%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Delhi Royale:</strong> 10%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Musca:</strong> 10%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>WTF Restaurant:</strong> 10%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Cholas by WTF:</strong> 10%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Sagar Restaurant:</strong> 10%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Frangipani:</strong> 15%</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #ED9F54;">★</strong> <strong>Spice Garden (all branches):</strong> 10% + Complimentary dessert</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #4EAB5F;">★</strong> <strong>Sunway Medical Center:</strong> 15% on selected Medical Checkups</p>
<p style="margin: 8px 0; color: #2C3E50;"><strong style="color: #4EAB5F;">★</strong> <strong>Olive Tree Group:</strong> 15% off F&B (dine-in only)</p>

</div>

<p style="margin-bottom: 16px; color: #34495E; background: #E8F5E9; padding: 12px; border-radius: 8px;">📱 <strong>E-Membership Card:</strong> Available to all 2024 registered members. Check your messages!</p>

<p style="margin-bottom: 12px; color: #27AE60; font-weight: 600;">Thanks for being part of Bharat Club Kuala Lumpur.</p>

<p style="margin-top: 20px; margin-bottom: 4px; color: #7F8C8D;">Best regards,</p>
<p style="margin: 0; color: #2C3E50; font-weight: 600;">Bharat Club Management Committee</p>
</div>
''',
              textStyle: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF2C3E50),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
