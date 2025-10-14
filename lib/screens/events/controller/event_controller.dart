import 'package:get/get.dart';
import 'package:organization/common/constant/web_constant.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/network_util.dart';
import '../../../../data/remote/web_response.dart';
import '../../../alert/app_alert.dart';
import '../../../data/local/shared_prefs/shared_prefs.dart';
import '../../../data/mode/cms_page/cms_page_request.dart';
import '../../../data/mode/cms_page/event_response.dart';
import '../../../data/mode/event_qr_scan/qr_details_request.dart';
import '../../../data/mode/event_qr_scan/qr_details_response.dart';
import '../../../data/mode/registration/registration_response.dart';
import '../../../data/remote/api_call/api_impl.dart';

class EventController extends GetxController {
  /// Observables
  var intEventCount = 0.obs;
  var sEventBannerImage = "".obs;
  var sEventTitle = "".obs;
  var sEventDec = "".obs;
  var isLoading = false.obs;
  var hasLoadedOnce = false.obs;
  var mEventList = <EventModule>[].obs;
  @override
  void onInit() {
    super.onInit();
    _initEventData(); 
  }

  Future<void> _initEventData() async {
    bool isConnected = await NetworkUtils().checkInternetConnection();
    if (isConnected) {
      await getEventUsApi();
      hasLoadedOnce.value = true;
    } else {
      AppAlert.showSnackBar(Get.context!, MessageConstants.noInternetConnection);
    }
  }

  Future<void> getEventUsApi() async {
    try {
      isLoading.value = true;

      CmsPageRequest mCmsPageRequest = CmsPageRequest(
        name: CmsPageRequestType.EVENTS.name,
      );

      WebResponseSuccess mWebResponseSuccess =
          await AllApiImpl().postCmsPage(mCmsPageRequest);

      if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
        EventResponse mEventResponse = mWebResponseSuccess.data;

        sEventTitle.value = mEventResponse.data?.title ??
            "Every year, the club organizes a variety of programs and activities that encourage maximum participation by the members, especially the children.";

        sEventDec.value = mEventResponse.data?.content ?? "";

        if ((mEventResponse.data?.cmsPageAttachments ?? []).isNotEmpty &&
            (mEventResponse.data?.cmsPageAttachments?.first.fileUrl ?? "")
                .isNotEmpty) {
          sEventBannerImage.value =
              mEventResponse.data?.cmsPageAttachments?.first.fileUrl ?? "";
        }

        mEventList.value = mEventResponse.data?.module ?? [];
        intEventCount.value = mEventList.length;
      } else {
        AppAlert.showSnackBar(Get.context!, "Failed to fetch events");
      }
    } catch (e) {
      AppAlert.showSnackBar(Get.context!, "Something went wrong: $e");
    } finally {
      isLoading.value = false; 
    }
  }
  Future<void> checkEventAppliedStatus(EventModule mEventModule) async {
    RegistrationUser mRegistrationUser = await SharedPrefs().getUserDetails();
    String? mMembershipID = mRegistrationUser.membershipId ?? "";

    bool isConnected = await NetworkUtils().checkInternetConnection();
    if (!isConnected) {
      AppAlert.showSnackBar(Get.context!, MessageConstants.noInternetConnection);
      return;
    }

    QrDetailsRequest mQrDetailsRequest = QrDetailsRequest(
      eventId: (mEventModule.id ?? 0).toString(),
      membershipId: mMembershipID,
    );

    WebResponseSuccess mWebResponseSuccess =
        await AllApiImpl().postQrDetails(mQrDetailsRequest);

    if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
      QrDetailsResponse mQrDetailsResponse = mWebResponseSuccess.data;

      if (mQrDetailsResponse.statusCode == WebConstants.statusCode200) {
        bool isStatusPresent =
            mQrDetailsResponse.data?.response?.status == 1;

        if (isStatusPresent) {
          // QrDetailsRequest mQrDetails = QrDetailsRequest(
          //   eventId: mEventModule.id.toString(),
          //   membershipId: mMembershipID,
          // );
          // Get.toNamed(AppRoutes.rQrCodeGenerateScreen, arguments: mQrDetails);
        } else {
          AppAlert.showSnackBar(Get.context!, "Status not valid.");
        }
      } else {
        AppAlert.showSnackBar(
            Get.context!, mQrDetailsResponse.statusMessage ?? "");
      }
    }
  }
}