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

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => QrCodeGenerateController());
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
    final qrController = Get.find<QrCodeGenerateController>();
    return FocusDetector(
      onVisibilityGained: () async {
        await controller?.resumeCamera();
      },
      onVisibilityLost: () {
        controller?.pauseCamera();
      },
      child: Obx(
        () => Container(
          color: AppColors.primaryGreen, // Background color set to green
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
                    SizedBox(height: 0.20.sw), // replaced SizeConstants.width * 0.20
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = 0.65.sw; // replaced SizeConstants.width * 0.65
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
    });
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();

      final qrController = Get.find<QrCodeGenerateController>();
      qrController.verifyQrCode(scanData.code ?? "", controller, context);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
