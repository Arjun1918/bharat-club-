import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/common/constant/web_constant.dart';
import 'package:organization/data/local/shared_prefs/shared_prefs.dart';
import 'package:organization/lang/translation_service_key.dart';
import 'package:organization/utils/app_util.dart';
import 'package:organization/utils/message_constants.dart';
import 'package:organization/utils/network_util.dart';
import '../../../alert/app_alert.dart';
import '../../../data/mode/registration/registration_request.dart';
import '../../../data/mode/registration/registration_response.dart';
import '../../../data/remote/api_call/api_impl.dart';
import '../../../data/remote/web_response.dart';

class LoginScreenController extends GetxController {
  late final TextEditingController mEmailController;
  late final TextEditingController mPasswordController;
  RxBool emailValidator = false.obs;
  Rx<IconData> suffixIcon = Icons.visibility_off.obs;
  RxBool passwordValidator = false.obs;
  RxBool hidePassword = true.obs;
  RxString seEmailValidator = (sEmailError.tr).obs;
  RxString sePasswordValidator = (sPasswordError.tr).obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    mEmailController = TextEditingController();
    mPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    try {
      mEmailController.dispose();
      mPasswordController.dispose();
    } catch (e) {
      print('Error disposing controllers: $e');
    }
    super.onClose();
  }

  isCheck() {
    setValidator();
    if (mEmailController.text.isEmpty) {
      seEmailValidator.value = (sEmailError.tr);
      emailValidator.value = true;
    } else if (AppUtils.isValidEmail(mEmailController.text)) {
      seEmailValidator.value = sEmailErrorValid.tr;
      emailValidator.value = true;
    } else if (mPasswordController.text.isEmpty) {
      sePasswordValidator.value = (sPasswordError.tr);
      passwordValidator.value = true;
    } else if (mPasswordController.text.length < 6) {
      sePasswordValidator.value = (sPasswordErrorValid.tr);
      passwordValidator.value = true;
    } else {
      validateUserLogin();
    }
  }

  setValidator() {
    emailValidator.value = false;
    passwordValidator.value = false;
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

  void setIndonesianEnglish(String sValue) {
    if (sValue == sIndonesian.tr) {
      var locale = const Locale('id', 'ID');
      Get.updateLocale(locale);
    } else if (sValue == sEnglish.tr) {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
    }
  }

  bool getLanguage(String sValue) {
    var getLocale = Get.locale;
    if (sValue == sIndonesian.tr) {
      var locale = const Locale('id', 'ID');
      if (locale == getLocale) {
        return true;
      }
      return false;
    } else if (sValue == sEnglish.tr) {
      var locale = const Locale('en', 'US');
      if (locale == getLocale) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  String errorMessage = "";

  void validateUserLogin() async {
    // Show loading
    isLoading.value = true;
    await loginApi(RegistrationRequestType.NORMAL_LOGIN.name);
  }

  loginApi(String type) async {
    try {
      NetworkUtils()
          .checkInternetConnection()
          .then((isInternetAvailable) async {
            if (isInternetAvailable) {
              try {
                RegistrationRequest mRegistrationRequest = RegistrationRequest(
                  email: mEmailController.text,
                  password: mPasswordController.text,
                  name: "",
                  profile: "",
                  mobile: "",
                  type: "",
                );

                WebResponseSuccess mWebResponseSuccess = await AllApiImpl()
                    .postLogin(mRegistrationRequest);

                // Hide loading after API response
                isLoading.value = false;

                if (mWebResponseSuccess.statusCode ==
                    WebConstants.statusCode200) {
                  RegistrationResponse mRegistrationResponse =
                      mWebResponseSuccess.data;
                  await SharedPrefs().setUserToken(
                    mRegistrationResponse.data?.token ?? "",
                  );
                  await SharedPrefs().setUserLoginStatus(
                    (mRegistrationResponse.data?.user?.loginStatus ?? 0)
                        .toString(),
                  );
                  await SharedPrefs().setUserDetails(
                    jsonEncode(mRegistrationResponse.data!.user),
                  );
                  if (mRegistrationResponse.data!.user != null) {
                    if ((mRegistrationResponse.data?.user?.loginStatus ?? 0) ==
                        0) {
                      Get.toNamed(AppRoutes.changePassword);
                    } else {
                      mEmailController.text = "";
                      mPasswordController.text = "";
                      Get.delete<LoginScreenController>();
                      Get.offNamed(AppRoutes.home);
                    }
                  } else {
                    AppAlert.showSnackBar(
                      Get.context!,
                      'Please enter the valid user id and password',
                    );
                  }
                } else {
                  // Handle non-200 status codes
                  AppAlert.showSnackBar(
                    Get.context!,
                    'Invalid credentials. Please try again.',
                  );
                }
              } catch (e) {
                // Hide loading on error
                isLoading.value = false;
                AppAlert.showSnackBar(
                  Get.context!,
                  'Login failed. Please try again.',
                );
                print('Login API Error: $e');
              }
            } else {
              // Hide loading when no internet
              isLoading.value = false;
              AppAlert.showSnackBar(
                Get.context!,
                MessageConstants.noInternetConnection,
              );
            }
          })
          .catchError((error) {
            // Hide loading on connection check error
            isLoading.value = false;
            AppAlert.showSnackBar(
              Get.context!,
              'Connection error. Please try again.',
            );
            print('Connection Error: $error');
          });
    } catch (e) {
      // Hide loading on any unexpected error
      isLoading.value = false;
      AppAlert.showSnackBar(
        Get.context!,
        'An error occurred. Please try again.',
      );
      print('Unexpected Error: $e');
    }
  }
}
