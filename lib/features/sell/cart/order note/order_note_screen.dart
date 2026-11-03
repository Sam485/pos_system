import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/cart_provider.dart';

class OrderNoteScreen extends StatefulWidget {
  const OrderNoteScreen({super.key});

  @override
  State<OrderNoteScreen> createState() => _OrderNoteScreenState();
}

class _OrderNoteScreenState extends State<OrderNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _includeOnReceipt = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final cartProvider = context.read<CartProvider>();
      // Load existing note if any
      _noteController.text = cartProvider.orderNote ?? '';
      _includeOnReceipt = cartProvider.includeNoteOnReceipt;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final cartProvider = context.read<CartProvider>();
    final customer = cartProvider.selectedCustomer;

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
                        context.t('order_note_title'),
                        style: textStyles.heading2.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customer != null
                            ? '${customer.firstName} ${customer.lastName}'
                            : context.t('order_note_customer_guest'),
                        style: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Heading
                    Text(
                      context.t('order_note_heading'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 22,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      context.t('order_note_description'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Note Input ──
                    Text(
                      context.t('order_note_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 5,
                      maxLength: 500,
                      style: textStyles.bodyLarge,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.all(16),
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
                        counterStyle: textStyles.bodySmall.copyWith(
                          color: c.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Include on Receipt Toggle ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t('order_note_include_title'),
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _includeOnReceipt
                                  ? context.t('order_note_include_on')
                                  : context.t('order_note_include_off'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        // ✅ FIXED: was activeColor + invalid params
                        Switch(
                          value: _includeOnReceipt,
                          onChanged: (val) {
                            setState(() {
                              _includeOnReceipt = val;
                            });
                          },
                          thumbColor: WidgetStateProperty.resolveWith(
                            (states) => c.textLight,
                          ),
                          trackColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return c.primaryCoral;
                            }
                            return c.surfaceLight;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Metadata Card ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        // ✅ FIXED: was Color(0xFFF4F8FF)
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('order_note_added_by'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              Text(
                                context.t('order_note_added_by_name'),
                                style: textStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.t('order_note_visibility'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                ),
                              ),
                              Text(
                                _includeOnReceipt
                                    ? context.t(
                                        'order_note_visibility_customer',
                                      )
                                    : context.t(
                                        'order_note_visibility_internal',
                                      ),
                                style: textStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      cartProvider.setOrderNote(
                        note: _noteController.text,
                        includeOnReceipt: _includeOnReceipt,
                      );
                      context.pop();
                    },
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
                        Icon(Icons.check, size: 20, color: c.textLight),
                        const SizedBox(width: 8),
                        Text(
                          context.t('order_note_save_button'),
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
                      // ✅ FIXED: was Color(0xFFF4F8FF)
                      backgroundColor: c.surfaceTint,
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('order_note_cancel_button'),
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
