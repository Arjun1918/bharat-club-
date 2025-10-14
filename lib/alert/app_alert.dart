import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/common/constant/size_constants.dart';
import 'package:organization/common/widgets/loader.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/color_constants.dart';
import 'package:organization/utils/message_constants.dart';
import 'alert_action.dart';

class AppAlert {
  AppAlert._();

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  static Future<void> showCustomDismissDialog(
    BuildContext context,
    String message, {
    String? title,
    String? dismissButtonText,
    IconData? icon = Icons.info,
    VoidCallback? onDismiss,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConstants.s_8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConstants.width * 0.08,
                    right: SizeConstants.s_14,
                    top: SizeConstants.width * 0.08,
                    bottom: SizeConstants.s_12,
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: Colors.black87,
                          size: SizeConstants.width * 0.06,
                        ),
                        SizedBox(width: SizeConstants.s_12),
                      ],
                      Expanded(
                        child: Text(
                          title ?? "Info",
                          style: getTextSemiBold(
                            colors: Colors.black87,
                            size: SizeConstants.width * 0.045,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConstants.width * 0.08,
                    right: SizeConstants.s_14,
                    bottom: SizeConstants.s_12,
                  ),
                  child: Text(
                    message,
                    style: getTextRegular(
                      colors: Colors.black87,
                      size: SizeConstants.width * 0.04,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    SizeConstants.width * 0.08,
                    SizeConstants.width *
                        0.04,
                    SizeConstants.width * 0.08,
                    SizeConstants.width * 0.08,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height:
                              SizeConstants.width * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (onDismiss != null)
                                onDismiss(); 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade50,
                              side: BorderSide(
                                width: 1.5,
                                color: ColorConstants.cAppColorsBlue,
                              ),
                            ),
                            child: Text(
                              dismissButtonText ?? "Dismiss",
                              style: getTextMedium(
                                colors: ColorConstants.cAppColorsRed,
                                size:
                                    SizeConstants.width *
                                    0.035,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              height: 100,
              width: 100,
              child: CustomLoader(),
            ),
          ),
        );
      },
    );
  }

  static showPro() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.all(SizeConstants.s_16),
        height: 80,
        width: 80,
        child: const CircularProgressIndicator(
          strokeWidth: 6.0,
          color: ColorConstants.cAppColors,
        ),
      ),
    );
  }

  static showProgressDialogMessage(
    BuildContext context, {
    String message = MessageConstants.loading,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Padding(
            padding: EdgeInsets.all(SizeConstants.s_16),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: EdgeInsets.all(SizeConstants.s_16),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(SizeConstants.s_16),
                      child: const CircularProgressIndicator(
                        strokeWidth: 5.0,
                        color: ColorConstants.cAppColors,
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          message,
                          style: getTextRegular(
                            colors: Colors.black,
                            size: SizeConstants.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static hideLoadingDialog(BuildContext context) {
    Get.back();
  }

  static Future<AlertAction> showCustomDialogYesNoLogout(
    BuildContext context,
    String message, {
    String? title,
    String? negativeActionText,
    String? positiveActionText,
  }) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConstants.s_8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConstants.width * 0.08,
                    right: SizeConstants.s_14,
                    top: SizeConstants.width * 0.08,
                    bottom: SizeConstants.s_12,
                  ),
                  child: Text(
                    title ?? "Log Out?",
                    style: getTextSemiBold(
                      colors: Colors.black87,
                      size: SizeConstants.width * 0.045,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConstants.width * 0.08,
                    right: SizeConstants.s_14,
                    bottom: SizeConstants.s_12,
                  ),
                  child: Text(
                    message,
                    style: getTextRegular(
                      colors: Colors.black87,
                      size: SizeConstants.width * 0.04,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    SizeConstants.width * 0.08,
                    SizeConstants.width * 0.06,
                    SizeConstants.width * 0.08,
                    SizeConstants.width * 0.08,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: SizeConstants.width * 0.12,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back(result: AlertAction.no);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade50,
                              side: const BorderSide(
                                width: 1.5,
                                color: ColorConstants.cAppColorsBlue,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: getTextMedium(
                                colors: ColorConstants.cAppColorsRed,
                                size: SizeConstants.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConstants.s_14),
                      Expanded(
                        child: SizedBox(
                          height: SizeConstants.width * 0.12,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.cAppColorsBlue,
                            ),
                            onPressed: () {
                              Get.back(result: AlertAction.yes);
                            },
                            child: Text(
                              positiveActionText ?? "Log Out",
                              style: getTextMedium(
                                colors: Colors.white,
                                size: SizeConstants.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return (action != null) ? action : AlertAction.cancel;
  }
}

class AlertActionWithReturnString {
  final AlertAction alertAction;
  final String reasonString;

  AlertActionWithReturnString(this.alertAction, this.reasonString);
}
