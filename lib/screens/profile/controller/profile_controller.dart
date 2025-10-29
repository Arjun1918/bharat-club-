import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/constant/web_constant.dart';
import 'package:organization/utils/app_util.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/network_util.dart';
import '../../../alert/alert_action.dart';
import '../../../alert/app_alert.dart';

import '../../../data/local/shared_prefs/shared_prefs.dart';
import '../../../data/mode/forgot_password/forgot_password_delete_request.dart';
import '../../../data/mode/forgot_password/forgot_password_delete_response.dart';
import '../../../data/mode/membership_type/membership_type_response.dart';
import '../../../data/mode/profile_pic/profile_pic_response.dart';
import '../../../data/mode/profile_response/profile_response.dart';
import '../../../data/mode/profile_response/profile_update_request.dart';
import '../../../data/mode/registration/registration_response.dart';
import '../../../data/remote/api_call/api_impl.dart';
import '../../../data/remote/web_response.dart';
import '../../../lang/translation_service_key.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProfileController extends GetxController {
  ///Controller
  final Rx<TextEditingController> mUserNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> mEmailController =
      TextEditingController().obs;
  final Rx<TextEditingController> mOldPasswordController =
      TextEditingController().obs;
  final Rx<TextEditingController> mPasswordController =
      TextEditingController().obs;
  final Rx<TextEditingController> mConfirmPasswordController =
      TextEditingController().obs;
  final Rx<TextEditingController> mPhoneNoController =
      TextEditingController().obs;
  final Rx<TextEditingController> mDesignationController =
      TextEditingController().obs;
  final Rx<TextEditingController> mLinkedinController =
      TextEditingController().obs;

  ///value
  RxBool membershipStatus = false.obs;
  RxString membershipEndDate = "".obs;
  RxString membershipType = "".obs;
  RxString userName = "".obs;
  RxString emailId = "".obs;
  RxString phoneNumber = "".obs;

  RxString pocFirstName = "".obs;
  RxString pocEmailId = "".obs;
  RxString pocPhoneNumber = "".obs;

  RxString child1 = "".obs;
  RxString child2 = "".obs;
  RxString child3 = "".obs;
  RxString child4 = "".obs;

  RxString companyName = "".obs;
  RxString designation = "".obs;
  RxString companyLocation = "".obs;
  RxString companyWebSite = "".obs;
  RxString companyLinkedin = "".obs;

  RxString photo = "".obs;

  ///Validator
  RxBool userNameValidator = false.obs;
  RxBool emailValidator = false.obs;
  RxBool passwordOldValidator = false.obs;
  RxBool passwordValidator = false.obs;
  RxBool confirmPasswordValidator = false.obs;
  RxBool phoneNumberValidator = false.obs;
  RxBool phoneNumberCheckboxValidator = false.obs;
  RxBool personOfContactCheckboxValidator = false.obs;
  RxBool profileInformationCheckboxValidator = false.obs;
  RxBool linkedinWeb = false.obs;
  RxBool addressValidator = false.obs;
  RxBool designationValidator = false.obs;

  ///
  RxBool hideOldPassword = true.obs;
  Rx<IconData> suffixOldPasswordIcon = Icons.visibility_off.obs;

  ///
  RxBool hidePassword = true.obs;
  Rx<IconData> suffixIcon = Icons.visibility_off.obs;

  ///
  RxBool hideConfirmPassword = true.obs;
  Rx<IconData> suffixConfirmPasswordIcon = Icons.visibility_off.obs;

  ///
  RxString seEmailValidator = (sEmailError.tr).obs;
  RxString seConfirmPasswordValidator = (sConfirmPasswordError.tr).obs;
  RxString sePhoneNumberValidator = (sPhoneNumberError.tr).obs;
  RxString seOccupationValidator = (sOccupationError.tr).obs;

  isEditProfileCheck() {
    setValidator();
    if (mUserNameController.value.text.isEmpty) {
      userNameValidator.value = true;
    } else if (mEmailController.value.text.isEmpty) {
      emailValidator.value = true;
    } else if (AppUtils.isValidEmail(mEmailController.value.text)) {
      seEmailValidator.value = sEmailErrorValid.tr;
      emailValidator.value = true;
    } else if (mPhoneNoController.value.text.isEmpty) {
      phoneNumberValidator.value = true;
    } else if (AppUtils.isValidPhone(mPhoneNoController.value.text)) {
      sePhoneNumberValidator.value = (sPhoneNumberErrorValid.tr);
      phoneNumberValidator.value = true;
    } else {
      updateProfileApi();
    }
  }

  isPersonOfContactCheck() {
    setValidator();
    if (mUserNameController.value.text.isEmpty) {
      userNameValidator.value = true;
    } else if (mEmailController.value.text.isEmpty) {
      emailValidator.value = true;
    } else if (AppUtils.isValidEmail(mEmailController.value.text)) {
      seEmailValidator.value = sEmailErrorValid.tr;
      emailValidator.value = true;
    } else if (mPhoneNoController.value.text.isEmpty) {
      phoneNumberValidator.value = true;
    } else if (AppUtils.isValidPhone(mPhoneNoController.value.text)) {
      sePhoneNumberValidator.value = (sPhoneNumberErrorValid.tr);
      phoneNumberValidator.value = true;
    } else {
      personOfContactApi();
    }
  }

  isProfileInformationCheck() {
    setValidator();
    if (mUserNameController.value.text.isEmpty) {
      userNameValidator.value = true;
    } else if (mDesignationController.value.text.isEmpty) {
      designationValidator.value = true;
    } else {
      profileInformationApi();
    }
  }

  isChangePasswordCheck() {
    setValidator();
    if (mOldPasswordController.value.text.isEmpty) {
      passwordOldValidator.value = true;
    } else if (mPasswordController.value.text.isEmpty) {
      passwordValidator.value = true;
    } else if (mConfirmPasswordController.value.text.isEmpty) {
      confirmPasswordValidator.value = true;
    } else if (mConfirmPasswordController.value.text !=
        mPasswordController.value.text) {
      seConfirmPasswordValidator.value = (sConfirmPasswordErrorValid.tr);
      confirmPasswordValidator.value = true;
    } else {
      Get.back();
    }
  }

  setValidator() {
    seEmailValidator.value = (sEmailError.tr);
    seConfirmPasswordValidator.value = (sConfirmPasswordError.tr);
    sePhoneNumberValidator.value = (sPhoneNumberError.tr);
    userNameValidator.value = false;
    emailValidator.value = false;
    passwordOldValidator.value = false;
    passwordValidator.value = false;
    confirmPasswordValidator.value = false;
    phoneNumberValidator.value = false;
    designationValidator.value = false;
  }

  showOldPassword() {
    if (hideOldPassword.value) {
      hideOldPassword.value = false;
      suffixOldPasswordIcon.value = Icons.visibility;
    } else {
      hideOldPassword.value = true;
      suffixOldPasswordIcon.value = Icons.visibility_off;
    }
  }

  showPassword() {
    if (hidePassword.value) {
      hidePassword.value = false;
      suffixIcon.value = Icons.visibility;
    } else {
      hidePassword.value = true;
      suffixIcon.value = Icons.visibility_off;
    }
  }

  showConfirmPassword() {
    if (hideConfirmPassword.value) {
      hideConfirmPassword.value = false;
      suffixConfirmPasswordIcon.value = Icons.visibility;
    } else {
      hideConfirmPassword.value = true;
      suffixConfirmPasswordIcon.value = Icons.visibility_off;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  void updateValue() {
    userName.value = mUserNameController.value.text;
    emailId.value = mEmailController.value.text;
    phoneNumber.value = mPhoneNoController.value.text;
    designation.value = mDesignationController.value.text;
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
          await SharedPrefs().setUserToken("");
          await SharedPrefs().setUserDetails(jsonEncode(RegistrationUser()));
          Get.offNamed(AppRoutes.home);
        } else if (mWebResponseSuccess.statusCode ==
            WebConstants.statusCode200) {
          membershipEndDate.value =
              (mProfileResponse.data?.membershipEndDate ?? "").isEmpty
              ? ""
              : (mProfileResponse.data?.membershipEndDate ?? "");
          if (membershipEndDate.value.isEmpty) {
            membershipStatus.value = false;
          } else {
            if (dateCompare(membershipEndDate.value)) {
              membershipStatus.value = true;
            }
          }
          MembershipTypeData? matchingMembership = membershipList
              .firstWhereOrNull(
                (membership) =>
                    membership.id == mProfileResponse.data!.membershipTypeID,
              );
          if (matchingMembership != null) {
            membershipType.value = matchingMembership.type ?? '';
          } else {
            membershipType.value = 'No Type';
          }
          userName.value = (mProfileResponse.data?.name ?? "");
          emailId.value = (mProfileResponse.data?.email ?? "");
          phoneNumber.value = mProfileResponse.data?.mobile ?? "";
          mProfileResponse.data?.isPoc == 0
              ? phoneNumberCheckboxValidator.value = false
              : phoneNumberCheckboxValidator.value = true;
          pocFirstName.value = (mProfileResponse.data?.pocFirstName ?? "");
          pocEmailId.value = (mProfileResponse.data?.pocEmail ?? "");
          pocPhoneNumber.value = mProfileResponse.data?.pocMobile ?? "";
          child1.value = mProfileResponse.data?.childOne ?? "";
          child2.value = mProfileResponse.data?.childTwo ?? "";
          child3.value = mProfileResponse.data?.childThree ?? "";
          child4.value = mProfileResponse.data?.childFour ?? "";
          mProfileResponse.data?.isBasicDetails == 0
              ? personOfContactCheckboxValidator.value = false
              : personOfContactCheckboxValidator.value = true;
          companyName.value = (mProfileResponse.data?.companyName ?? "");
          designation.value = (mProfileResponse.data?.designation ?? "");
          companyLocation.value = (mProfileResponse.data?.location ?? "");
          companyWebSite.value = (mProfileResponse.data?.companyWebsite ?? "");
          companyLinkedin.value = (mProfileResponse.data?.linkedinUrl ?? "");
          mProfileResponse.data?.isProfileInfo == 0
              ? profileInformationCheckboxValidator.value = false
              : profileInformationCheckboxValidator.value = true;
          attachmentPath.value = "";
          photo.value = (mProfileResponse.data?.userAttachments ?? []).isEmpty
              ? ""
              : (mProfileResponse.data?.userAttachments?.first.fileUrl ?? "");
          await SharedPrefs().setUserDetails(jsonEncode(mProfileResponse.data));

          ///
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  basicDetails() {
    print("DEBUG: userName = ${userName.value}");
    print("DEBUG: emailId = ${emailId.value}");
    print("DEBUG: phoneNumber = ${phoneNumber.value}");

    setValidator();
    mUserNameController.value = TextEditingController(text: userName.value);
    mEmailController.value = TextEditingController(text: emailId.value);
    mPhoneNoController.value = TextEditingController(text: phoneNumber.value);

    print("DEBUG: Controller text = ${mUserNameController.value.text}");
  }

  updateProfileApi() async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        ProfileUpdateRequest mProfileUpdateRequest = ProfileUpdateRequest(
          email: mEmailController.value.text,
          name: mUserNameController.value.text,
          mobile: mPhoneNoController.value.text,
          isPoc: phoneNumberCheckboxValidator.value,
        );
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postProfileUpdate(mProfileUpdateRequest);
        print("######${jsonEncode(mWebResponseSuccess.data)}");
        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          Get.back();
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  ///personOfContact
  personOfContactDetails() {
    setValidator();
    mUserNameController.value.text = pocFirstName.value;
    mEmailController.value.text = pocEmailId.value;
    mPhoneNoController.value.text = pocPhoneNumber.value;
    // Get.toNamed(RouteConstants.rEditPersonOfContactScreen);
  }

  personOfContactApi() async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        ProfileUpdateRequest mProfileUpdateRequest = ProfileUpdateRequest(
          name: userName.value,
          email: emailId.value,
          mobile: phoneNumber.value,
          pocEmail: mEmailController.value.text,
          pocFirstName: mUserNameController.value.text,
          pocMobile: mPhoneNoController.value.text,
        );
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postProfileUpdate(mProfileUpdateRequest);
        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          Get.back();
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  ///profile Information
  profileInformationDetails() {
    setValidator();
    mUserNameController.value.text = companyName.value;
    mDesignationController.value.text = designation.value;
    mEmailController.value.text = companyLocation.value;
    mPhoneNoController.value.text = companyWebSite.value;
    mLinkedinController.value.text = companyLinkedin.value;

    // Get.toNamed(RouteConstants.rEditProfileInformationScreen);
  }

  profileInformationApi() async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        ProfileUpdateRequest mProfileUpdateRequest = ProfileUpdateRequest(
          name: userName.value,
          email: emailId.value,
          mobile: phoneNumber.value,
          companyName: mUserNameController.value.text,
          designation: mDesignationController.value.text,
          location: mEmailController.value.text,
          companyWebsite: mPhoneNoController.value.text,
          linkedinUrl: mLinkedinController.value.text,
        );
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
            .postProfileUpdate(mProfileUpdateRequest);
        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          Get.back();
        }
      } else {
        AppAlert.showSnackBar(
          Get.context!,
          MessageConstants.noInternetConnection,
        );
      }
    });
  }

  String fileName = "";
  var attachmentPath = "".obs;
  String sPath = "";

  imagePic() async {
    fileName = "";
    attachmentPath.value = "";
    sPath = "";
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print("file parth ${image.path.toString()}");
      print("file parth ${image.path.split("/").last}");
      fileName = image.name.toString();
      sPath = image.path.toString();
      _cropImage(sPath, fileName);
    }
  }

  _cropImage(String sPath, String sName) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sPath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.cAppColors,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: false),
      ],
    );

    if (croppedFile != null) {
      final file = File(croppedFile.path);
      final bytes = await file.length();
      final kb = bytes / 1024;
      final mb = kb / 1024;

      if (mb > 2.0) {
        final XFile? compressedXFile = await testCompressAndGetFile(file, 5);
        final compressedFile = compressedXFile != null
            ? File(compressedXFile.path)
            : null;

        fileName = compressedFile?.path.split("/").last ?? "";
        attachmentPath.value = compressedFile?.path ?? "";
        picApi(attachmentPath.value);
      } else {
        fileName = file.path.split("/").last;
        attachmentPath.value = file.path;
        picApi(attachmentPath.value);
      }
    }
  }

  Future<XFile?> testCompressAndGetFile(File file, int quality) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        "${dir.absolute.path}/${DateTime.now().toString().replaceAll(" ", "").replaceAll(".", "_").replaceAll(":", "_")}.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );

    // // debugPrint(file.lengthSync().toString());
    // // debugPrint(result?.lengthSync().toString());
    return result;
  }

  picApi(String file) async {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl().postImage(
          file,
        );
        ProfilePicResponse mProfilePicResponse = mWebResponseSuccess.data;
        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          AppAlert.showSnackBar(
            Get.context!,
            mProfilePicResponse.data!.message.toString(),
          );
          await Future.delayed(const Duration(seconds: 1));
          getProfile();
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

  void deleteProfile() {
    AppAlert.showCustomDialogYesNoLogout(
      Get.context!,
      MessageConstants.wDeleteMessage,
      title: 'Delete Profile',
      positiveActionText: 'Delete',
    ).then((value) async {
      if (value == AlertAction.yes) {
        deleteApiCall();
      }
    });
  }

  void deleteApiCall() {
    NetworkUtils().checkInternetConnection().then((isInternetAvailable) async {
      if (isInternetAvailable) {
        ForgotPasswordDeleteRequest mForgotPasswordDeleteRequest =
            ForgotPasswordDeleteRequest(email: emailId.value);
        WebResponseSuccess mWebResponseSuccess = await AllApiImpl().postDelete(
          mForgotPasswordDeleteRequest,
        );
        if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
          ForgotPasswordDeleteResponse mForgotPasswordDeleteResponse =
              mWebResponseSuccess.data;
          if (mForgotPasswordDeleteResponse.statusCode ==
              WebConstants.statusCode200) {
            AppAlert.showSnackBar(
              Get.context!,
              mForgotPasswordDeleteResponse.data?.message ?? "",
            );

            await SharedPrefs().setUserLoginStatus("0");
            await SharedPrefs().setUserToken("");
            await SharedPrefs().setUserDetails(jsonEncode(RegistrationUser()));
            Get.offNamed(AppRoutes.loginScreen);
          } else {
            AppAlert.showSnackBar(
              Get.context!,
              mForgotPasswordDeleteResponse.data?.message ?? "",
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
}
