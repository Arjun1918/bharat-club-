import 'dart:io';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/app_theme/theme/app_theme.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../controller/qr_code_generate_controller.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({Key? key}) : super(key: key);

  @override
  _ScanQrCodeScreenState createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  String searchKeyword = "";
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isProcessing = false;
  bool isCameraInitialized = false; // Track camera initialization

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<QrCodeGenerateController>()) {
      Get.put(QrCodeGenerateController());
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (isCameraInitialized && controller != null) {
      if (Platform.isAndroid) {
        controller?.pauseCamera();
      } else if (Platform.isIOS) {
        controller?.resumeCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cleanupCamera();
        Get.back(result: "");
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Qr Scanner"),
        body: SafeArea(child: _buildTrainerListView()),
      ),
    );
  }

  Widget _buildTrainerListView() {
    return FocusDetector(
      onVisibilityGained: () {
        isProcessing = false;
        if (isCameraInitialized && controller != null) {
          controller?.resumeCamera();
        }
      },
      onVisibilityLost: () {
        if (isCameraInitialized && controller != null) {
          controller?.pauseCamera();
        }
      },
      child: GetBuilder<QrCodeGenerateController>(
        builder: (qrController) {
          return Container(
            color: AppColors.primaryGreen,
            child: qrController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 8.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: _buildQrView(context)),
                      SizedBox(height: 0.20.sw),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = 0.65.sw;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10.r,
        borderLength: 30.w,
        borderWidth: 10.w,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      isCameraInitialized = true; // Mark camera as initialized
    });

    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;

      if (scanData.code != null && scanData.code!.isNotEmpty) {
        isProcessing = true;

        try {
          await controller.pauseCamera();

          if (Get.isRegistered<QrCodeGenerateController>()) {
            final qrController = Get.find<QrCodeGenerateController>();
            await qrController.verifyQrCode(
              scanData.code ?? "",
              controller,
              context,
            );
          }
        } catch (e) {
          print('Error processing QR code: $e');
          isProcessing = false;
          await controller.resumeCamera();
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera permission denied')));
    }
  }

  void _cleanupCamera() {
    try {
      // Only attempt to stop if camera was initialized
      if (isCameraInitialized && controller != null) {
        controller?.stopCamera();
      }
      controller = null;
      isCameraInitialized = false;
    } catch (e) {
      print('Error cleaning up camera: $e');
    }
  }

  @override
  void dispose() {
    _cleanupCamera();
    super.dispose();
  }
}
