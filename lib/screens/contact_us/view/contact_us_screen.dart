import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:organization/alert/app_alert.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/banner_card.dart';
import 'package:organization/common/widgets/loader.dart';
import 'package:organization/screens/contact_us/controller/contact_us_controller.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/color_constants.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/networl_util.dart';

class ContactUsListScreen extends GetView<ContactUsController> {
  const ContactUsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ContactUsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "Contact Us"),
      body: FocusDetector(
        onVisibilityGained: () {
          NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
            if (isInternetAvailable) {
              await controller.getContactUsApi();
            } else {
              AppAlert.showSnackBar(
                Get.context!,
                MessageConstants.noInternetConnection,
              );
            }
          });
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CustomLoader());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              shadowColor: Colors.grey.withOpacity(0.3),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🖼️ Banner
                    BannerCard(
                      bannerUrl: controller.mContactUsResponse.value.data
                              ?.cmsPageAttachments?.first.fileUrl ??
                          "",
                      height: 200.h,
                      borderRadius: 12.r,
                    ),
                    SizedBox(height: 20.h),

                    /// 📍 Contact Details
                    Text(
                      controller.contactUsValidator.value
                          ? (controller.mContactUsResponse.value.data?.module?.first.name ?? "")
                          : "Welcome to Bharat Club",
                      style: getTextSemiBold(colors: Colors.black, size: 18.0),
                    ),
                    SizedBox(height: 10.h),

                    Text(
                      controller.contactUsValidator.value
                          ? (controller.mContactUsResponse.value.data?.module?.first.address ?? "")
                          : "MALAYSIA - Kuala Lumpur",
                      style: getTextSemiBold(
                        colors: ColorConstants.cAppColorsBlue,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Divider(thickness: 1, color: Colors.grey.withOpacity(0.3)),
                    SizedBox(height: 10.h),

                    /// 📞 Mobile
                    Row(
                      children: [
                        const Icon(Icons.phone, color: ColorConstants.cAppColorsBlue, size: 20),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            controller.contactUsValidator.value
                                ? (controller.mContactUsResponse.value.data?.module?.first.primaryMobile ?? "")
                                : "+6 019 533 1794",
                            style: getTextRegular(
                              colors: ColorConstants.cAppColorsBlue,
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    /// ✉️ Email
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: ColorConstants.cAppColorsBlue, size: 20),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            controller.contactUsValidator.value
                                ? (controller.mContactUsResponse.value.data?.module?.first.email ?? "")
                                : "clubbharat@gmail.com",
                            style: getTextRegular(
                              colors: ColorConstants.cAppColorsBlue,
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
