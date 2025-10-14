import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:organization/alert/app_alert.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/banner_card.dart';
import 'package:organization/screens/gallery/controller/gallery_contoller.dart';
import 'package:organization/screens/gallery/model/gallery_model.dart';
import 'package:organization/utils/color_constants.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/network_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryListScreen extends GetView<GalleryController> {
  const GalleryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => GalleryController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: 'Gallery', showMenu: false, showBack: true),
      body: FocusDetector(
        onVisibilityGained: () {
          NetworkUtils().checkInternetConnection().then((
            isInternetAvailable,
          ) async {
            if (isInternetAvailable) {
              await controller.getGalleryUsApi();
            } else {
              AppAlert.showSnackBar(
                Get.context!,
                MessageConstants.noInternetConnection,
              );
            }
          });
        },
        onVisibilityLost: () {},
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: galleryView(context),
        ),
      ),
    );
  }

  Widget galleryView(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerCard(bannerUrl: controller.sGalleryBannerImage.value),
            const SizedBox(height: 15),
            Text(
              "${controller.sGalleryTitle.value}\n${controller.sGalleryDec.value}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            controller.intGalleryCount.value > 0
                ? StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(1),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.mGalleryList.length,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildGalleryItem(
                        controller.mGalleryList[index],
                        index,
                        context,
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    height: 250,
                    child: Text(
                      "No data found",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.cAppColorsBlue,
                        fontSize: 18,
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }

  Widget _buildGalleryItem(
    GalleryModule mGalleryModule,
    int index,
    BuildContext context,
  ) {
    final isVideo = (mGalleryModule.videoUrl ?? '').isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (isVideo) {
          controller.webView((mGalleryModule.videoUrl ?? ''));
        }
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              (mGalleryModule.fileUrl ?? '').isEmpty
                  ? Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: Image.asset(
                          ImageAssetsConstants.goParkingLogo,
                          fit: BoxFit.contain,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: mGalleryModule.fileUrl ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorConstants.cAppColorsBlue,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              if (isVideo)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: ColorConstants.cAppColorsBlue,
                    ),
                  ),
                ),
              // Type indicator badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isVideo ? Icons.videocam : Icons.image,
                    size: 16,
                    color: ColorConstants.cAppColorsBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
