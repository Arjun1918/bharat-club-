import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/text_input.dart';
import 'package:organization/utils/app_util.dart';
import 'package:organization/utils/color_constants.dart';
import '../controller/profile_controller.dart';

class EditProfileInformationScreen extends StatelessWidget {
  final ProfileController controller = Get.find();
  

  EditProfileInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _fullView());
  }

  Widget _fullView() {
    return GestureDetector(
      onTap: () => AppUtils.hideKeyboard(Get.context!),
      child: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              ColorConstants.cAppColors,
              Colors.grey.shade100,
              Colors.grey.shade100,
              ColorConstants.cAppColors,
            ],
          ),
        ),
        child: Column(
          children: [
            const CustomAppBar(title: 'Edit Profile Information'),
            SizedBox(height: 15.h),
            Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    ImageAssetsConstants.goParkingLogoJpg,
                    height: 65.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(child: _profileFormView()),
          ],
        ),
      ),
    );
  }

  Widget _profileFormView() {
    return Obx(() {
      return Card(
        color: Colors.grey.shade100,
        margin: EdgeInsets.all(15.w),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 0.5.sh,
            maxHeight: 0.8.sh,
          ),
          padding: EdgeInsets.all(15.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 13.h),

                /// Company Name
                TextInputWidget(
                  placeHolder: "Company Name",
                  controller: controller.mUserNameController.value,
                  errorText: controller.userNameValidator.isTrue
                      ? "Please enter the Company Name"
                      : null,
                  textInputType: TextInputType.name,
                  hintText: "Enter the Company Name",
                  showFloatingLabel: true,
                  prefixIcon: Icons.drive_file_rename_outline,
                ),
                SizedBox(
                    height: controller.userNameValidator.isTrue ? 8.h : 31.h),

                /// Designation
                TextInputWidget(
                  placeHolder: "Designation",
                  controller: controller.mDesignationController.value,
                  errorText: controller.designationValidator.isTrue
                      ? "Please enter your designation"
                      : null,
                  textInputType: TextInputType.name,
                  hintText: "Enter your designation",
                  showFloatingLabel: true,
                  prefixIcon: Icons.description_outlined,
                ),
                SizedBox(
                    height: controller.phoneNumberValidator.isTrue ? 8.h : 31.h),

                /// Location
                TextInputWidget(
                  placeHolder: "Location",
                  controller: controller.mEmailController.value,
                  errorText: controller.emailValidator.isTrue
                      ? "Please enter the location"
                      : null,
                  textInputType: TextInputType.text,
                  hintText: "Enter the location",
                  showFloatingLabel: true,
                  prefixIcon: Icons.location_on_outlined,
                ),
                SizedBox(
                    height: controller.emailValidator.isTrue ? 8.h : 31.h),

                /// Company Website
                TextInputWidget(
                  placeHolder: "Company Website",
                  controller: controller.mPhoneNoController.value,
                  errorText: controller.phoneNumberValidator.isTrue
                      ? "Please enter the Company Website"
                      : null,
                  textInputType: TextInputType.url,
                  hintText: "Enter the Company Website",
                  showFloatingLabel: true,
                  prefixIcon: Icons.web,
                ),
                SizedBox(
                    height: controller.phoneNumberValidator.isTrue ? 8.h : 31.h),

                /// Linkedin URL
                TextInputWidget(
                  placeHolder: "LinkedIn URL",
                  controller: controller.mLinkedinController.value,
                  errorText: controller.phoneNumberValidator.isTrue
                      ? "Please enter the LinkedIn URL"
                      : null,
                  textInputType: TextInputType.url,
                  hintText: "Enter the LinkedIn URL",
                  showFloatingLabel: true,
                  prefixIcon: Icons.link,
                ),

                SizedBox(height: 31.h),

                /// Update Profile Button (Normal Button)
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.cAppColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    onPressed: () {
                      controller.isProfileInformationCheck();
                    },
                    child: const Text(
                      "Update Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
