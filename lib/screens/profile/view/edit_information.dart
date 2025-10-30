import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/text_input.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/app_util.dart';
import '../controller/profile_controller.dart';
import 'package:organization/app_theme/theme/app_theme.dart';

class EditProfileInformationScreen extends StatelessWidget {
  final ProfileController controller = Get.find();

  EditProfileInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeControllers();
    return Scaffold(body: _fullView());
  }

  void _initializeControllers() {
    // Initialize all controllers with existing data from the profile
    // Company Name - maps to 'company_name' in API
    controller.mUserNameController.value.text = controller.companyName.value;

    // Designation - maps to 'designation' in API
    controller.mDesignationController.value.text = controller.designation.value;

    // Location - maps to 'location' in API
    controller.mEmailController.value.text = controller.companyLocation.value;

    // Company Website - maps to 'company_website' in API
    controller.mPhoneNoController.value.text = controller.companyWebSite.value;

    // LinkedIn URL - maps to 'linkedin_url' in API
    controller.mLinkedinController.value.text =
        controller.companyLinkedin.value;
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
              AppColors.cAppColors,
              Colors.grey.shade100,
              Colors.grey.shade100,
              AppColors.cAppColors,
            ],
          ),
        ),
        child: Column(
          children: [
            const CustomAppBar(title: 'Edit Profile Information'),
            SizedBox(height: 20.h),
            _buildProfileHeader(),
            SizedBox(height: 20.h),
            Expanded(child: _profileFormView()),
          ],
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
                  'Company Profile',
                  style: getTextSemiBold(
                    size: 18.sp,
                    colors: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Update your organization details',
                  style: getTextRegular(
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

  Widget _profileFormView() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              SizedBox(height: 16.h),

              /// Company Name
              _buildInputField(
                label: 'Company Name',
                controller: controller.mUserNameController.value,
                errorText: controller.userNameValidator.isTrue
                    ? "Please enter the Company Name"
                    : null,
                icon: Icons.business_outlined,
                hint: "Enter the Company Name",
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 20.h),

              /// Designation
              _buildInputField(
                label: 'Designation',
                controller: controller.mDesignationController.value,
                errorText: controller.designationValidator.isTrue
                    ? "Please enter your designation"
                    : null,
                icon: Icons.work_outline,
                hint: "Enter your designation",
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 20.h),

              /// Location
              _buildInputField(
                label: 'Location',
                controller: controller.mEmailController.value,
                errorText: controller.emailValidator.isTrue
                    ? "Please enter the location"
                    : null,
                icon: Icons.location_on_outlined,
                hint: "Enter the location",
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 32.h),

              _buildSectionTitle('Online Presence'),
              SizedBox(height: 16.h),

              /// Company Website
              _buildInputField(
                label: 'Company Website',
                controller: controller.mPhoneNoController.value,
                errorText: controller.phoneNumberValidator.isTrue
                    ? "Please enter the Company Website"
                    : null,
                icon: Icons.language,
                hint: "Enter the Company Website",
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 20.h),

              /// LinkedIn URL
              _buildInputField(
                label: 'LinkedIn URL',
                controller: controller.mLinkedinController.value,
                errorText: controller.phoneNumberValidator.isTrue
                    ? "Please enter the LinkedIn URL"
                    : null,
                icon: Icons.link,
                hint: "Enter the LinkedIn URL",
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 32.h),

              /// Update Profile Button
              SizedBox(
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
                  onPressed: () {
                    controller.isProfileInformationCheck();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Update Profile",
                        style: getTextSemiBold(
                          colors: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
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
          style: getTextSemiBold(size: 16.sp, colors: Colors.grey.shade800),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: errorText != null
                  ? Colors.red.shade300
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: TextInputWidget(
            placeHolder: label,
            controller: controller,
            errorText: null,
            textInputType: keyboardType,
            hintText: hint,
            showFloatingLabel: true,
            prefixIcon: icon,
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 14.sp, color: AppColors.error),
                SizedBox(width: 4.w),
                Text(
                  errorText,
                  style: getTextMedium(size: 12.sp, colors: AppColors.error),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
