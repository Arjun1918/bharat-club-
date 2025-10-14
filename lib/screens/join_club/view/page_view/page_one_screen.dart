import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:organization/common/constant/size_constants.dart';
import 'package:organization/screens/join_club/view/page_view/page_four_screen.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/color_constants.dart';
import '../../../../data/mode/join_clube/join_club_response.dart';

import '../../controller/join_club_controller.dart';

class PageOneScreen extends StatelessWidget {
  late JoinClubController mJoinClubController = Get.find();

  PageOneScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
        body: FocusDetector(
            onVisibilityGained: () {},
            onVisibilityLost: () {},
            child: Container(
                height: SizeConstants.height * 0.85,
                width: SizeConstants.width,
                padding: EdgeInsets.all(SizeConstants.s1 * 13),
                margin: EdgeInsets.fromLTRB(
                    SizeConstants.s1 * 13,
                    SizeConstants.s1 * 13,
                    SizeConstants.s1 * 13,
                    SizeConstants.s1 * 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConstants.s1 * 10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: pageOneView())));
  }

  pageOneView() {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "IT'S TIME TO JOIN ${mJoinClubController.sJoinClubTitle.value}",
                style: getTextSemiBold(
                    colors: ColorConstants.cAppColorsBlue,
                    size: SizeConstants.s1 * 22),
              ),
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Html(
              shrinkWrap: true,
              data: mJoinClubController.sJoinClubShotDec.value.trim() ?? "",
              onLinkTap: (url, _, __) {
                if (url.toString().trim().isNotEmpty) {
                  // LauncherUtils().launchWebUrlInsideApp(
                  //     url.toString().trim(), context);
                }
              },
              style: {
                "body": Style(
                    color: Colors.black,
                    fontSize: FontSize(SizeConstants.s1 * 17),
                    textAlign: TextAlign.justify
                    // fontWeight: FontWeight.bold,
                    ),
                'html': Style(textAlign: TextAlign.justify)
              },
            ),
            // Text(
            //   "APPLICATION FOR THE MEMBERSHIP OF ‘BHARAT CLUB’-KUALA LUMPUR"
            //       .toUpperCase(),
            //   textAlign: TextAlign.center,
            //   style: getTextMedium(
            //       colors: Colors.black, size: SizeConstants.s1 * 17),
            // ),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: SizeConstants.s1 * 5),
                child: Html(
                  shrinkWrap: true,
                  data: mJoinClubController.sJoinClubAddress.value ?? "",
                  onLinkTap: (url, _, __) {
                    if (url.toString().trim().isNotEmpty) {
                      // LauncherUtils().launchWebUrlInsideApp(
                      //     url.toString().trim(), context);
                    }
                  },
                  style: {
                    "body": Style(
                      color: ColorConstants.cAppColorsBlue,
                      fontSize: FontSize(SizeConstants.s1 * 17),
                      // fontWeight: FontWeight.bold,
                    ),
                  },
                )

                // Text(
                //   "To\n" +
                //       "The Secretary,\n" +
                //       "Kelab Bharat Kuala Lumpur,\n" +
                //       "P.O. Box: 11802, 50782, Kuala Lumpur\n" +
                //       "E-mail: clubbharat@gmail.com",
                //   style: getTextMedium(
                //       colors: Colors.black, size: SizeConstants.s1 * 17),
                // ),
                ),
            SizedBox(
              height: SizeConstants.s1 * 15,
            ),
            Container(
              height: SizeConstants.s1 * 3,
              color: ColorConstants.dividerColor,
            ),
            SizedBox(
              height: SizeConstants.s1 * 15,
            ),
            Text(
              "Membership Type *".toUpperCase(),
              textAlign: TextAlign.start,
              style: getTextMedium(
                  colors: Colors.black, size: SizeConstants.s1 * 17),
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            // GestureDetector(
            //   onTap: () {
            //     mJoinClubController.selectRadioButtonValue.value = 1;
            //   },
            //   child: Row(
            //     children: [
            //       Radio(
            //         value: 1,
            //         groupValue:
            //             mJoinClubController.selectRadioButtonValue.value,
            //         onChanged: (value) {
            //           mJoinClubController.selectRadioButtonValue.value = 1;
            //         },
            //       ),
            //       Text(
            //         "LIFE MEMBERSHIP - RM 2000".toUpperCase(),
            //         textAlign: TextAlign.start,
            //         style: getTextRegular(
            //             colors: Colors.black, size: SizeConstants.s1 * 15),
            //       ),
            //     ],
            //   ),
            // ),
            // GestureDetector(
            //     onTap: () {
            //       mJoinClubController.selectRadioButtonValue.value = 2;
            //     },
            //     child: Row(
            //       children: [
            //         Radio(
            //           value: 2,
            //           groupValue:
            //               mJoinClubController.selectRadioButtonValue.value,
            //           onChanged: (value) {
            //             mJoinClubController.selectRadioButtonValue.value = 2;
            //           },
            //         ),
            //         Expanded(
            //             child: Text(
            //           "ORDINARY MEMBERSHIP - RM 200 (until Dec 2024)",
            //           textAlign: TextAlign.start,
            //           style: getTextRegular(
            //               colors: Colors.black, size: SizeConstants.s1 * 15),
            //         )),
            //       ],
            //     )),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mJoinClubController.sJoinClubMembership.value.length,
              itemBuilder: (BuildContext context, int index) {
                ClubsMembership mClubsMembership =
                    mJoinClubController.sJoinClubMembership.value[index];
                return GestureDetector(
                    onTap: () {
                      mJoinClubController.selectRadioButtonValue.value =
                          index + 1;
                      mJoinClubController.mClubsMembership.value =
                          mClubsMembership;
                      // mJoinClubController.mAmountController.value.text =
                      // "RM ${mClubsMembership.membershipPackageAmount ?? ""}";
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: (index + 1),
                          groupValue:
                              mJoinClubController.selectRadioButtonValue.value,
                          onChanged: (value) {
                            mJoinClubController.selectRadioButtonValue.value =
                                index + 1;
                            mJoinClubController.mClubsMembership.value =
                                mClubsMembership;
                            // mJoinClubController.mAmountController.value.text =
                            // "RM ${mClubsMembership.membershipPackageAmount ?? ""}";
                          },
                        ),
                        Expanded(
                            child: Text(
                          (mClubsMembership.membershipPackageTitle ?? "") +
                              " - RM " +
                              (mClubsMembership.membershipPackageAmount ?? ""),
                          textAlign: TextAlign.start,
                          style: getTextRegular(
                              colors: Colors.black,
                              size: SizeConstants.s1 * 15),
                        )),
                      ],
                    ));
              },
            ),
            SizedBox(
              height: SizeConstants.s1 * 25,
            ),
            Row(
              mainAxisAlignment:
                  (mJoinClubController.selectRadioButtonValue.value == 1 ||
                          mJoinClubController.selectRadioButtonValue.value == 2)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
              children: [
                Container(
                    height: SizeConstants.s1 * 55,
                    width: SizeConstants.width * 0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeConstants.s1 * 5),
                    ),
                    child: rectangleRoundedCornerSemiBoldButton("BACK", () {
                      mJoinClubController.isJoinClub.value = false;
                      mJoinClubController.selectRadioButtonValue.value = 0;
                    },
                        buttonColors: ColorConstants.cAppColors,
                        textColors: Colors.white)),
                Visibility(
                  visible: (mJoinClubController.selectRadioButtonValue.value ==
                          1 ||
                      mJoinClubController.selectRadioButtonValue.value == 2),
                  child: Container(
                      height: SizeConstants.s1 * 55,
                      width: SizeConstants.width * 0.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConstants.s1 * 5),
                      ),
                      child: rectangleRoundedCornerSemiBoldButton("NEXT", () {
                        mJoinClubController.pageController.jumpToPage(1);
                      },
                          buttonColors: ColorConstants.cAppColors,
                          textColors: Colors.white)),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
