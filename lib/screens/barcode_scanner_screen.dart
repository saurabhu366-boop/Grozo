// lib/screens/barcode_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shopzy/providers/auth_provider.dart';
import 'package:shopzy/services/cart_api_service.dart' as backend;
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/cart_icon_widget.dart';

// ✅ FINAL FIX: Removed permission_handler entirely.
// mobile_scanner v3+ requests camera permission internally when MobileScanner
// widget mounts. Our manual Permission.camera.status was returning a stale
// cached value and blocking the camera widget from ever mounting.

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: true, // MobileScanner requests permission + starts itself
  );
  final backend.CartService _backendCartService = backend.CartService();

  bool _isScanning = false;
  bool _isTorchOn = false;

  String get _userId => context.read<AuthProvider>().userId ?? '';

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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scannerController.start();
    } else if (state == AppLifecycleState.paused) {
      _scannerController.stop();
    }
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
            content: Text('✓ Added to cart: $code'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _scannerController.stop();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ Mount MobileScanner directly — no permission gating.
          // It shows the system permission dialog itself on first launch.
          // errorBuilder handles denied/unsupported cases.
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return _ErrorView(error: error);
            },
          ),

          _BarcodeScannerOverlay(
            scanLineAnimation: _scanLineAnimation,
            isScanning: _isScanning,
          ),

          // Top controls
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
                            _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
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

// ── Error view (permission denied / unsupported device) ──────────────────────
class _ErrorView extends StatelessWidget {
  final MobileScannerException error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    final bool isPermissionError =
        error.errorCode == MobileScannerErrorCode.permissionDenied;

    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPermissionError
                    ? Icons.camera_alt_outlined
                    : Icons.error_outline,
                color: Colors.white54,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                isPermissionError
                    ? 'Camera permission is required to scan products.\n\nGo to Settings → Apps → Grozo → Permissions and enable Camera.'
                    : 'Camera error: ${error.errorCode}',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Go Back',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Scanner overlay ───────────────────────────────────────────────────────────
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
        Positioned(
          top: cutoutTop,
          left: cutoutLeft,
          child: _ScannerFrame(size: cutoutSize, isScanning: isScanning),
        ),
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
        Positioned(
          top: cutoutTop + cutoutSize + 24,
          left: 0,
          right: 0,
          child: AnimatedSwitcher(
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
        ),
      ],
    );
  }
}

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
    final w = size.width;
    final h = size.height;
    final r = radius;
    final c = cornerLength;
    canvas.drawPath(Path()..moveTo(0, c + r)..lineTo(0, r)..arcToPoint(Offset(r, 0), radius: Radius.circular(r))..lineTo(c + r, 0), paint);
    canvas.drawPath(Path()..moveTo(w - c - r, 0)..lineTo(w - r, 0)..arcToPoint(Offset(w, r), radius: Radius.circular(r))..lineTo(w, c + r), paint);
    canvas.drawPath(Path()..moveTo(w, h - c - r)..lineTo(w, h - r)..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))..lineTo(w - c - r, h), paint);
    canvas.drawPath(Path()..moveTo(c + r, h)..lineTo(r, h)..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))..lineTo(0, h - c - r), paint);
  }

  @override
  bool shouldRepaint(_CornerBracketPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

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