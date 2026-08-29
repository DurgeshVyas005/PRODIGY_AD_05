import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
class FrameButton extends StatelessWidget {
  final MobileScannerController controller;
  final void Function(String value) onScanResult;
  final ImagePicker picker = ImagePicker();
   FrameButton({
    super.key,
    required this.controller,
    required this.onScanResult,
  });

  Future<void> pickImage() async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image == null) {
    return;
  }

  final BarcodeCapture? result =
      await controller.analyzeImage(image.path);

  if (result == null) {
    print('No QR code found');
    return;
  }

  for (final barcode in result.barcodes) {
    final String? value = barcode.rawValue;

    if (value != null && value.isNotEmpty) {
      onScanResult(value);
      return;
    }
  }

  print('No QR code found');
}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Flash Button
          Column(
            children: [
              IconButton(
                iconSize: 40,
                icon: const Icon(
                  Icons.flash_on,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  controller.toggleTorch();
                },
                style: ButtonStyle(
                  backgroundColor: .all(Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(width: 80),

          // Gallery Button
          Column(
            children: [
              IconButton(
                onPressed: () {
                  pickImage();
                  // Gallery code will come here
                },
                style: ButtonStyle(backgroundColor: .all(Colors.white)),
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}