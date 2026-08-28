import 'package:flutter/material.dart';

class QRFrame extends StatefulWidget {
  const QRFrame({super.key});

  @override
  State<QRFrame> createState() => _QRFrameState();
}

class _QRFrameState extends State<QRFrame>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double frameSize = 280;
    const double cornerLength = 35;

    return Center(
      child: SizedBox(
        width: frameSize,
        height: frameSize,

        child: Stack(
          children: [

            // =========================
            // QR FRAME
            // =========================

            CustomPaint(
              size: const Size(frameSize, frameSize),
              painter: QRFramePainter(),
            ),

            // =========================
            // SCANNING LINE
            // =========================

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {

                // Keep line inside the frame
                final double top =
                    5 + (_controller.value * (frameSize - 10));

                return Positioned(
                  top: top,
                  left: 5,
                  right: 5,

                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.7),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// ========================================
// FRAME PAINTER
// ========================================

class QRFramePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 35;

    // TOP LEFT
    canvas.drawLine(
      const Offset(0, cornerLength),
      const Offset(0, 0),
      paint,
    );

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(cornerLength, 0),
      paint,
    );

    // TOP RIGHT
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // BOTTOM LEFT
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // BOTTOM RIGHT
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}