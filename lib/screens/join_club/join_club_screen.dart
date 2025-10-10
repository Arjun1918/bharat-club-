// import 'package:flutter/material.dart';
// import 'package:focus_detector/focus_detector.dart';
// import 'package:get/get.dart';
// import 'package:organization/common/constant/custom_image.dart';
// import 'package:organization/common/constant/image_constants.dart';
// import 'package:organization/common/constant/size_constants.dart';
// import 'package:organization/common/widgets/appbar.dart';
// import 'package:organization/screens/join_club/join_club_controller.dart';
// import 'package:organization/utils/app_text.dart';
// import 'package:organization/utils/color_constants.dart';


// class JoinClubScreen extends GetView<JoinClubController> {
//   const JoinClubScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => JoinClubController());
//     return FocusDetector(
//         onVisibilityGained: () {
//           controller.getJoinClubApi();
//         },
//         onVisibilityLost: () {
//           Get.delete<JoinClubController>();
//         },
//         child: Scaffold(
//             appBar: CustomAppBar(title: "Join Club"),
//             // drawer: SideMenuDrawer(
//             //     sMenuType: sJoinClub.tr, fValue: (String value) {}),
//             body: joinClubView()));
//   }

//   joinClubView() {
//     return Obx(() {
//       return controller.isJoinClub.value
//           ? PageView(
//               controller: controller.pageController,
//               physics: const NeverScrollableScrollPhysics(),
//               onPageChanged: (index) {},
//               children: List.generate(controller.bottomBarPages.length,
//                   (index) => controller.bottomBarPages[index]),
//             )
//           : clubView();
//     });
//   }

//   clubView() {
//     return Container(
//         height: SizeConstants.height * 0.85,
//         width: SizeConstants.width,
//         padding: EdgeInsets.all(SizeConstants.s1 * 13),
//         margin: EdgeInsets.fromLTRB(
//             SizeConstants.s1 * 13,
//             SizeConstants.s1 * 13,
//             SizeConstants.s1 * 13,
//             SizeConstants.s1 * 13),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius:
//               BorderRadius.all(Radius.circular(SizeConstants.s1 * 10)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.4),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 1), // changes position of shadow
//             ),
//           ],
//         ),
//         child: showView());
//   }

//   showView() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _generateBanners(controller.sJoinClubBannerImage.value),
//           SizedBox(
//             height: SizeConstants.s1 * 15,
//           ),
//           Text(
//             "IT'S TIME TO JOIN ${controller.sJoinClubTitle.value}",
//             style: getTextSemiBold(
//                 colors: ColorConstants.cAppColorsBlue,
//                 size: SizeConstants.s1 * 22),
//           ),
//           SizedBox(
//             height: SizeConstants.s1 * 15,
//           ),
//           Text(
//             "Become a member".toUpperCase(),
//             style: getTextMedium(
//                 colors: Colors.black, size: SizeConstants.s1 * 18),
//           ),
//           SizedBox(
//             height: SizeConstants.s1 * 5,
//           ),
//           Text(
//             "Click the button below and become a ${controller.sJoinClubTitle.value} Kuala Lumpur member.",
//             style: getTextMedium(
//                 colors: Colors.grey.shade600, size: SizeConstants.s1 * 16),
//           ),
//           SizedBox(
//             height: SizeConstants.s1 * 15,
//           ),
//           Container(
//               height: SizeConstants.s1 * 55,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(SizeConstants.s1 * 5),
//               ),
//               child: rectangleRoundedCornerSemiBoldButton("JOIN ${controller.sJoinClubTitle.value}",
//                   () {
//                 controller.isJoinClub.value = true;
//               },
//                   buttonColors: ColorConstants.cAppColors,
//                   textColors: Colors.white)),
//           SizedBox(
//             height: SizeConstants.s1 * 15,
//           ),
//           Text(
//             "Having issues? Contact us directly:",
//             style: getTextMedium(
//                 colors: Colors.grey.shade600, size: SizeConstants.s1 * 16),
//           ),
//           SizedBox(
//             height: SizeConstants.s1 * 15,
//           ),
//           Row(
//             children: [
//               Text(
//                 "Club phone :".toUpperCase(),
//                 style: getTextRegular(
//                     colors: Colors.black, size: SizeConstants.s1 * 15),
//               ),
//               SizedBox(
//                 width: SizeConstants.s1 * 10,
//               ),
//               Text(
//                 controller.sJoinClubPhone.value,
//                 style: getTextRegular(
//                     colors: ColorConstants.cAppColorsBlue,
//                     size: SizeConstants.s1 * 15),
//               )
//             ],
//           ),
//           SizedBox(
//             height: SizeConstants.s1 * 5,
//           ),
//           Row(
//             children: [
//               Text(
//                 "Club email :",
//                 style: getTextRegular(
//                     colors: Colors.black, size: SizeConstants.s1 * 15),
//               ),
//               SizedBox(
//                 width: SizeConstants.s1 * 10,
//               ),
//               Text(
//                 controller.sJoinClubEmail.value,
//                 style: getTextRegular(
//                     colors: ColorConstants.cAppColorsBlue,
//                     size: SizeConstants.s1 * 15),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   ///banner
//   Widget _generateBanners(String banner) {
//     return SizedBox(
//       height: SizeConstants.width * 0.45,
//       width: SizeConstants.width,
//       child: Card(
//         child: Center(
//           child: ClipRRect(
//               borderRadius: BorderRadius.circular(SizeConstants.s1 * 10),
//               child: banner.isEmpty
//                   ? SizedBox(
//                       width: SizeConstants.width * 0.5,
//                       child: Image.asset(
//                         ImageAssetsConstants.goParkingLogoJpg,
//                         fit: BoxFit.fitWidth,
//                       ))
//                   : cacheImageBannerExploreOurProgram(
//                       banner, ImageAssetsConstants.goParkingLogoJpg)),
//         ),
//       ),
//     );
//   }
// }
