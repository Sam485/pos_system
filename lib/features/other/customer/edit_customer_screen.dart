import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/models/customer_model.dart';
import 'package:pos_system/providers/customer_provider.dart';

class EditCustomerScreen extends StatefulWidget {
  const EditCustomerScreen({super.key});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Toggle state
  bool _isMarketingEnabled = false;

  // Data from Router
  CustomerModel? _customer;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;

      if (extra is CustomerModel) {
        _customer = extra;

        // Pre-fill the controllers with existing data
        _firstNameController.text = _customer!.firstName;
        _lastNameController.text = _customer!.lastName;
        _emailController.text = _customer!.email;
        _phoneController.text = _customer!.phone ?? '';
        _noteController.text = _customer!.note ?? '';
        _isMarketingEnabled = _customer!.marketingOtpIn;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (_customer == null) {
      context.pop();
      return;
    }

    final c = context.colors;
    final customerProvider = context.read<CustomerProvider>();

    // Build the payload
    final data = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'note': _noteController.text,
      'marketing_otp_in': _isMarketingEnabled,
    };

    final success = await customerProvider.updateCustomer(_customer!.id, data);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('edit_customer_update_success')),
          backgroundColor: c.successFg,
        ),
      );
      context.pop(); // Go back to profile
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            customerProvider.error ?? context.t('edit_customer_update_failed'),
          ),
          backgroundColor: c.dangerFg,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final customerProvider = context.watch<CustomerProvider>();

    // Build the subtitle text
    final subtitleText = _customer != null
        ? context.tp('edit_customer_subtitle', {
            'name': '${_customer!.firstName} ${_customer!.lastName}',
            'date': context.t('edit_customer_subtitle_date'),
          })
        : context.t('edit_customer_loading');

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
                        context.t('edit_customer_title'),
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
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

                    // ── First & Last Name Row ──
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldGroup(
                            label: context.t('edit_customer_first_name'),
                            controller: _firstNameController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextFieldGroup(
                            label: context.t('edit_customer_last_name'),
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
                      label: context.t('edit_customer_email'),
                      controller: _emailController,
                      icon: Icons.mail_outline_rounded,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 16),

                    // ── Phone Number ──
                    _buildTextFieldGroup(
                      label: context.t('edit_customer_phone'),
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 16),

                    // ── Customer Note ──
                    _buildTextFieldGroup(
                      label: context.t('edit_customer_note'),
                      controller: _noteController,
                      icon: Icons.edit_note_rounded,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 24),

                    // ── Email Marketing Toggle ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t('edit_customer_marketing_title'),
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isMarketingEnabled
                                  ? context.t('edit_customer_marketing_on')
                                  : context.t('edit_customer_marketing_off'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        // ✅ FIXED: was activeColor + invalid params
                        Switch(
                          value: _isMarketingEnabled,
                          onChanged: (val) {
                            setState(() {
                              _isMarketingEnabled = val;
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

                    // ── Info Banner ──
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
                            Icons.info_outline_rounded,
                            color: c.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.t('edit_customer_info_banner'),
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
                    const SizedBox(height: 16),

                    // ── Footer Note ──
                    Text(
                      context.t('edit_customer_footer_note'),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
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
                  // Primary Button (Save)
                  ElevatedButton(
                    onPressed: customerProvider.isLoading
                        ? null
                        : _saveCustomer,
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
                    child: customerProvider.isLoading
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
                                context.t('edit_customer_save_button'),
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

                  // Secondary Button (Cancel)
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      // ✅ FIXED: was 0xFFF4F8FF
                      backgroundColor: c.surfaceTint,
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.t('edit_customer_cancel_button'),
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
