import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:provider/provider.dart';

import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_style_x.dart';

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  static const _tabs = [
    RouteNames.home,
    RouteNames.sell,
    RouteNames.sale,
    RouteNames.stock,
    RouteNames.more,
  ];

  static int _indexFromRoute(String location) {
    if (location.startsWith('/sell')) return 1;
    if (location.startsWith('/sales')) return 2;
    if (location.startsWith('/stock')) return 3;
    if (location.startsWith('/more')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromRoute(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          context.go(_tabs[index]);
        },
      ),
    );
  }
}

// ── Nav item model ────────────────────────────────────────────────
class _NavItemData {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String labelKey;

  const _NavItemData({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.labelKey,
  });
}

// ── Custom bottom nav bar — Facebook-style ────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Rebuild when language changes
    context.watch<LanguageProvider>();

    final c = context.colors;

    final items = [
      const _NavItemData(
        activeIcon: Icons.home_rounded,
        inactiveIcon: Icons.home_outlined,
        labelKey: 'nav_home',
      ),
      const _NavItemData(
        activeIcon: Icons.point_of_sale_rounded,
        inactiveIcon: Icons.point_of_sale_outlined,
        labelKey: 'nav_sell',
      ),
      const _NavItemData(
        activeIcon: Icons.receipt_long_rounded,
        inactiveIcon: Icons.receipt_long_outlined,
        labelKey: 'nav_sales',
      ),
      const _NavItemData(
        activeIcon: Icons.inventory_2_rounded,
        inactiveIcon: Icons.inventory_2_outlined,
        labelKey: 'nav_stock',
      ),
      const _NavItemData(
        activeIcon: Icons.more_horiz_rounded,
        inactiveIcon: Icons.more_horiz_rounded,
        labelKey: 'nav_more',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: c.background,
        border: Border(
          top: BorderSide(color: c.border.withValues(alpha: 0.5), width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 4),
      child: Row(
        children: List.generate(items.length, (index) {
          return _NavItem(
            data: items[index],
            isActive: currentIndex == index,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }
}

// ── Nav item widget — Facebook-style ──────────────────────────────
class _NavItem extends StatelessWidget {
  final _NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required _NavItemData data,
    required this.isActive,
    required this.onTap,
  }) : item = data;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    final activeColor = c.primaryCoral;
    final inactiveColor = c.textMuted;
    final color = isActive ? activeColor : inactiveColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? item.activeIcon : item.inactiveIcon,
                size: 26,
                color: color,
              ),
              const SizedBox(height: 2),
              Text(
                context.t(item.labelKey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textStyles.labelSmall.copyWith(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
