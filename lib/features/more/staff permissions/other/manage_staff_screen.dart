// features/more/staff permissions/manage_staff_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:pos_system/providers/language_provider.dart'; // 👈 ADD
import 'package:provider/provider.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/enum/role_enum.dart';
import 'package:pos_system/data/models/staff_model.dart';
import 'package:pos_system/providers/staff_provider.dart';

class ManageStaffScreen extends StatefulWidget {
  const ManageStaffScreen({super.key});

  @override
  State<ManageStaffScreen> createState() => _ManageStaffScreenState();
}

class _ManageStaffScreenState extends State<ManageStaffScreen> {
  StaffModel? _staff;
  bool _isInitialized = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  RoleEnum _selectedRole = RoleEnum.associate;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra is StaffModel) {
        _staff = extra;
        _nameController.text = _staff!.name;
        _emailController.text = _staff!.email;
        _selectedRole = _staff!.role;
        _isActive = _staff!.isActive;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_staff == null) return;

    final c = context.colors;
    final staffProvider = context.read<StaffProvider>();
    final success = await staffProvider.updateStaff(_staff!.id, {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': _selectedRole.name,
      'is_active': _isActive,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('manage_staff_update_success')),
          backgroundColor: c.successFg,
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            staffProvider.error ?? context.t('manage_staff_update_failed'),
          ),
          backgroundColor: c.dangerFg,
        ),
      );
    }
  }

  // Handle delete with confirmation
  Future<void> _deleteStaff() async {
    if (_staff == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dc = dialogContext.colors;
        return AlertDialog(
          backgroundColor: dc.cardBackground,
          title: Text(
            dialogContext.t('manage_staff_dialog_title'),
            style: TextStyle(color: dc.textPrimary),
          ),
          content: Text(
            dialogContext.tp('manage_staff_dialog_body', {
              'name': _staff!.name,
            }),
            style: TextStyle(color: dc.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                dialogContext.t('manage_staff_dialog_cancel'),
                style: TextStyle(color: dc.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(foregroundColor: dc.dangerFg),
              child: Text(dialogContext.t('manage_staff_dialog_remove')),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final c = context.colors;
    final staffProvider = context.read<StaffProvider>();
    final success = await staffProvider.deleteStaff(_staff!.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t('manage_staff_remove_success')),
          backgroundColor: c.successFg,
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            staffProvider.error ?? context.t('manage_staff_remove_failed'),
          ),
          backgroundColor: c.dangerFg,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Rebuild when language changes
    context.watch<LanguageProvider>();

    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final staffProvider = context.watch<StaffProvider>();

    if (_staff == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(child: Text(context.t('manage_staff_not_found'))),
      );
    }

    final initials = _staff!.name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

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
                    context.t('manage_staff_title'),
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

                    // ── Staff Avatar Header ──
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: c.isDark
                                  ? Colors.white.withValues(alpha: 0.10)
                                  : const Color(0xFFE8F0FE),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              initials,
                              style: textStyles.heading2.copyWith(
                                color: c.primaryCoral,
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _staff!.name,
                            style: textStyles.heading2.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _staff!.email,
                            style: textStyles.bodySmall.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Name Input ──
                    Text(
                      context.t('manage_staff_name_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: textStyles.bodyLarge,
                      decoration: _inputDecoration(c),
                    ),
                    const SizedBox(height: 16),

                    // ── Email Input ──
                    Text(
                      context.t('manage_staff_email_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: textStyles.bodyLarge,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        c,
                        icon: Icons.mail_outline_rounded,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Role Selection ──
                    Text(
                      context.t('manage_staff_role_label'),
                      style: textStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRoleOption(
                      role: RoleEnum.associate,
                      title: context.t('manage_staff_role_associate'),
                      description: context.t('manage_staff_role_associate_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 12),
                    _buildRoleOption(
                      role: RoleEnum.manager,
                      title: context.t('manage_staff_role_manager'),
                      description: context.t('manage_staff_role_manager_sub'),
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 24),

                    // ── Active Toggle ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t('manage_staff_active_title'),
                              style: textStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isActive
                                  ? context.t('manage_staff_active_on')
                                  : context.t('manage_staff_active_off'),
                              style: textStyles.bodySmall.copyWith(
                                color: c.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isActive,
                          onChanged: (val) => setState(() => _isActive = val),
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

                    // ── Danger Zone ──
                    Text(
                      context.t('manage_staff_danger_header'),
                      style: textStyles.labelSmall.copyWith(
                        color: c.dangerFg,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: staffProvider.isLoading ? null : _deleteStaff,
                      style: TextButton.styleFrom(
                        backgroundColor: c.dangerBg,
                        foregroundColor: c.dangerFg,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.t('manage_staff_remove_button'),
                        style: textStyles.labelMedium.copyWith(
                          color: c.dangerFg,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
              child: ElevatedButton(
                onPressed: staffProvider.isLoading ? null : _saveChanges,
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
                          Icon(Icons.check, size: 20, color: c.textLight),
                          const SizedBox(width: 8),
                          Text(
                            context.t('manage_staff_save_button'),
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

  InputDecoration _inputDecoration(AppThemeColors c, {IconData? icon}) {
    return InputDecoration(
      filled: true,
      fillColor: c.surfaceLight,
      prefixIcon: icon != null
          ? Icon(icon, color: c.textMuted, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
    );
  }
}
