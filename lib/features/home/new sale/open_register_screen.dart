import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/providers/register_provider.dart';

class OpenRegisterScreen extends StatefulWidget {
  const OpenRegisterScreen({super.key});

  @override
  State<OpenRegisterScreen> createState() => _OpenRegisterScreenState();
}

class _OpenRegisterScreenState extends State<OpenRegisterScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '250.00',
  );
  final TextEditingController _noteController = TextEditingController();

  String? _registerId;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is String) {
        _registerId = extra;
      }
      // Set localized note default once
      _noteController.text = context.t('open_register_note_default');
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final registerProvider = context.watch<RegisterProvider>();

    final register = registerProvider.registers.firstWhere(
      (r) => r.id == _registerId,
      orElse: () => registerProvider.registers.isNotEmpty
          ? registerProvider.registers.first
          : throw Exception('No registers found'),
    );

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
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
                        context.t('open_register_title'),
                        style: textStyles.heading2,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tp('open_register_subtitle', {
                          'store': context.t('register_store_default'),
                          'register': register.name,
                        }),
                        style: textStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      context.t('open_register_heading'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 28,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.t('open_register_description'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Opening Float Section ──
                    Text(
                      context.t('open_register_float_label'),
                      style: textStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: textStyles.bodyLarge,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.money_outlined,
                          color: c.textMuted,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
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
                      context.t('open_register_float_hint'),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Note Section ──
                    Text(
                      context.t('open_register_note_label'),
                      style: textStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _noteController,
                      style: textStyles.bodyLarge,
                      maxLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: c.textMuted,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
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
                    const SizedBox(height: 24),

                    // ── Summary Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            context.t('open_register_summary_store'),
                            'fold / SoHo',
                            c,
                            textStyles,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            context.t('open_register_summary_opened_by'),
                            'Alex Morgan',
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
                                context.t('open_register_summary_opening_cash'),
                                style: textStyles.bodyLarge,
                              ),
                              Text(
                                '\$${_amountController.text}',
                                style: textStyles.heading2.copyWith(
                                  color: c.primaryCoral,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Info Banner ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: c.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.t('open_register_info'),
                              style: textStyles.bodyMedium.copyWith(
                                color: c.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Action Area ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: c.background,
                border: Border(
                  top: BorderSide(color: c.border.withValues(alpha: 0.5)),
                ),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: registerProvider.isLoading
                        ? null
                        : () async {
                            final success = await registerProvider.openRegister(
                              register.id,
                              double.tryParse(_amountController.text) ?? 0.0,
                            );
                            if (success && context.mounted) {
                              context.goNamed(RouteNames.homeName);
                            }
                          },
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
                              Icon(Icons.check, size: 20, color: c.textLight),
                              const SizedBox(width: 8),
                              Text(
                                context.tp('open_register_action', {
                                  'amount': _amountController.text,
                                }),
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
                    context.tp('open_register_snapshot', {
                      'date': 'Oct 19, 2026, 9:00 AM',
                    }),
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

  // ── Helper Widget: Summary Row ──
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
