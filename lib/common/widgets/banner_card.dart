import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/utils/color_constants.dart';

class BannerCard extends StatelessWidget {
  final String bannerUrl;
  final double height;
  final double borderRadius;

  const BannerCard({
    super.key,
    required this.bannerUrl,
    this.height = 180,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.cAppColorsBlue.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.cAppColorsBlue.withOpacity(0.1),
                  ),
                ),
              ),

              // Banner content
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: bannerUrl.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            ImageAssetsConstants.goParkingLogoJpg,
                            fit: BoxFit.contain,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: bannerUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.cAppColorsBlue,
                            ),
                          ),
                          errorWidget: (context, url, error) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              ImageAssetsConstants.goParkingLogoJpg,
                              fit: BoxFit.contain,
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
}
