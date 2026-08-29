import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'qr_frame.dart';
import 'frame_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScannerPage(),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  final MobileScannerController controller =
      MobileScannerController();

  bool isShowingResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [

          // Camera
          MobileScanner(
            controller: controller,

            onDetect: (capture) {
              for (final barcode in capture.barcodes) {

                final String? value = barcode.rawValue;

                if (value != null && !isShowingResult) {
                  showScanResult(value);
                }
              }
            },
          ),

          // QR frame
          const QRFrame(),

          // Flash + Gallery
          FrameButton(
            controller: controller,
            onScanResult: showScanResult,
          ),
        ],
      ),
    );
  }
  bool isUrl(String value) {
  final Uri? uri = Uri.tryParse(value);

  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https');
}

  void showScanResult(String value) {
  setState(() {
    isShowingResult = true;
  });

  final bool link = isUrl(value);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(28),
  ),
),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Center(
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 40,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'QR Code Scanned',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              if (link)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        )
                      ),
                      child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton(
                      onPressed: () async {
                        final Uri uri = Uri.parse(value);

                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        )
                      ),
                      child: const Text('Open',style:TextStyle(color: Colors.black),),
                      )
                  ],
                )

              else

                Align(
                  alignment: Alignment.centerRight,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: value),
                      );

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Copied to clipboard',
                          ),
                        ),
                      );
                    },

                    icon: const Icon(Icons.copy),

                    label: const Text('Copy'),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    isShowingResult = false;
  });
}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}