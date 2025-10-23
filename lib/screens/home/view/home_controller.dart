import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/shared_prefs/shared_prefs.dart';
import '../../../data/mode/banner_list/banner_list.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/common/constant/web_constant.dart';
import 'package:organization/data/mode/registration/registration_response.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/network_util.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../alert/app_alert.dart';
import '../../../../data/remote/web_response.dart';
import '../../../data/mode/cms_page/event_response.dart';
import '../../../data/mode/dashboard/dashboard_response.dart';
import '../../../data/mode/event_qr_scan/qr_details_request.dart';
import '../../../data/mode/event_qr_scan/qr_details_response.dart';
import '../../../data/mode/membership_type/membership_type_response.dart';
import '../../../data/mode/profile_response/profile_response.dart';
import '../../../data/remote/api_call/api_impl.dart';

class HomeController extends GetxController {
  late Timer _timer;

  PageController pageViewController = PageController(initialPage: 0);
  int _currentPage = 0;
  final _kDuration = const Duration(milliseconds: 350);
  final _kCurve = Curves.easeIn;

  final PageController certificationsPageController = PageController(
    initialPage: 0,
  );

  RxList mDashboardEventList = [].obs;
  RxList mDashboardGalleryList = [].obs;
  var beloBanner = 0.obs;
  RxList mDashboardBeloBannerList = [].obs;
  RxBool membershipStatus = false.obs;
  RxString membershipEndDate = "".obs;
  RxString photo = "".obs;
  RxString membershipType = "".obs;
  RxString membershipId = "".obs;
  RxString userName = "".obs;
  RxString spouseName = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    try {
      if (_timer.isActive) {
        _timer.cancel();
      }
    } catch (e) {}
    super.dispose();
  }

  void isTimerSt() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (mDashboardBeloBannerList.isNotEmpty) {
        if (pageViewController.hasClients) {
          if (_currentPage < mDashboardBeloBannerList.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          pageViewController.animateToPage(
            _currentPage,
            duration: _kDuration,
            curve: _kCurve,
          );
        }
      }
    });
  }

  void stopTimer() {
    if (_timer.isActive) {
      _currentPage = 0;
      _timer.cancel();
    }
  }

  void onPageViewChange(int page) {
    _currentPage = page;
  }

  membershipTypeLoad() async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postMembershipType();
        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          MembershipTypeResponse mMembershipTypeResponse =
              mWebResponseSuccess.data;
          if (mMembershipTypeResponse.statusCode ==
              WebConstants.statusCode200) {
            await SharedPrefs().setMembershipTypeAll(
              jsonEncode(mMembershipTypeResponse.data),
            );

            await getProfile();
            await getDashboard();
            await getBannerList();
          }
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  getDashboard() async {
    WebResponseSuccess mWebResponseSuccess = await AllApiImpl().postDashboard();
    if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
      DashboardResponse mDashboardResponse = mWebResponseSuccess.data;

      mDashboardEventList.clear();
      mDashboardEventList.addAll(mDashboardResponse.data?.eventList ?? []);
      mDashboardGalleryList.clear();
      mDashboardGalleryList.addAll(mDashboardResponse.data?.galleryList ?? []);
    }
  }

  getBannerList() async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postBannerList();
        BannerListResponse mBannerListResponse = mWebResponseSuccess.data;
        mDashboardBeloBannerList.clear();
        beloBanner.value = 0;
        if (mBannerListResponse.statusCode == 200) {
          mDashboardBeloBannerList.addAll(
            mBannerListResponse.data?.banner ?? [],
          );
          beloBanner.value = mDashboardBeloBannerList.length;

          if (mDashboardBeloBannerList.length > 1) {
            isTimerSt();
          }
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  getProfile() async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postProfile();
        ProfileResponse mProfileResponse = mWebResponseSuccess.data;
        List<MembershipTypeData> membershipList = await SharedPrefs()
            .getMembershipTypeAll();
        if (mProfileResponse.statusCode == WebConstants.statusCode400) {
          AppAlert.showSnackBar(Get.context!, "Token is Expired Please login");
          await SharedPrefs().setUserLoginStatus("0");
          await SharedPrefs().setUserToken("");
          await SharedPrefs().setUserDetails(jsonEncode(RegistrationUser()));
          Get.offNamed(AppRoutes.loginScreen);
        } else if (mWebResponseSuccess.statusCode ==
            WebConstants.statusCode200) {
          membershipEndDate.value =
              (mProfileResponse.data?.membershipEndDate ?? "").isEmpty
              ? ""
              : (mProfileResponse.data?.membershipEndDate ?? "");
          if (membershipEndDate.value.isEmpty) {
            membershipStatus.value = false;
          } else {
            await SharedPrefs().setUserDetails(
              jsonEncode(mProfileResponse.data),
            );

            if (dateCompare(membershipEndDate.value)) {
              photo.value =
                  (mProfileResponse.data?.userAttachments ?? []).isEmpty
                  ? ""
                  : (mProfileResponse.data?.userAttachments?.first.fileUrl ??
                        "");

              MembershipTypeData? matchingMembership = membershipList
                  .firstWhereOrNull(
                    (membership) =>
                        membership.id ==
                        mProfileResponse.data!.membershipTypeID,
                  );

              if (matchingMembership != null) {
                membershipType.value = matchingMembership.type ?? '';
              } else {
                membershipType.value = 'No Type';
              }
              userName.value = (mProfileResponse.data?.name ?? "");
              spouseName.value = (mProfileResponse.data?.pocFirstName ?? "");
              membershipId.value = (mProfileResponse.data?.membershipId ?? "");
              membershipStatus.value = true;
            }
          }
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  bool dateCompare(String endDate) {
    DateTime today = DateTime.now();
    String sToday =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    DateTime dt1 = DateTime.parse(endDate);
    DateTime dt2 = DateTime.parse(sToday);
    if (dt1.compareTo(dt2) == 0) {
      return true;
    }
    if (dt1.compareTo(dt2) > 0) {
      return true;
    }

    return false;
  }

  checkEventAppliedStatus(EventModule mEventModule) async {
    RegistrationUser mRegistrationUser = await SharedPrefs().getUserDetails();
    String? mMembershipID = mRegistrationUser.membershipId ?? "";

    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        QrDetailsRequest mQrDetailsRequest = QrDetailsRequest(
          eventId: (mEventModule.id ?? 0).toString(),
          membershipId: mMembershipID,
        );

        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postQrDetails(mQrDetailsRequest);

        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          QrDetailsResponse mQrDetailsResponse = mWebResponseSuccess.data;
          if (mQrDetailsResponse.statusCode == WebConstants.statusCode200) {
            bool isStatusPresent = false;

            if (mQrDetailsResponse.data?.response?.status != null) {
              isStatusPresent = mQrDetailsResponse.data!.response!.status == 1;
            }

            if (isStatusPresent) {
              QrDetailsRequest mQrDetails = QrDetailsRequest(
                eventId: mEventModule.id.toString(),
                membershipId: mMembershipID,
              );
              Get.offAllNamed(AppRoutes.qrScreen, arguments: mQrDetails);
            } else {
              Get.toNamed(
                AppRoutes.eventDetailOneScreen,
                arguments: mEventModule,
              );
            }
          } else {
            AppAlert.showSnackBar(
              Get.context!,
              mQrDetailsResponse.statusMessage ?? "",
            );
          }
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  void webView(String url) async {
    final Uri _url = Uri.parse(url);
    await launchUrl(_url);
  }
}
