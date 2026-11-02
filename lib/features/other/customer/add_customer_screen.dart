import 'package:flutter/material.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController(
    text: 'Jordan',
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: 'Lee',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'jordan.lee@email.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+1 (917) 555-0148',
  );
  final TextEditingController _noteController = TextEditingController(
    text: 'Prefers relaxed fits and neutral colors',
  );

  // Marketing toggle state
  bool _isMarketingChecked = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

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
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('add_customer_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.t('add_customer_subtitle'),
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

                    // Intro Text
                    Text(
                      context.t('add_customer_intro'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Name Row ──
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldGroup(
                            label: context.t('add_customer_first_name'),
                            controller: _firstNameController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextFieldGroup(
                            label: context.t('add_customer_last_name'),
                            controller: _lastNameController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Email Address ──
                    _buildTextFieldGroup(
                      label: context.t('add_customer_email'),
                      controller: _emailController,
                      icon: Icons.mail_outline_rounded,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 16),

                    // ── Phone Number ──
                    _buildTextFieldGroup(
                      label: context.t('add_customer_phone'),
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 16),

                    // ── Customer Note ──
                    _buildTextFieldGroup(
                      label: context.t('add_customer_note'),
                      controller: _noteController,
                      icon: Icons.edit_note_rounded,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 24),

                    // ── Marketing Checkbox ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom Checkbox
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isMarketingChecked = !_isMarketingChecked;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _isMarketingChecked
                                  ? c.primaryCoral
                                  : c.surfaceLight,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _isMarketingChecked
                                    ? c.primaryCoral
                                    : c.border,
                                width: 1.5,
                              ),
                            ),
                            child: _isMarketingChecked
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: c.textLight,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t('add_customer_marketing_title'),
                                style: textStyles.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.t('add_customer_marketing_sub'),
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textMuted,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Privacy Info Banner ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        // ✅ FIXED: was 0xFFF4F8FF
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: c.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.t('add_customer_privacy_info'),
                              style: textStyles.bodySmall.copyWith(
                                // ✅ FIXED: was c.primaryCoral
                                color: c.textSecondary,
                                height: 1.4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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
                    onPressed: () {
                      // Save logic
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
                    child: Text(
                      context.t('add_customer_save_button'),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.t('add_customer_privacy_note'),
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

  // ── Helper Widget for Text Fields ──
  Widget _buildTextFieldGroup({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: textStyles.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: c.surfaceLight,
            prefixIcon: icon != null
                ? Icon(icon, color: c.textMuted, size: 20)
                : null,
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
              borderSide: BorderSide(color: c.primaryCoral, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
