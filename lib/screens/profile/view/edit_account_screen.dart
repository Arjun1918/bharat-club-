import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/app_util_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/text_input.dart';
import 'package:organization/lang/translation_service_key.dart';
import 'package:organization/utils/app_util.dart';
import '../controller/profile_controller.dart';

class EditAccountScreen extends GetView<ProfileController> {
  const EditAccountScreen({super.key});

  // Validation methods
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'Username must be at least 2 characters';
    }

    if (trimmedValue.length > 50) {
      return 'Username is too long';
    }

    // Check if it contains only letters and spaces
    if (!RegExp(
      AppUtilConstants.patternStringAndSpace,
    ).hasMatch(trimmedValue)) {
      return 'Username can only contain letters and spaces';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedValue = value.trim();

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    if (trimmedValue.length < 5) {
      return 'Email is too short';
    }

    if (trimmedValue.length > 254) {
      return 'Email is too long';
    }

    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final trimmedValue = value.trim();

    // Check if it contains only numbers
    if (!RegExp(AppUtilConstants.patternOnlyNumber).hasMatch(trimmedValue)) {
      return 'Phone number can only contain numbers';
    }

    if (trimmedValue.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (trimmedValue.length > 11) {
      return 'Phone number cannot exceed 11 digits';
    }

    return null;
  }

  void _validateAndUpdate() {
    bool hasErrors = false;

    // Validate username
    final usernameError = _validateUsername(
      controller.mUserNameController.value.text,
    );
    if (usernameError != null) {
      controller.userNameValidator.value = true;
      hasErrors = true;
    } else {
      controller.userNameValidator.value = false;
    }

    // Validate email
    final emailError = _validateEmail(controller.mEmailController.value.text);
    if (emailError != null) {
      controller.emailValidator.value = true;
      controller.seEmailValidator.value = emailError;
      hasErrors = true;
    } else {
      controller.emailValidator.value = false;
      controller.seEmailValidator.value = '';
    }

    // Validate phone number
    final phoneError = _validatePhoneNumber(
      controller.mPhoneNoController.value.text,
    );
    if (phoneError != null) {
      controller.phoneNumberValidator.value = true;
      controller.sePhoneNumberValidator.value = phoneError;
      hasErrors = true;
    } else {
      controller.phoneNumberValidator.value = false;
      controller.sePhoneNumberValidator.value = '';
    }

    if (!hasErrors) {
      controller.isEditProfileCheck();
    } else {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.r),
        borderRadius: 12.r,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.mUserNameController.value.text = controller.userName.value;
    controller.mEmailController.value.text = controller.emailId.value;
    controller.mPhoneNoController.value.text = controller.phoneNumber.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => AppUtils.hideKeyboard(Get.context!),
        child: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cAppColors,
                Colors.grey.shade100,
                Colors.grey.shade100,
                AppColors.cAppColors,
              ],
            ),
          ),
          child: Column(
            children: [
              const CustomAppBar(title: 'Edit Profile'),
              SizedBox(height: 20.h),
              _buildProfileHeader(),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _formContent(),
                        SizedBox(height: 30.h),
                        _updateButton(),
                        SizedBox(height: 20.h),
                      ],
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

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.cAppColors.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                ImageAssetsConstants.goParkingLogoJpg,
                height: 50.h,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Settings',
                  style: getTextSemiBold(
                    size: 18.sp,
                    colors: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Update your personal details',
                  style: getTextMedium(
                    size: 13.sp,
                    colors: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formContent() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Information'),
            SizedBox(height: 16.h),

            /// Username
            _buildInputField(
              label: 'Username',
              controller: controller.mUserNameController.value,
              errorText: controller.userNameValidator.isTrue
                  ? _validateUsername(controller.mUserNameController.value.text)
                  : null,
              icon: Icons.person_outline,
              hint: sUserNameHint.tr,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(AppUtilConstants.patternStringAndSpace),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            /// Email
            _buildInputField(
              label: 'Email',
              controller: controller.mEmailController.value,
              errorText: controller.emailValidator.isTrue
                  ? controller.seEmailValidator.value
                  : null,
              icon: Icons.email_outlined,
              hint: sEmailHint.tr,
              keyboardType: TextInputType.emailAddress,
              isReadOnly: true,
            ),
            SizedBox(height: 20.h),

            /// Phone Number
            _buildInputField(
              label: 'Phone Number',
              controller: controller.mPhoneNoController.value,
              errorText: controller.phoneNumberValidator.isTrue
                  ? controller.sePhoneNumberValidator.value
                  : null,
              icon: Icons.phone_outlined,
              hint: sPhoneNumberHint.tr,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(AppUtilConstants.patternOnlyNumber),
                ),
              ],
              maxLength: 11,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.cAppColors,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: getTextSemiBold1(size: 16.sp, colors: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required TextInputType keyboardType,
    String? errorText,
    bool isReadOnly = false,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isReadOnly ? Colors.grey.shade100 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: TextInputWidget(
            placeHolder: label,
            controller: controller,
            errorText: null,
            textInputType: keyboardType,
            hintText: hint,
            showFloatingLabel: true,
            prefixIcon: icon,
            isReadOnly: isReadOnly,
            onFilteringTextInputFormatter: inputFormatters,
            maxCharLength: maxLength,
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14.sp,
                  color: Colors.red.shade600,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    errorText,
                    style: getTextMedium(
                      size: 12.sp,
                      colors: Colors.red.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _updateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cAppColors,
          elevation: 2,
          shadowColor: AppColors.cAppColors.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: _validateAndUpdate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              "Update Profile",
              style: getTextSemiBold1(colors: Colors.white, size: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
