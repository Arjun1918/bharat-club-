import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/snackbar.dart';
import 'package:organization/data/local/shared_prefs/shared_prefs.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final Color? iconColor;

  MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.iconColor,
  });
}

class MenuSection {
  final List<MenuItem> items;

  MenuSection({required this.items});
}

class CustomMenuDrawer extends StatefulWidget {
  const CustomMenuDrawer({super.key});

  @override
  State<CustomMenuDrawer> createState() => _CustomMenuDrawerState();
}

class _CustomMenuDrawerState extends State<CustomMenuDrawer>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;

  String currentLogo = 'assets/images/logo.png';

  List<MenuSection> menuSections = [
    MenuSection(
      items: [
        MenuItem(
          title: 'Profile',
          icon: Icons.person_rounded,
          route: '/profile',
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'Membership',
          icon: Icons.card_membership_rounded,
          route: AppRoutes.membership,
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'Home',
          icon: Icons.home_rounded,
          route: '/home',
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'Events',
          icon: Icons.event_rounded,
          route: AppRoutes.events,
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'Gallery',
          icon: Icons.photo_library_rounded,
          route: AppRoutes.gallery,
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'Contact Us',
          icon: Icons.contact_mail_rounded,
          route: AppRoutes.contactUs,
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'About Us',
          icon: Icons.info_rounded,
          route: AppRoutes.aboutus,
          iconColor: AppColors.white,
        ),
        MenuItem(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_rounded,
          route: '/privacy-policy',
          iconColor: AppColors.white,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: Drawer(
        backgroundColor: AppColors.secondaryGreen,
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Image.asset(
                        currentLogo,
                        width: 200.w,
                        height: 60.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.precision_manufacturing_outlined,
                            size: 28.sp,
                            color: AppColors.white,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: menuSections.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = menuSections[sectionIndex];
                    return Column(
                      children: section.items
                          .map((item) => _buildMenuItem(item))
                          .toList(),
                    );
                  },
                ),
              ),

              // Logout Button
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade700, width: 1),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.secondaryGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () async {
                        final shouldLogout = await Get.dialog<bool>(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            title: const Text('Confirm Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: AppColors.secondaryGreen,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Get.back(result: true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          barrierDismissible: false,
                        );

                        // If user pressed "Logout"
                        if (shouldLogout == true) {
                          await SharedPrefs().sharedPreferencesInstance();
                          await SharedPrefs().logout(); // or .logout()

                          context.showSuccessSnackbar(
                            "Logged out successfully",
                          );

                          Get.offAllNamed(AppRoutes.loginScreen);
                        }
                      },

                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            if (item.route != null) {
              Get.toNamed(item.route!);
            }
            FocusScope.of(context).unfocus();
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color:
                        item.iconColor?.withValues(alpha: 0.2) ??
                        Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor ?? Colors.grey.shade400,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
