// features/more/staff permissions/invite_staff_screen.dart

import 'package:flutter/material.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/enum/role_enum.dart';
import 'package:pos_system/providers/staff_provider.dart';

class InviteStaffScreen extends StatefulWidget {
  const InviteStaffScreen({super.key});

  @override
  State<InviteStaffScreen> createState() => _InviteStaffScreenState();
}

class _InviteStaffScreenState extends State<InviteStaffScreen> {
  final TextEditingController _emailController = TextEditingController();
  RoleEnum _selectedRole = RoleEnum.associate;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    final c = context.colors;

    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('invite_error_email')),
          backgroundColor: c.dangerFg,
        ),
      );
      return;
    }

    final staffProvider = context.read<StaffProvider>();
    final success = await staffProvider.inviteStaff(
      _emailController.text.trim(),
      _selectedRole,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('invite_success')),
          backgroundColor: c.successFg,
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(staffProvider.error ?? context.t('invite_failed')),
          backgroundColor: c.dangerFg,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final staffProvider = context.watch<StaffProvider>();

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
                  Text(
                    context.t('invite_title'),
                    style: textStyles.heading2.copyWith(fontSize: 20),
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

                    // Headings
                    Text(
                      context.t('invite_heading'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 22,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.t('invite_description'),
                      style: textStyles.bodyMedium.copyWith(
                        color: c.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Email Input ──
                    Text(
                      context.t('invite_email_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: textStyles.bodyLarge,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: c.textMuted,
                          size: 20,
                        ),
                        hintText: context.t('invite_email_hint'),
                        hintStyle: textStyles.bodyMedium.copyWith(
                          color: c.textMuted,
                        ),
                        filled: true,
                        fillColor: c.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
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

                    // ── Role Selection ──
                    Text(
                      context.t('invite_role_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildRoleOption(
                      role: RoleEnum.associate,
                      title: context.t('invite_role_associate'),
                      description: context.t('invite_role_associate_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 12),
                    _buildRoleOption(
                      role: RoleEnum.manager,
                      title: context.t('invite_role_manager'),
                      description: context.t('invite_role_manager_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),

                    const SizedBox(height: 32),

                    // ── Footer Note ──
                    Text(
                      context.t('invite_footer_note'),
                      style: textStyles.bodySmall.copyWith(
                        color: c.textMuted,
                        fontSize: 12,
                        height: 1.4,
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
              child: ElevatedButton(
                onPressed: staffProvider.isLoading ? null : _sendInvite,
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
                child: staffProvider.isLoading
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
                            Icons.send_rounded,
                            size: 20,
                            color: c.textLight,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.t('invite_send_button'),
                            style: textStyles.labelMedium.copyWith(
                              color: c.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required RoleEnum role,
    required String title,
    required String description,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? c.surfaceTint : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? c.primaryCoral : c.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              role == RoleEnum.manager
                  ? Icons.admin_panel_settings_outlined
                  : Icons.person_outline,
              color: isSelected ? c.primaryCoral : c.textMuted,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? c.primaryCoral : c.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
