// features/sell/function/scan_barcode_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/product_provider.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  final TextEditingController _skuController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    _skuController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    _controller.stop();
    setState(() => _isProcessing = true);

    _findAndNavigate(code);
  }

  void _findAndNavigate(String code) {
    final productProvider = context.read<ProductProvider>();
    final inventoryProvider = context.read<InventoryProvider>();

    final product = productProvider.findProductBySku(code, inventoryProvider);

    if (product != null) {
      context.pushReplacementNamed(
        RouteNames.productDetailName,
        extra: product,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No product found for barcode: $code'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isProcessing = false);
        _controller.start();
      }
    }
  }

  void _findProductManually() {
    final query = _skuController.text.trim();
    if (query.isEmpty) return;

    final productProvider = context.read<ProductProvider>();
    final inventoryProvider = context.read<InventoryProvider>();

    final product = productProvider.findProductBySku(query, inventoryProvider);

    if (product != null) {
      context.pushReplacementNamed(
        RouteNames.productDetailName,
        extra: product,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No product found with that SKU'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    // The size of the scan window
    const double scanFrameWidth = 260;
    const double scanFrameHeight = 160;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan a barcode',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'New sale · Register 01',
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Camera Preview (Masked) ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate the position of the hole
                      final scanFrameRect = Rect.fromCenter(
                        center: Offset(
                          constraints.maxWidth / 2,
                          constraints.maxHeight / 2,
                        ),
                        width: scanFrameWidth,
                        height: scanFrameHeight,
                      );

                      return Stack(
                        children: [
                          // 1. The Live Camera Feed
                          MobileScanner(
                            controller: _controller,
                            onDetect: _onDetect,
                          ),

                          // 2. The Dark Mask with a hole in the middle
                          Positioned.fill(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(
                                  alpha: 0.7,
                                ), // Dark overlay
                                BlendMode
                                    .srcOut, // This punches a hole based on the children
                              ),
                              child: Stack(
                                children: [
                                  // The background must be black for srcOut to work
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      backgroundBlendMode: BlendMode.dstOut,
                                    ),
                                  ),
                                  // The hole
                                  Positioned(
                                    left: scanFrameRect.left,
                                    top: scanFrameRect.top,
                                    width: scanFrameRect.width,
                                    height: scanFrameRect.height,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // The shape of the hole
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 3. The Border around the hole
                          Center(
                            child: Container(
                              width: scanFrameWidth,
                              height: scanFrameHeight,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: c.primaryCoral,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          // 4. Instruction text
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Place barcode inside the frame',
                                  style: textStyles.labelSmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Manual Entry ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Or enter barcode / SKU manually',
                    style: textStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _skuController,
                    style: textStyles.bodyLarge,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.qr_code_rounded,
                        color: c.textMuted,
                        size: 20,
                      ),
                      hintText: 'CT-WHT-M',
                      hintStyle: textStyles.bodyMedium.copyWith(
                        color: c.textMuted,
                      ),
                      filled: true,
                      fillColor: c.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: c.primaryCoral,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _findProductManually,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: c.textLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Find product',
                          style: textStyles.labelMedium.copyWith(
                            color: c.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Back to catalog',
                      style: textStyles.labelMedium.copyWith(
                        color: c.primaryCoral,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
