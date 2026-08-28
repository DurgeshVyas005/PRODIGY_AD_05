import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FrameButton extends StatelessWidget {
  final MobileScannerController controller;

  const FrameButton({
    super.key,
    required this.controller,
  });

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
                onPressed: () {
                  controller.toggleTorch();
                },
                icon: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const Text(
                'Flash',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
                  // Gallery code will come here
                },
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const Text(
                'Gallery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}