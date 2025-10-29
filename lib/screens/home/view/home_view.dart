import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/carousel_slider.dart';
import 'package:organization/common/widgets/event_card.dart';
import 'package:organization/common/widgets/gallery_item.dart';
import 'package:organization/common/widgets/profile_card.dart';
import 'package:organization/common/widgets/menu_drawer.dart';
import 'package:organization/common/widgets/section_header.dart';
import 'package:organization/common/widgets/shimmer_box.dart';
import 'package:organization/common/widgets/sponsor_item.dart';
import 'package:organization/screens/home/view/home_controller.dart';
import '../../../alert/app_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.membershipTypeLoad();
  }

  @override
  void dispose() {
    controller.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Home',
        showMenu: true,
        showBack: false,
      ),
      drawer: const CustomMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.secondaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Obx(() {
            if (controller.userName.value.isEmpty &&
                controller.membershipType.value.isEmpty &&
                controller.photo.value.isEmpty) {
              return _buildShimmerLoading();
            }
            return _buildContent();
          }),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Obx(
          () => ProfileCard(
            welcomeText: 'Welcome back',
            userName: controller.userName.value.isNotEmpty
                ? controller.userName.value
                : 'Guest User',
            membershipType: controller.membershipType.value.isNotEmpty
                ? controller.membershipType.value
                : 'Member',
            profileImageUrl: controller.photo.value.isNotEmpty
                ? controller.photo.value
                : 'https://picsum.photos/200',
          ),
        ),
        _buildEventsSection(),
        _buildGallerySection(),
        _buildSponsorsCarousel(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: [
        const ProfileCardShimmer(),
        SectionShimmer(itemWidth: 280.w, itemHeight: 220.h, itemCount: 3),
        SectionShimmer(itemWidth: 160.w, itemHeight: 200.h, itemCount: 5),
        const SponsorShimmer(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    await controller.membershipTypeLoad();
  }

  Widget _buildEventsSection() {
    return Obx(() {
      final events = controller.mDashboardEventList;

      print('Events count: ${events.length}');

      if (events.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Events',
            onViewAllPressed: () {
              Get.toNamed(AppRoutes.events);
            },
          ),
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                String imageUrl = 'https://picsum.photos/400/200';
                if (event.eventAttachments != null &&
                    event.eventAttachments!.isNotEmpty) {
                  imageUrl = event.eventAttachments!.first.fileUrl ?? imageUrl;
                }

                return EventCard(
                  title: event.title ?? 'Event',
                  description: event.description ?? '',
                  imageUrl: imageUrl,
                  date: event.startDate ?? '',
                  index: index,
                  onTap: () {
                    _handleEventTap(event);
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
  void _handleEventTap(dynamic event) {
    if (controller.membershipStatus.value) {
      controller.checkEventAppliedStatus(event);
    } else {
      AppAlert.showSnackBar(Get.context!, "Please renew your membership");
    }
  }

  Widget _buildGallerySection() {
    return Obx(() {
      final galleries = controller.mDashboardGalleryList;

      print('Galleries count: ${galleries.length}');

      if (galleries.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Gallery',
            onViewAllPressed: () {
              Get.toNamed(AppRoutes.gallery);
            },
          ),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: galleries.length,
              itemBuilder: (context, index) {
                final gallery = galleries[index];
                return GalleryItem(
                  title: gallery.fileName ?? 'Gallery',
                  imageUrl: gallery.fileUrl ?? 'https://picsum.photos/300/200',
                  index: index,
                  onTap: () =>
                      Get.toNamed(AppRoutes.gallery, arguments: gallery),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSponsorsCarousel() {
    return Obx(() {
      final sponsors = controller.mDashboardBeloBannerList;

      print('Sponsors count: ${sponsors.length}');

      if (sponsors.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Our Sponsors', showViewAll: false),
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 100.h,
              viewportFraction: 0.99,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              onPageChanged: (index, reason) {
                controller.currentSponsorIndex.value = index;
              },
            ),
            items: sponsors.asMap().entries.map((entry) {
              final index = entry.key;
              final sponsor = entry.value;
              return SponsorItem(
                imageUrl: sponsor.image ?? 'https://picsum.photos/100/100',
                index: index,
                onTap: () {
                  if (sponsor.redirectionUrl != null &&
                      sponsor.redirectionUrl!.isNotEmpty) {
                    controller.webView(sponsor.redirectionUrl!);
                  }
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CarouselIndicators(
              itemCount: sponsors.length,
              currentIndex: controller.currentSponsorIndex.value,
            ),
          ),
        ],
      );
    });
  }
}
