import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';
import 'package:pos_system/data/enum/role_enum.dart';
import 'package:pos_system/data/models/staff_model.dart';
import 'package:pos_system/providers/staff_provider.dart';
import 'package:pos_system/providers/auth_provider.dart';

class StaffPermissionsScreen extends StatefulWidget {
  const StaffPermissionsScreen({super.key});

  @override
  State<StaffPermissionsScreen> createState() => _StaffPermissionsScreenState();
}

class _StaffPermissionsScreenState extends State<StaffPermissionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffProvider>().fetchStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final staffProvider = context.watch<StaffProvider>();
    final authProvider = context.watch<AuthProvider>();

    final isLoading =
        staffProvider.isLoading && staffProvider.staffList.isEmpty;
    final currentUserId = authProvider.currentUserId;

    // Find the current user in the staff list
    final currentUser = staffProvider.staffList.firstWhere(
      (s) => s.id == currentUserId,
      orElse: () => staffProvider.staffList.isNotEmpty
          ? staffProvider.staffList.first
          : StaffModel(
              id: '',
              storeId: '',
              name: 'Unknown',
              email: '',
              role: RoleEnum.associate,
              isActive: false,
            ),
    );

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Skeletonizer(
          enabled: isLoading,
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
                          'Staff & permissions',
                          style: textStyles.heading2.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${staffProvider.staffList.length} active staff · SoHo store',
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

                      // ── Your Team Section ──
                      Text(
                        'YOUR TEAM',
                        style: textStyles.labelSmall.copyWith(
                          color: c.textSecondary,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Staff List
                      ...staffProvider.staffList.map(
                        (member) => _buildStaffItem(
                          member: member,
                          isCurrentUser: member.id == currentUserId,
                          c: c,
                          textStyles: textStyles,
                        ),
                      ),

                      // Empty state if no staff
                      if (staffProvider.staffList.isEmpty && !isLoading)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'No staff members found.',
                              style: textStyles.bodyMedium.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ── Permissions Card ──
                      if (currentUser.id.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8FF), // Light blue
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentUser.role.name == 'manager' ? 'Store manager' : 'Sales associate'} permissions',
                                style: textStyles.heading2.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${currentUser.name} · Current role',
                                style: textStyles.bodySmall.copyWith(
                                  color: c.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Show all permissions if manager, otherwise only sell permissions
                              _buildPermissionItem(
                                'Sell, refund & apply discounts',
                                c,
                                textStyles,
                              ),

                              if (currentUser.role.name == 'manager') ...[
                                _buildPermissionItem(
                                  'Open and close registers',
                                  c,
                                  textStyles,
                                ),
                                _buildPermissionItem(
                                  'Adjust inventory & manage customers',
                                  c,
                                  textStyles,
                                ),
                                _buildPermissionItem(
                                  'Edit store settings & invite staff',
                                  c,
                                  textStyles,
                                ),
                              ],
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      // ── Footer Note ──
                      Text(
                        'Sales associates can sell and manage customers. Refunds, discounts above 20%, stock adjustments and register closing need manager approval.',
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
                  onPressed: () {
                    context.pushNamed(RouteNames.inviteStaffName);
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
                      Icon(
                        Icons.person_add_alt_1_outlined,
                        size: 20,
                        color: c.textLight,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Invite a staff member',
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
      ),
    );
  }

  // ── Helper Widgets ──

  Widget _buildStaffItem({
    required StaffModel member,
    required bool isCurrentUser,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
  }) {
    // Get initials
    final initials = member.name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0FE), // Light blue
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: textStyles.labelSmall.copyWith(
                color: const Color(0xFF1967D2),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: textStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      Text(
                        ' · You',
                        style: textStyles.labelMedium.copyWith(
                          color: c.textMuted,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${member.role.name == 'manager' ? 'Store manager' : 'Sales associate'} · ${member.isActive ? 'Active' : 'Inactive'}',
                  style: textStyles.bodySmall.copyWith(
                    color: c.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Trailing Action
          if (isCurrentUser)
            Icon(
              Icons.check_circle_outline_rounded,
              color: c.primaryCoral,
              size: 20,
            )
          else
            TextButton(
              onPressed: () {
                context.pushNamed(RouteNames.manageStaffName, extra: member);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Manage',
                style: textStyles.labelSmall.copyWith(
                  color: c.primaryCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(
    String text,
    AppThemeColors c,
    AppTextStylesX textStyles,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: c.primaryCoral,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: textStyles.bodyMedium.copyWith(
                color: c.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
