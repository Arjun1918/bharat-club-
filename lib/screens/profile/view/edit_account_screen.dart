import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/utils/app_util_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/text_input.dart';
import 'package:organization/lang/translation_service_key.dart';
import 'package:organization/utils/app_util.dart';
import 'package:organization/utils/color_constants.dart';
import '../controller/profile_controller.dart';

class EditAccountScreen extends GetView<ProfileController> {
  const EditAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.mUserNameController.value.text = controller.userName.value;
    controller.mEmailController.value.text = controller.emailId.value;
    controller.mPhoneNoController.value.text = controller.phoneNumber.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: GestureDetector(
        onTap: () => AppUtils.hideKeyboard(Get.context!),
        child: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                ColorConstants.cAppColors.withOpacity(0.08),
                Colors.grey.shade100,
                Colors.grey.shade50,
                ColorConstants.cAppColors.withOpacity(0.08),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _headerLogo(),
                  SizedBox(height: 16.h),
                  _pageTitle(),
                  SizedBox(height: 25.h),
                  _formContent(),
                  SizedBox(height: 30.h),
                  _updateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerLogo() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      shadowColor: ColorConstants.cAppColors.withOpacity(0.3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          ImageAssetsConstants.goParkingLogoJpg,
          width: 230.w,
          height: 90.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Column(
      children: [
        Text(
          "Edit Account Information",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstants.cAppColors,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "Update your details below",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _formContent() {
    return Obx(() {
      return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        shadowColor: ColorConstants.cAppColors.withOpacity(0.25),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputLabel("Username"),
              SizedBox(height: 6.h),
              TextInputWidget(
                placeHolder: sUserName.tr,
                controller: controller.mUserNameController.value,
                errorText: controller.userNameValidator.isTrue ? sUserNameError.tr : null,
                textInputType: TextInputType.name,
                hintText: sUserNameHint.tr,
                prefixIcon: Icons.account_circle,
                onFilteringTextInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(AppUtilConstants.patternStringAndSpace)),
                ],
              ),
              SizedBox(height: 16.h),

              _inputLabel("Email"),
              SizedBox(height: 6.h),
              TextInputWidget(
                placeHolder: sEmail.tr,
                controller: controller.mEmailController.value,
                isReadOnly: true,
                errorText: controller.emailValidator.isTrue ? controller.seEmailValidator.value : null,
                textInputType: TextInputType.emailAddress,
                hintText: sEmailHint.tr,
                prefixIcon: Icons.email_rounded,
              ),
              SizedBox(height: 16.h),

              _inputLabel("Phone Number"),
              SizedBox(height: 6.h),
              TextInputWidget(
                placeHolder: sPhoneNumber.tr,
                controller: controller.mPhoneNoController.value,
                errorText: controller.phoneNumberValidator.isTrue
                    ? controller.sePhoneNumberValidator.value
                    : null,
                textInputType: TextInputType.phone,
                hintText: sPhoneNumberHint.tr,
                prefixIcon: Icons.phone_android_rounded,
                onFilteringTextInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(AppUtilConstants.patternOnlyNumber)),
                ],
                maxCharLength: 11,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _inputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _updateButton() {
    return SizedBox(
      height: 55.h,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save_rounded, color: Colors.white),
        label: Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        onPressed: () => controller.isEditProfileCheck(),
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: ColorConstants.cAppColors,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
