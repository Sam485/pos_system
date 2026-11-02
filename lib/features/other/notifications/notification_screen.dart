// features/notifications/notification_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/extensions/context_extensions.dart';
import 'package:pos_system/data/models/notificatoin_model.dart';
import 'package:pos_system/providers/notificatoin_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final provider = context.watch<NotificationProvider>();

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
                  Expanded(
                    child: Text(
                      context.t('notif_title'),
                      style: textStyles.heading2.copyWith(fontSize: 24),
                    ),
                  ),
                  if (provider.unreadCount > 0)
                    TextButton(
                      onPressed: () => provider.markAllAsRead(),
                      child: Text(
                        context.t('notif_mark_all_read'),
                        style: textStyles.labelSmall.copyWith(
                          color: c.primaryCoral,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── List ──
            Expanded(
              child: Skeletonizer(
                enabled: provider.isLoading,
                child: provider.notifications.isEmpty && !provider.isLoading
                    ? Center(
                        child: Text(
                          context.t('notif_empty'),
                          style: textStyles.bodyMedium.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: provider.notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final notif = provider.notifications[index];
                          return _buildNotificationItem(
                            notif,
                            c,
                            textStyles,
                            provider,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    NotificationModel notif,
    AppThemeColors c,
    AppTextStylesX textStyles,
    NotificationProvider provider,
  ) {
    // Pick icon based on type — theme-aware colors
    IconData icon;
    Color iconColor;
    switch (notif.type) {
      case 'order':
        icon = Icons.receipt_long_outlined;
        iconColor = c.primaryCoral;
        break;
      case 'delivery':
        icon = Icons.local_shipping_outlined;
        iconColor = c.successFg;
        break;
      case 'promo':
        icon = Icons.local_offer_outlined;
        iconColor = c.warningFg;
        break;
      default:
        icon = Icons.info_outline_rounded;
        iconColor = c.primaryCoral;
    }

    return InkWell(
      onTap: () {
        if (!notif.isRead) {
          provider.markAsRead(notif.id);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.transparent : c.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border.withValues(alpha: 0.6), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: textStyles.labelMedium.copyWith(
                            fontWeight: notif.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: c.primaryCoral,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    style: textStyles.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tp('notif_time', {
                      'hour': '${notif.createdAt.hour}',
                      'minute': notif.createdAt.minute.toString().padLeft(
                        2,
                        '0',
                      ),
                    }),
                    style: textStyles.bodySmall.copyWith(
                      color: c.textMuted,
                      fontSize: 11,
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
