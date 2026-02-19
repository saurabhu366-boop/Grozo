// lib/screens/barcode_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shopzy/services/cart_api_service.dart' as backend;
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/cart_icon_widget.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController();
  final backend.CartService _backendCartService = backend.CartService();

  bool _isScanning = false;
  bool _isTorchOn = false;
  final String _userId = "user1"; // Replace with logged-in user

  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isScanning || capture.barcodes.isEmpty) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isScanning = true);
    HapticFeedback.mediumImpact();

    try {
      await _backendCartService.scanProduct(code, _userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product scanned: $code"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Scan failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isScanning = false);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Camera Feed
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          /// Scanner Overlay Widget
          _BarcodeScannerOverlay(
            scanLineAnimation: _scanLineAnimation,
            isScanning: _isScanning,
          ),

          /// Top Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            _isTorchOn
                                ? Icons.flashlight_on
                                : Icons.flashlight_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _scannerController.toggleTorch();
                            setState(() => _isTorchOn = !_isTorchOn);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      CartIconWidget(isLight: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barcode Scanner Overlay Widget
// ---------------------------------------------------------------------------

class _BarcodeScannerOverlay extends StatelessWidget {
  final Animation<double> scanLineAnimation;
  final bool isScanning;

  const _BarcodeScannerOverlay({
    required this.scanLineAnimation,
    required this.isScanning,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double cutoutSize = 260.0;
    final double cutoutTop = (size.height - cutoutSize) / 2 - 40;
    final double cutoutLeft = (size.width - cutoutSize) / 2;

    return Stack(
      children: [
        /// Dimmed overlay with transparent cutout
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.55),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Positioned(
                top: cutoutTop,
                left: cutoutLeft,
                child: Container(
                  width: cutoutSize,
                  height: cutoutSize,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Corner brackets
        Positioned(
          top: cutoutTop,
          left: cutoutLeft,
          child: _ScannerFrame(
            size: cutoutSize,
            isScanning: isScanning,
          ),
        ),

        /// Animated scan line
        Positioned(
          top: cutoutTop + 8,
          left: cutoutLeft + 8,
          child: AnimatedBuilder(
            animation: scanLineAnimation,
            builder: (context, _) {
              return SizedBox(
                width: cutoutSize - 16,
                height: cutoutSize - 16,
                child: Align(
                  alignment: Alignment(0, (scanLineAnimation.value * 2) - 1),
                  child: Container(
                    height: 2.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withOpacity(0.9),
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        /// Status badge
        Positioned(
          top: cutoutTop + cutoutSize + 24,
          left: 0,
          right: 0,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isScanning
                    ? _StatusBadge(
                  key: const ValueKey('processing'),
                  label: 'Processing...',
                  color: Colors.orange,
                  icon: Icons.hourglass_top_rounded,
                )
                    : _StatusBadge(
                  key: const ValueKey('ready'),
                  label: 'Align barcode within the frame',
                  color: Colors.white70,
                  icon: Icons.qr_code_scanner,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Corner bracket painter
// ---------------------------------------------------------------------------

class _ScannerFrame extends StatelessWidget {
  final double size;
  final bool isScanning;

  const _ScannerFrame({required this.size, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CornerBracketPainter(
        color: isScanning ? Colors.orange : AppColors.primary,
        strokeWidth: 4,
        cornerLength: 28,
        radius: 16,
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double radius;

  _CornerBracketPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double w = size.width;
    final double h = size.height;
    final double r = radius;
    final double c = cornerLength;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, c + r)
        ..lineTo(0, r)
        ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
        ..lineTo(c + r, 0),
      paint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(w - c - r, 0)
        ..lineTo(w - r, 0)
        ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
        ..lineTo(w, c + r),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w, h - c - r)
        ..lineTo(w, h - r)
        ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
        ..lineTo(w - c - r, h),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(c + r, h)
        ..lineTo(r, h)
        ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
        ..lineTo(0, h - c - r),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CornerBracketPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

// ---------------------------------------------------------------------------
// Status Badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}