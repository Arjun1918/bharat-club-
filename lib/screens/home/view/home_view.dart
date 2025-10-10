import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/carousel_slider.dart';
import 'package:organization/common/widgets/event_card.dart';
import 'package:organization/common/widgets/gallery_item.dart';
import 'package:organization/common/widgets/menu_drawer.dart';
import 'package:organization/common/widgets/profile_card.dart';
import 'package:organization/common/widgets/section_header.dart';
import 'package:organization/common/widgets/shimmer_box.dart';
import 'package:organization/common/widgets/sponsor_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _eventsController = ScrollController();
  int _currentSponsorIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool _isLoading = true;

  // Mock data
  final List<Map<String, String>> _events = [
    {
      'title': 'Summer BBQ',
      'description': 'Join us for a fun-filled BBQ!',
      'image': 'https://picsum.photos/400/200',
      'date': 'Aug 15',
    },
    {
      'title': 'Holiday Feast',
      'description': 'Celebrate the holidays with delicious feast.',
      'image': 'https://picsum.photos/401/200',
      'date': 'Dec 25',
    },
    {
      'title': 'Cooking Workshop',
      'description': 'Learn new cooking skills from experts.',
      'image': 'https://picsum.photos/402/200',
      'date': 'Sep 10',
    },
  ];

  final List<String> _galleries = [
    'Delicious Dishes',
    'Culinary Creations',
    'Gourmet Meals',
    'Tasty Treats',
    'Food Photography',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _eventsController.dispose();
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _isLoading ? _buildShimmerLoading() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // User Profile Card
        ProfileCard(
          welcomeText: 'Welcome back',
          userName: 'Ethan Carter',
          membershipType: 'Premium Member',
          profileImageUrl: 'https://picsum.photos/200',
        ),

        // Events Section
        _buildEventsSection(),

        // Gallery Section
        _buildGallerySection(),

        // Sponsors Section with Carousel
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
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  Widget _buildEventsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Events',
            onViewAllPressed: () => _showComingSoon('Events'),
          ),
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              controller: _eventsController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return EventCard(
                  title: event['title']!,
                  description: event['description']!,
                  imageUrl: event['image']!,
                  date: event['date']!,
                  index: index,
                  onTap: () => _showComingSoon('Event: ${event['title']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Gallery',
            onViewAllPressed: () => _showComingSoon('Gallery'),
          ),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _galleries.length,
              itemBuilder: (context, index) {
                return GalleryItem(
                  title: _galleries[index],
                  imageUrl: 'https://picsum.photos/30$index/200',
                  index: index,
                  onTap: () => _showComingSoon('Gallery: ${_galleries[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorsCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Our Sponsors', showViewAll: false),
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 140.h,
            viewportFraction: 0.85,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSponsorIndex = index;
              });
            },
          ),
          items: List.generate(
            5,
            (index) => SponsorItem(
              imageUrl: 'https://picsum.photos/10$index/100',
              index: index,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        CarouselIndicators(itemCount: 5, currentIndex: _currentSponsorIndex),
      ],
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Coming Soon!',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryGreen,
          ),
        ),
        content: Text(
          '$feature feature will be available soon. Stay tuned for updates!',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppColors.secondaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
