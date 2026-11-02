import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/register_provider.dart';

class CloseRegisterScreen extends StatefulWidget {
  const CloseRegisterScreen({super.key});

  @override
  State<CloseRegisterScreen> createState() => _CloseRegisterScreenState();
}

class _CloseRegisterScreenState extends State<CloseRegisterScreen> {
  // Controllers
  final TextEditingController _countedCashController = TextEditingController();
  final TextEditingController _closingNoteController = TextEditingController();

  double _expectedCash = 0.0;
  double _openingFloat = 0.0;
  bool _isInitialized = false;

  // Dynamic Calculations
  double get _countedCash =>
      double.tryParse(_countedCashController.text) ?? 0.0;

  double get _difference => _countedCash - _expectedCash;

  bool get _isBalanced => _difference.abs() < 0.01;

  @override
  void initState() {
    super.initState();
    _countedCashController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final registerProvider = context.read<RegisterProvider>();
      final session = registerProvider.activeSession;

      if (session != null) {
        _openingFloat = session.openingFloat;
        // In a real app, you would calculate expected cash from
        // opening float + cash sales - refunds + cash in - cash out.
        // For now, we default it to the opening float since we don't have movement tracking.
        _expectedCash = _openingFloat;
        _countedCashController.text = _expectedCash.toStringAsFixed(2);
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _countedCashController.dispose();
    _closingNoteController.dispose();
    super.dispose();
  }

  Future<void> _closeRegister() async {
    final c = context.colors;
    final registerProvider = context.read<RegisterProvider>();

    // Call provider to close register
    final success = await registerProvider.closeRegister(
      _countedCash,
      note: _closingNoteController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Register closed successfully'),
          // ✅ FIXED: was const Color(0xFF137333)
          backgroundColor: c.successFg,
        ),
      );
      // Navigate back to home
      context.goNamed(RouteNames.homeName);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(registerProvider.error ?? 'Failed to close register'),
          // ✅ FIXED: was Colors.red
          backgroundColor: c.dangerFg,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final registerProvider = context.watch<RegisterProvider>();

    // If no active session, show a placeholder
    if (!registerProvider.isRegisterOpen) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: c.textMuted),
              const SizedBox(height: 16),
              Text('No open register', style: textStyles.heading2),
              const SizedBox(height: 8),
              Text(
                'There is no active register session to close.',
                style: textStyles.bodySmall.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.safePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primaryCoral,
                  foregroundColor: c.textLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

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
                    onPressed: () => context.safePop(),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Close register',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Register 01 · Today',
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
                    const SizedBox(height: 12),

                    // ── Cash Summary Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // ✅ FIXED: was 0xFFF4F8FF
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Opening float',
                            '\$${_openingFloat.toStringAsFixed(2)}',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),

                          // Placeholder rows for future cash movement tracking
                          _buildSummaryRow(
                            'Cash sales · After change',
                            '+\$0.00',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Cash refunds',
                            '-\$0.00',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Cash in · Replenishment',
                            '+\$0.00',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Cash out · Expenses',
                            '-\$0.00',
                            c,
                            textStyles,
                          ),

                          const SizedBox(height: 16),
                          Divider(
                            color: c.border.withValues(alpha: 0.5),
                            height: 1,
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Expected cash',
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$${_expectedCash.toStringAsFixed(2)}',
                                style: textStyles.heading2.copyWith(
                                  color: c.primaryCoral,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Counted Cash Input ──
                    Text(
                      'Counted cash · USD',
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _countedCashController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: textStyles.bodyLarge,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.money_outlined,
                          color: c.textMuted,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
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
                    const SizedBox(height: 8),
                    Text(
                      'Count all notes and coins in the drawer.',
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Balance Indicator ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        // ✅ FIXED: successBg / warningBg
                        color: _isBalanced ? c.successBg : c.warningBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isBalanced
                                ? Icons.check_circle_outline_rounded
                                : Icons.warning_amber_rounded,
                            // ✅ FIXED: successFg / warningFg
                            color: _isBalanced ? c.successFg : c.warningFg,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isBalanced
                                ? 'Balanced · Difference \$0.00'
                                : 'Difference: \$${_difference.abs().toStringAsFixed(2)} ${_difference > 0 ? 'over' : 'short'}',
                            style: textStyles.bodySmall.copyWith(
                              // ✅ FIXED: successFg / warningFg
                              color: _isBalanced ? c.successFg : c.warningFg,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Closing Note ──
                    Text(
                      'Closing note',
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _closingNoteController,
                      style: textStyles.bodyLarge,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.note_outlined,
                          color: c.textMuted,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: registerProvider.isLoading
                        ? null
                        : _closeRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      disabledBackgroundColor: c.primaryCoral.withValues(
                        alpha: 0.5,
                      ),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: registerProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 20,
                                color: c.textLight,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Confirm & close register',
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
                  Text(
                    'This ends the current register session.',
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 12,
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

  // ── Helper Widget for Summary Rows ──
  Widget _buildSummaryRow(
    String label,
    String value,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyles.bodyMedium.copyWith(color: c.textSecondary),
        ),
        Text(
          value,
          style: textStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
