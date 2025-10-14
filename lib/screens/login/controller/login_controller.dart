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

  Future<void> loginApi(String type) async {
    try {
      // Check internet connection
      bool isInternetAvailable = await NetworkUtils().checkInternetConnection();
      
      if (!isInternetAvailable) {
        isLoading.value = false;
        _showError(MessageConstants.noInternetConnection);
        return;
      }

      // Create login request
      RegistrationRequest mRegistrationRequest = RegistrationRequest(
          email: mEmailController.text.trim(),
          password: mPasswordController.text.trim(),
          name: "",
          profile: "",
          mobile: "",
          type: type);

      print('Making login API call...');

      // Make API call
      WebResponseSuccess mWebResponseSuccess =
          await AllApiImpl().postLogin(mRegistrationRequest);

      print('API call completed with status: ${mWebResponseSuccess.statusCode}');

      // Check status code
      if (mWebResponseSuccess.statusCode == WebConstants.statusCode200) {
        await _handleSuccessfulLogin(mWebResponseSuccess);
      } else {
        isLoading.value = false;
        _showError(mWebResponseSuccess.statusMessage ?? 'Login failed');
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      isLoading.value = false;
      _showError('An error occurred. Please try again.');
    }
  }

  Future<void> _handleSuccessfulLogin(WebResponseSuccess mWebResponseSuccess) async {
    try {
      print('Handling successful login...');

      RegistrationResponse mRegistrationResponse = mWebResponseSuccess.data;

      if (mRegistrationResponse.data == null) {
        isLoading.value = false;
        _showError('Invalid response from server');
        return;
      }

      var responseData = mRegistrationResponse.data!;
      var userData = responseData.user;

      if (userData == null) {
        isLoading.value = false;
        _showError('User data not found');
        return;
      }

      print('Saving user data using SharedPrefs...');

      // Initialize shared prefs instance if not already
      await SharedPrefs().sharedPreferencesInstance();

      // Save token
      String token = responseData.token ?? "";
      await SharedPrefs().setUserToken(token);

      // Save login status
      String loginStatus = (userData.loginStatus ?? 1).toString();
      await SharedPrefs().setUserLoginStatus(loginStatus);

      // Save user details as JSON
      try {
        String userJson = jsonEncode(userData.toJson());
        await SharedPrefs().setUserDetails(userJson);
        print('User details saved');
      } catch (jsonError) {
        print('Error encoding user JSON: $jsonError');
      }

      // Clear controllers
      mEmailController.clear();
      mPasswordController.clear();

      // Hide loader
      isLoading.value = false;

      // Decide where to go next
      print('Navigating based on login status: $loginStatus');

      await Future.delayed(const Duration(milliseconds: 300));

      if (loginStatus == "0") {
        print('Navigating to forgot password screen...');
        Get.offNamed(AppRoutes.forgot);
      } else {
        print('Navigating to home screen...');
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e, stackTrace) {
      print('Error in _handleSuccessfulLogin: $e');
      print('Stack trace: $stackTrace');
      isLoading.value = false;
      _showError('Error processing login data');
    }
  }

  void _showError(String message) {
    try {
      if (Get.context != null) {
        AppAlert.showSnackBar(Get.context!, message);
      }
    } catch (e) {
      print('Error showing snackbar: $e');
    }
  }
}