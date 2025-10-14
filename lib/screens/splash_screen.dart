import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/animation/animation_background.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/utils/color_constants.dart';
import 'package:organization/data/local/shared_prefs/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  bool _hasNavigated = false;

  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _scheduleNavigation();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _scaleController.forward();
        _fadeController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _scheduleNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(seconds: 3), _checkLoginStatus);
    });
  }

  Future<void> _checkLoginStatus() async {
    if (!mounted || _hasNavigated) return;

    setState(() {
      _hasNavigated = true;
    });

    final prefs = SharedPrefs();
    await prefs.sharedPreferencesInstance();
    final loginStatus = await prefs.getUserLoginStatus();
    final token = await prefs.getUserToken();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (token.isNotEmpty && loginStatus != "0") {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackgroundWidget(
        primaryColor: ColorConstants.cAppColors,
        secondaryColor: ColorConstants.cAppColors,
        particleColor: ColorConstants.cAppColors,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildLogoCard(),
                ),
              ),
              SizedBox(height: 40.h),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildAppNameText(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.cAppColors.withOpacity(0.2),
            blurRadius: 30.r,
            offset: Offset(0, 10.h),
            spreadRadius: 5.r,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(30.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                ColorConstants.cAppColors.withOpacity(0.02),
              ],
            ),
          ),
          child: Hero(
            tag: 'app_logo',
            child: Image.asset(
              ImageAssetsConstants.goParkingLogoJpg,
              height: 100.h,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: ColorConstants.cAppColors.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.business,
                    size: 80.sp,
                    color: ColorConstants.cAppColors,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppNameText() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Bharat Club',
          style: TextStyle(
            fontSize: 28.sp,
            color: ColorConstants.cAppColors,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Manage everything efficiently',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
