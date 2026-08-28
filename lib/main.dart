import"package:flutter/material.dart";
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_frame.dart';
import 'frame_button.dart';
void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final MobileScannerController controller =
    MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            MobileScanner(
              controller: controller,
          onDetect: (capture){for (final barcode in capture.barcodes){print(barcode.rawValue);}}
            ),

            const QRFrame(),
            FrameButton(
              controller: controller,
            ),
          ],
        )
        ),
      );
  }
}


