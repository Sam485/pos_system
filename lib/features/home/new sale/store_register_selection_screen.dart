import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/enum/register_status_enum.dart';
import 'package:pos_system/data/models/register_model.dart';
import 'package:pos_system/providers/register_provider.dart';

class StoreRegisterSelectionScreen extends StatefulWidget {
  const StoreRegisterSelectionScreen({super.key});

  @override
  State<StoreRegisterSelectionScreen> createState() =>
      _StoreRegisterSelectionScreenState();
}

class _StoreRegisterSelectionScreenState
    extends State<StoreRegisterSelectionScreen> {
  String? _selectedRegisterId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterProvider>().fetchRegisters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final registerProvider = context.watch<RegisterProvider>();

    if (_selectedRegisterId == null && registerProvider.registers.isNotEmpty) {
      final available = registerProvider.registers
          .where((r) => r.status == RegisterStatusEnum.ready)
          .firstOrNull;
      if (available != null) {
        _selectedRegisterId = available.id;
      }
    }

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
                        context.t('register_choose_workspace'),
                        style: textStyles.heading2,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tp('register_signed_in_as', {
                          'name': 'Alex Morgan',
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
                      context.t('register_get_store_ready'),
                      style: textStyles.heading1.copyWith(
                        fontSize: 28,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── YOUR STORE Section ──
                    Text(
                      context.t('register_your_store'),
                      style: textStyles.labelSmall.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStoreCard(c, textStyles),
                    const SizedBox(height: 32),

                    // ── SELECT A REGISTER Section ──
                    Text(
                      context.t('register_select_register'),
                      style: textStyles.labelSmall.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Skeletonizer(
                      enabled:
                          registerProvider.isLoading &&
                          registerProvider.registers.isEmpty,
                      child:
                          registerProvider.registers.isEmpty &&
                              !registerProvider.isLoading
                          ? _buildEmptyState(c, textStyles)
                          : Column(
                              children: registerProvider.registers.map((
                                register,
                              ) {
                                return Column(
                                  children: [
                                    _buildRegisterOption(
                                      register: register,
                                      c: c,
                                      textStyles: textStyles,
                                    ),
                                    if (register !=
                                        registerProvider.registers.last)
                                      Divider(
                                        height: 1,
                                        color: c.border.withValues(alpha: 0.5),
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                    const SizedBox(height: 20),

                    // ── Info Alert ──
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
                              context.t('register_needs_float'),
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
                    onPressed: _selectedRegisterId == null
                        ? null
                        : () {
                            context.goNamed(
                              RouteNames.openRegisterName,
                              extra: _selectedRegisterId,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primaryCoral,
                      foregroundColor: c.textLight,
                      disabledBackgroundColor: c.textMuted.withValues(
                        alpha: 0.5,
                      ),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selectedRegisterId == null
                          ? context.t('register_select_a_register')
                          : context.tp('register_continue_with', {
                              'name': _getRegisterName(
                                registerProvider.registers,
                              ),
                            }),
                      style: textStyles.labelMedium.copyWith(
                        color: c.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tp('register_manager_line', {
                      'email': 'alex@foldstore.com',
                    }),
                    style: textStyles.bodySmall.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRegisterName(List<RegisterModel> registers) {
    if (_selectedRegisterId == null) {
      return context.t('register_name_generic');
    }
    final reg = registers.firstWhere(
      (r) => r.id == _selectedRegisterId,
      orElse: () => registers.first,
    );
    return reg.name;
  }

  // ── Helper Widget: Store Card ──
  Widget _buildStoreCard(AppThemeColors c, AppTextStylesX textStyles) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surfaceTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.storefront_outlined,
              color: c.primaryCoral,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'fold / SoHo',
                  style: textStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.t('register_store_address'),
                  style: textStyles.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.radio_button_checked, color: c.primaryCoral, size: 22),
        ],
      ),
    );
  }

  // ── Helper Widget: Register Option ──
  Widget _buildRegisterOption({
    required RegisterModel register,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    final bool isInUse = register.status == RegisterStatusEnum.inUse;
    final bool isSelected = _selectedRegisterId == register.id;

    String subtitle;
    if (isInUse) {
      subtitle = context.t('register_in_use');
    } else if (register.status == RegisterStatusEnum.ready) {
      subtitle = context.t('register_ready_to_open');
    } else {
      subtitle = context.t('register_offline');
    }

    return InkWell(
      onTap: isInUse
          ? null
          : () {
              setState(() {
                _selectedRegisterId = register.id;
              });
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            // Icon Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.surfaceTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.desktop_windows_outlined,
                color: isInUse ? c.textMuted : c.primaryCoral,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    register.name,
                    style: textStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isInUse ? c.textMuted : c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textStyles.bodySmall.copyWith(
                      color: isInUse ? c.textMuted : c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Right side status
            if (isInUse)
              Text(
                context.t('register_in_use_short'),
                style: textStyles.labelSmall.copyWith(
                  color: c.primaryCoral,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? c.primaryCoral : c.textMuted,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // ── Helper Widget: Empty State ──
  Widget _buildEmptyState(AppThemeColors c, AppTextStylesX textStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.devices_other_rounded, size: 48, color: c.textMuted),
            const SizedBox(height: 16),
            Text(
              context.t('register_no_registers'),
              style: textStyles.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              context.t('register_no_registers_hint'),
              style: textStyles.bodySmall.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
