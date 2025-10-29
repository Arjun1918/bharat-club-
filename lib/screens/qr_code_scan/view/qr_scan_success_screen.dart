import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/common/widgets/text_input.dart';
import '../../../data/mode/event_qr_scan/qr_details_response.dart';
import 'package:organization/app_theme/theme/app_theme.dart';

import '../controller/qr_scan_success_controller.dart';

class QrScanSuccessScreen extends GetView<QrScanSuccessController> {
  final QrDetailsResponseDetails mqQrDetailResponse;

  const QrScanSuccessScreen({super.key, required this.mqQrDetailResponse});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QrScanSuccessController(mqQrDetailResponse));

    return FocusDetector(
      onVisibilityLost: () {
        Get.delete<QrScanSuccessController>();
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Participant'),
        body: Container(
          height: 0.85.sh,
          width: 1.sw,
          padding: EdgeInsets.all(13.h),
          margin: EdgeInsets.all(13.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: _buildDetailsSection(),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Primary Person Contact Details",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            _buildDetailRow("Primary Name", controller.participantName.value),
            _buildDetailRow("Membership ID", controller.memberShipID.value),

            Divider(height: 20.h, color: Colors.grey),

            Text(
              "Adult Member Details",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            _buildDetailRow(
              "Number of Adult Members",
              controller.memberNoOfAdults.value.toString(),
            ),

            Divider(height: 20.h, color: Colors.grey),

            Text(
              "Children Details",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            _buildDetailRow(
              "Number of Children (Age 12 and above)",
              controller.memberNoOfChild.value.toString(),
            ),
            _buildDetailRow(
              "Number of Children (Age 6 and below)",
              controller.memberNoOfChildFree.value.toString(),
            ),

            Divider(height: 20.h, color: Colors.grey),

            Text(
              "Guest Details",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            _buildDetailRow(
              "Number of Adult Guests",
              controller.guestNoOfAdults.value.toString(),
            ),
            _buildDetailRow(
              "Number of Children (Age 12 and above)",
              controller.guestNoOfChild.value.toString(),
            ),
            _buildDetailRow(
              "Number of Children (Age 6 and below)",
              controller.guestNoOfChildFree.value.toString(),
            ),

            Divider(height: 20.h, color: Colors.grey),

            Text(
              "Attendance",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),

            // Adult Attended
            _buildTextField(
              "Adult Attended",
              controller.adultAttendedController,
            ),

            // Child Attended
            controller.memberChildStatus.value == 1
                ? _buildTextField(
                    "Child Attended",
                    controller.childAttendedController,
                  )
                : const SizedBox.shrink(),

            // Guest Attended
            _buildTextField(
              "Guest Attended",
              controller.guestAttendedController,
            ),

            // Guest Child Attended
            controller.guestChildStatus.value == 1
                ? _buildTextField(
                    "Guest Child Attended",
                    controller.guestChildAttendedController,
                  )
                : const SizedBox.shrink(),

            Divider(height: 20.h, color: Colors.grey),

            Text(
              "Remarks (Optional)",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            _buildRemarksTextField(),
            SizedBox(height: 20.h),

            Center(
              child: SizedBox(
                width: double.infinity, // ✅ full width button
                child: ElevatedButton(
                  onPressed: () {
                    controller.validateAndSubmitAttendance();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryGreen,
                    elevation: 4,
                    shadowColor: AppColors.secondaryGreen.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white, // ✅ white text
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextInputWidget(
        placeHolder: "Enter Remarks",
        hintText: "Write any additional remarks...",
        controller: controller.remarksController,
        errorText: null,
        textInputType: TextInputType.text,
        maxLines: 4,
        maxCharLength: 250,
        borderColor: AppColors.cAppColors.shade500,
        hintTextColor: AppColors.cAppColors.shade400,
        labelTextColor: AppColors.cAppColors.shade700,
        onTextChange: (value) {
          controller.remarksController.text = value;
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextInputWidget(
        placeHolder: label,
        hintText: "Enter $label",
        controller: textController,
        errorText: null,
        textInputType: TextInputType.number,
        onFilteringTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
        borderColor: AppColors.cAppColors.shade500,
        hintTextColor: AppColors.cAppColors.shade400,
        labelTextColor: AppColors.cAppColors.shade700,
        maxLines: 1,
        onTextChange: (value) {},
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.label_important,
                  color: Colors.blueAccent,
                  size: 16.w,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Flexible(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
