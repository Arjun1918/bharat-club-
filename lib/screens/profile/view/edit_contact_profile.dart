import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/constant/image_constants.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/text_input.dart';
import 'package:organization/lang/translation_service_key.dart';
import 'package:organization/utils/app_util.dart';
import 'package:organization/utils/app_util_constants.dart';
import '../controller/profile_controller.dart';

class EditPersonOfContactScreen extends StatelessWidget {
  final ProfileController controller = Get.find();

  EditPersonOfContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeControllers();
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
              const CustomAppBar(title: 'Person Of Contact'),
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

  void _initializeControllers() {
    controller.mUserNameController.value.text = controller.pocFirstName.value;
    controller.mEmailController.value.text = controller.pocEmailId.value;
    controller.mPhoneNoController.value.text = controller.pocPhoneNumber.value;
    controller.setValidator();
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
                  'Person of Contact',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Update contact person details',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
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
            _buildSectionTitle('Contact Information'),
            SizedBox(height: 16.h),

            /// Name
            _buildInputField(
              label: 'Name',
              controller: controller.mUserNameController.value,
              errorText: controller.userNameValidator.isTrue
                  ? "Please enter the name"
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
              keyboardType: TextInputType.number,
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
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
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
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
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade600,
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
        onPressed: () => controller.isPersonOfContactCheck(),
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}