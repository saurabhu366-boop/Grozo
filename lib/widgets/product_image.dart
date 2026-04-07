import 'package:flutter/material.dart';
import 'package:shopzy/services/product_image_service.dart';

class ProductImage extends StatefulWidget {
  final String barcode;
  final String fallbackImagePath;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.barcode,
    this.fallbackImagePath = '',
    this.fit = BoxFit.contain,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late Future<String?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = ProductImageService.getImageUrl(widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        /// 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final imageUrl = snapshot.data;

        /// 🌐 Network Image
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return Image.network(
            imageUrl,
            fit: widget.fit,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => _fallback(),
          );
        }

        /// 📦 Local Asset Fallback
        if (widget.fallbackImagePath.isNotEmpty) {
          return Image.asset(
            widget.fallbackImagePath,
            fit: widget.fit,
            width: double.infinity,
            height: double.infinity,
          );
        }

        /// ❌ Final fallback
        return _placeholder();
      },
    );
  }

  /// 📦 Local fallback method
  Widget _fallback() {
    if (widget.fallbackImagePath.isNotEmpty) {
      return Image.asset(
        widget.fallbackImagePath,
        fit: widget.fit,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return _placeholder();
  }

  /// ❌ Placeholder
  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 36,
        ),
      ),
    );
  }
}