import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/constant/custom_image.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/banner_card.dart';
import 'package:organization/data/mode/cms_page/event_response.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/color_constants.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/network_util.dart';
import '../../../alert/app_alert.dart';
import '../controller/event_controller.dart';
import 'package:flutter/foundation.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late EventController controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() async {
    try {
      if (Get.isRegistered<EventController>()) {
        controller = Get.find<EventController>();
      } else {
        controller = Get.put(EventController());
      }

      _isInitialized = true;

      if (mounted) {
        await _fetchEventData();
      }
    } catch (e) {
      if (kDebugMode) print('Error initializing controller: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Events'),
        body: Center(child: SizedBox.shrink()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Events'),
      body: FocusDetector(
        onVisibilityGained: () async {
          if (kDebugMode) print('EventScreen visibility gained');
          if (_isInitialized && mounted && controller.hasLoadedOnce.value) {
            await _fetchEventData();
          }
        },
        child: Obx(() {
          return Container(
            height: 0.85.sh,
            width: 1.sw,
            padding: EdgeInsets.all(13.w),
            margin: EdgeInsets.all(13.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: eventView(),
          );
        }),
      ),
    );
  }

  Future<void> _fetchEventData() async {
    try {
      if (kDebugMode) print('Fetching event data...');
      bool isInternetAvailable = await NetworkUtils().checkInternetConnection();

      if (isInternetAvailable) {
        await controller.getEventUsApi();
        if (kDebugMode) print('Event data fetched successfully');
      } else {
        if (mounted && Get.context != null) {
          AppAlert.showSnackBar(
            Get.context!,
            MessageConstants.noInternetConnection,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching event data: $e');
      if (mounted && Get.context != null) {
        AppAlert.showSnackBar(
          Get.context!,
          'Error loading events: ${e.toString()}',
        );
      }
    }
  }

  Widget eventView() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          BannerCard(bannerUrl: controller.sEventBannerImage.value),
          SizedBox(height: 5.h),
          Html(data: controller.sEventDec.value),
          SizedBox(height: 5.h),
          controller.intEventCount.value > 0
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.mEventList.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    EventModule mEventModule = controller.mEventList[index];
                    return GestureDetector(
                      onTap: () =>
                          controller.checkEventAppliedStatus(mEventModule),
                      child: Container(
                        height: 160.h,
                        margin: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            _generateEvent(mEventModule),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.35),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mEventModule.title ?? "",
                                    style: getTextSemiBold(
                                      colors: Colors.white,
                                      size: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    mEventModule.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextRegular(
                                      colors: Colors.white,
                                      size: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 15.w,
                              bottom: 15.h,
                              child: Text(
                                mEventModule.endDate ?? "",
                                style: getTextRegular(
                                  colors: Colors.white,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  height: 250.h,
                  child: Text(
                    "No data found",
                    style: getTextSemiBold(
                      colors: ColorConstants.cAppColorsBlue,
                      size: 18.sp,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _generateEvent(EventModule mEventModule) {
    final imageUrl = mEventModule.eventAttachments?.first.fileUrl ?? '';
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: cacheImageBannerExploreOurProgram(
          imageUrl,
          ImageAssetsConstants.goParkingLogoJpg,
        ),
      ),
    );
  }
}
