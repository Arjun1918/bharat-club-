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
                        color: AppColors.cAppColorsBlue,
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
        } else {
          // Show fullscreen image viewer for images
          _showFullscreenImage(context, mGalleryModule, index);
        }
      },
      child: Hero(
        tag: 'gallery_${index}',
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
                              color: AppColors.cAppColorsBlue,
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
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
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
                        color: AppColors.cAppColorsBlue,
                      ),
                    ),
                  ),
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
                      color: AppColors.cAppColorsBlue,
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

  void _showFullscreenImage(
    BuildContext context,
    GalleryModule mGalleryModule,
    int initialIndex,
  ) {
    Get.to(
      () => FullscreenGalleryViewer(
        galleryList: controller.mGalleryList.cast<GalleryModule>().toList(),
        initialIndex: initialIndex,
      ),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => FullscreenGalleryController());
      }),
    );
  }
}

// Fullscreen Gallery Controller
class FullscreenGalleryController extends GetxController {
  late PageController pageController;
  var currentIndex = 0.obs;
  var showControls = true.obs;

  void initializeController(int initialIndex) {
    currentIndex.value = initialIndex;
    pageController = PageController(initialPage: initialIndex);
  }

  void toggleControls() {
    showControls.value = !showControls.value;
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void nextPage(int totalItems) {
    if (currentIndex.value < totalItems - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// Fullscreen Gallery Viewer
class FullscreenGalleryViewer extends GetView<FullscreenGalleryController> {
  final List<GalleryModule> galleryList;
  final int initialIndex;

  const FullscreenGalleryViewer({
    super.key,
    required this.galleryList,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with initial index
    controller.initializeController(initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => Stack(
          children: [
            PageView.builder(
              controller: controller.pageController,
              itemCount: galleryList.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                final item = galleryList[index];
                return GestureDetector(
                  onTap: controller.toggleControls,
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Hero(
                        tag: 'gallery_$index',
                        child: (item.fileUrl ?? '').isEmpty
                            ? Image.asset(
                                ImageAssetsConstants.goParkingLogo,
                                fit: BoxFit.contain,
                              )
                            : CachedNetworkImage(
                                imageUrl: item.fileUrl ?? "",
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.cAppColorsBlue,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        size: 80,
                                        color: Colors.white54,
                                      ),
                                    ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Top Controls
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: controller.showControls.value ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${controller.currentIndex.value + 1} / ${galleryList.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Controls
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: controller.showControls.value ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: controller.currentIndex.value > 0
                            ? Colors.white
                            : Colors.white38,
                        size: 24,
                      ),
                      onPressed: controller.currentIndex.value > 0
                          ? controller.previousPage
                          : null,
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color:
                            controller.currentIndex.value <
                                galleryList.length - 1
                            ? Colors.white
                            : Colors.white38,
                        size: 24,
                      ),
                      onPressed:
                          controller.currentIndex.value < galleryList.length - 1
                          ? () => controller.nextPage(galleryList.length)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
