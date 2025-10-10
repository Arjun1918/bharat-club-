import 'package:get/get.dart';
import 'package:organization/api/api_call/api_impl.dart';
import 'package:organization/api/web_response.dart';
import 'package:organization/common/constant/web_constant.dart';
import 'package:organization/data/mode/cms_page/cms_page_request.dart';
import 'package:organization/screens/gallery/model/gallery_model.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryController extends GetxController {
  var intGalleryCount = 0.obs;
  var sGalleryBannerImage = "".obs;
  var sGalleryTitle = "".obs;
  var sGalleryDec = "".obs;
  RxList mGalleryList = [].obs;

  @override
  void onInit() {
    super.onInit();
  }

  getGalleryUsApi() async {
    try {
      
      CmsPageRequest mCmsPageRequest = CmsPageRequest(
        name: CmsPageRequestType.GALLERY.name,
      );      
      WebResponseSuccess mWebResponseSuccess = await AllApiImpl().postCmsPage(
        mCmsPageRequest,
      );
      
      
      if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
        print("===== Status Code 200 - Processing Data =====");
        
        GalleryResponse mGalleryResponse = mWebResponseSuccess.data;
        
        print("Gallery Response Data: ${mGalleryResponse.data}");
        print("Gallery Module Count: ${mGalleryResponse.data?.module?.length ?? 0}");
        
        mGalleryList.clear();
        mGalleryList.addAll(mGalleryResponse.data?.module ?? []);
        intGalleryCount.value = mGalleryList.length;
        
        print("Updated Gallery List Length: ${mGalleryList.length}");
        print("Updated Gallery Count: ${intGalleryCount.value}");

        // Banner
        if ((mGalleryResponse.data?.cmsPageAttachments ?? []).isNotEmpty &&
            (mGalleryResponse.data?.cmsPageAttachments?.first.fileUrl ?? "")
                .isNotEmpty) {
          sGalleryBannerImage.value =
              (mGalleryResponse.data?.cmsPageAttachments?.first.fileUrl ?? "");
          print("Banner Image URL: ${sGalleryBannerImage.value}");
        } else {
          print("No Banner Image Found");
        }

        sGalleryTitle.value = mGalleryResponse.data?.title ?? "Gallery";
        sGalleryDec.value = mGalleryResponse.data?.content ?? "MOMENTS FOREVER";
        
        print("Gallery Title: ${sGalleryTitle.value}");
        print("Gallery Description: ${sGalleryDec.value}");
        
        // Print each gallery item
        for (int i = 0; i < mGalleryList.length; i++) {
          print("Gallery Item $i:");
          print("  - FileUrl: ${mGalleryList[i].fileUrl}");
          print("  - VideoUrl: ${mGalleryList[i].videoUrl}");
        }
        
        print("===== getGalleryUsApi Completed Successfully =====");
      } else {
        print("===== API Failed with Status Code: ${mWebResponseSuccess.statusCode} =====");
        print("Status Message: ${mWebResponseSuccess.statusMessage}");
      }
    } catch (e, stackTrace) {
      print("===== ERROR in getGalleryUsApi =====");
      print("Error: $e");
      print("StackTrace: $stackTrace");
    }
  }

  void webView(String url) async {
    try {
      print("Opening URL: $url");
      final Uri _url = Uri.parse(url);
      bool launched = await launchUrl(_url);
      print("URL Launch Success: $launched");
    } catch (e) {
      print("Error launching URL: $e");
    }
  }
}