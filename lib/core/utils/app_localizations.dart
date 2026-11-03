class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      // ═══════════════════════════════════════════════════════════
      // Home
      // ═══════════════════════════════════════════════════════════
      'home_loading': 'Loading...',
      'home_date_placeholder': 'MONDAY, OCTOBER 19',
      'home_greeting': 'Good morning, Alex.',
      'home_register_open': 'Register open',
      'home_register_closed': 'Register closed',
      'home_register_since': 'Register 01 · Since 9:00 AM',
      'home_no_active_session': 'No active session',
      'home_todays_net_sales': "Today's net sales",
      'home_trend_up': '12.8%',
      'home_vs_last_monday': 'vs. last Monday',
      'home_stat_transactions': 'Transactions',
      'home_stat_avg_sale': 'Average sale',
      'home_stat_items_sold': 'Items sold',
      'home_start_new_sale': 'Start a new sale',
      'home_glance_title': 'Your store at a glance',
      'home_glance_low_stock': '{count} variants running low',
      'home_glance_low_stock_sub': 'Replenish your bestsellers',
      'home_glance_customers': 'Customers',
      'home_glance_customers_sub': '{count} people in your community',
      'home_glance_cash_drawer': 'Cash drawer',
      'home_glance_cash_drawer_open': '\${amount} opening float · Balanced',
      'home_glance_cash_drawer_closed': 'No active drawer',
      // ═══════════════════════════════════════════════════════════
      // Low stock
      // ═══════════════════════════════════════════════════════════
      'low_stock_title': 'Stock alerts',
      'low_stock_subtitle': '{count} variants need attention · {store}',
      'low_stock_store_fallback': 'SoHo',
      'low_stock_filter_all': 'All alerts · {count}',
      'low_stock_filter_low': 'Low stock · {count}',
      'low_stock_filter_out': 'Out · {count}',
      'low_stock_header_availability': 'AVAILABILITY · {date}',
      'low_stock_empty': 'No alerts match this filter.',
      'low_stock_status_out': 'Out',
      'low_stock_status_left': '{count} left',
      'low_stock_status_min': 'Min. {count}',
      'low_stock_unknown_product': 'Unknown',
      // ═══════════════════════════════════════════════════════════
      // Customer directory
      // ═══════════════════════════════════════════════════════════
      'customers_title': 'Customers',
      'customers_subtitle': '{count} people in your community',
      'customers_search_label': 'Search your customers',
      'customers_search_hint': 'Name, email or phone',
      'customers_filter_all': 'All customers',
      'customers_filter_recent': 'Recently added',
      'customers_filter_returning': 'Returning',
      'customers_empty': 'No customers found.',
      'customers_add_button': 'Add a customer',
      'customers_visits_lifetime': '{visits} visits · Lifetime \${amount}',
      // ═══════════════════════════════════════════════════════════
      // Customer profile
      // ═══════════════════════════════════════════════════════════
      'profile_title': 'Customer profile',
      'profile_guest_name': 'Guest Customer',
      'profile_no_email': 'No email',
      'profile_no_phone': 'No phone',
      'profile_stat_visits': 'Visits',
      'profile_stat_lifetime': 'Lifetime net spend',
      'profile_info_note':
          'After Oct 19 partial refund: Previously 8 visits / \$624.00. Order #1048 adds \$99.00 net.',
      'profile_history_header': 'PURCHASE HISTORY · LATEST {shown} OF {total}',
      'profile_history_empty': 'No recent orders for this customer.',
      'profile_payment_via_card': 'Payment via card',
      'profile_status_partially_refunded': 'Partially refunded',
      'profile_status_short': '{status} · {time}',
      'profile_edit_button': 'Edit customer',
      'register_store_default': 'SoHo store',
      'open_register_note_default': 'Morning float counted and checked.',
      'register_signed_in_as_name': 'Signed in as {name}',
      'register_store_address': '120 Spring St, New York',
      'register_manager_email': 'Store manager • {email}',
      'close_register_failed_fallback': 'Failed to close register',
      // ═══════════════════════════════════════════════════════════
      // Connected devices
      // ═══════════════════════════════════════════════════════════
      'devices_title': 'Connected devices',
      'devices_subtitle': '{store} · {register}',
      'devices_store_default': 'SoHo store',
      'devices_register_default': 'Register 01',
      'devices_status_ok': 'All devices connected and ready for the next sale.',
      'devices_manage': 'Manage',
      'devices_reader_name': 'Fold Reader · 01',
      'devices_reader_status': 'Connected · Bluetooth',
      'devices_reader_battery': 'Battery',
      'devices_reader_last_checked': 'Last checked',
      'devices_reader_last_checked_value': 'Today, 10:30 AM',
      'devices_reader_methods': 'Contactless, chip and swipe payments',
      'devices_printer_name': 'Receipt printer',
      'devices_printer_status': 'Online · SoHo Wi-Fi',
      'devices_printer_model': 'Model',
      'devices_printer_model_value': 'Epson TM-m30III',
      'devices_printer_paper': 'Paper',
      'devices_printer_paper_value': 'Ready · 80 mm',
      'devices_printer_test': 'Print test page',
      'devices_connection_header': 'CONNECTION',
      'devices_network': 'Store network',
      'devices_network_name': 'fold-SoHo',
      'devices_network_hint':
          'Keep this device and the receipt printer on the same Wi-Fi network.',
      'devices_add_button': 'Add a device',
      // ═══════════════════════════════════════════════════════════
      // Help & support
      // ═══════════════════════════════════════════════════════════
      'help_title': 'Help & support',
      'help_subtitle': 'Here for you and your store',
      'help_heading': 'A little help goes a long\nway.',
      'help_search_label': 'Search the help center',
      'help_search_hint': 'What can we help you with?',
      'help_guides_header': 'POPULAR GUIDES',
      'help_guide_reader_title': 'Connect your card reader',
      'help_guide_reader_sub': 'Pair, test and troubleshoot Reader 01',
      'help_guide_returns_title': 'Returns & refunds',
      'help_guide_returns_sub': 'Find a sale and refund an item',
      'help_guide_reconcile_title': 'Reconcile your cash drawer',
      'help_guide_reconcile_sub': 'Count cash and close with confidence',
      'help_guide_offline_title': 'Selling while offline',
      'help_guide_offline_sub': 'Keep carts safe during connection issues',
      'help_email_title': 'Prefer email?',
      'help_email_address': 'support@foldstore.com',
      'help_email_hint': 'Include your store, register and order number.',
      'help_footer_version':
          'fold POS · Version {version} · {store} · {register}',
      'help_footer_version_number': '2.4.0',
      'help_footer_store': 'SoHo',
      'help_footer_register': 'Register 01',
      'help_chat_button': 'Chat with support',
      'help_chat_hours': 'Daily, 8 AM–8 PM ET · Usually replies in 5 minutes',
      // ═══════════════════════════════════════════════════════════
      // Receipt preferences
      // ═══════════════════════════════════════════════════════════
      'receipt_pref_title': 'Receipt preferences',
      'receipt_pref_subtitle': '{store} · Print & digital',
      'receipt_pref_header_label': 'RECEIPT HEADER',
      'receipt_pref_store_address': 'SoHo · 120 Spring St, New York',
      'receipt_pref_footer_label': 'Receipt footer',
      'receipt_pref_toggle_logo_title': 'Show store logo',
      'receipt_pref_toggle_logo_sub': 'Use the fold wordmark',
      'receipt_pref_toggle_tax_title': 'Show tax breakdown',
      'receipt_pref_toggle_tax_sub': 'Display sales tax separately',
      'receipt_pref_toggle_email_title': 'Offer email receipts',
      'receipt_pref_toggle_email_sub': 'Ask the customer after payment',
      'receipt_pref_toggle_auto_title': 'Automatically print receipts',
      'receipt_pref_toggle_auto_on': 'On',
      'receipt_pref_toggle_auto_off': 'Off · Print when requested',
      'receipt_pref_note':
          'Receipt emails are transactional and don\'t subscribe customers to marketing.',
      'receipt_pref_save_button': 'Save preferences',
      'receipt_pref_print_button': 'Print test receipt',
      'receipt_pref_save_success': 'Preferences saved successfully',
      'receipt_pref_save_failed': 'Failed to save preferences',
      'receipt_pref_print_success': 'Test receipt sent to printer',
      // ═══════════════════════════════════════════════════════════
      // Invite staff
      // ═══════════════════════════════════════════════════════════
      'invite_title': 'Invite staff',
      'invite_heading': 'Grow your team.',
      'invite_description':
          'Invite a new staff member to join your store. They will receive an email to set up their account.',
      'invite_email_label': 'Email address',
      'invite_email_hint': 'name@example.com',
      'invite_role_label': 'Role',
      'invite_role_associate': 'Sales associate',
      'invite_role_associate_sub': 'Can sell and manage customers',
      'invite_role_manager': 'Store manager',
      'invite_role_manager_sub': 'Full access to all features',
      'invite_footer_note':
          'The new staff member will need to verify their email and create a password before accessing the store.',
      'invite_send_button': 'Send invitation',
      'invite_error_email': 'Please enter a valid email address',
      'invite_success': 'Invitation sent successfully',
      'invite_failed': 'Failed to send invite',
      // ═══════════════════════════════════════════════════════════
      // Manage staff
      // ═══════════════════════════════════════════════════════════
      'manage_staff_title': 'Manage staff',
      'manage_staff_not_found': 'Staff member not found.',
      'manage_staff_name_label': 'Full name',
      'manage_staff_email_label': 'Email address',
      'manage_staff_role_label': 'Role',
      'manage_staff_role_associate': 'Sales associate',
      'manage_staff_role_associate_sub': 'Can sell and manage customers',
      'manage_staff_role_manager': 'Store manager',
      'manage_staff_role_manager_sub': 'Full access to all features',
      'manage_staff_active_title': 'Active staff member',
      'manage_staff_active_on': 'Can log in and sell',
      'manage_staff_active_off': 'Cannot log in',
      'manage_staff_danger_header': 'DANGER ZONE',
      'manage_staff_remove_button': 'Remove staff member',
      'manage_staff_save_button': 'Save changes',
      'manage_staff_update_success': 'Staff member updated successfully',
      'manage_staff_update_failed': 'Failed to update staff member',
      'manage_staff_remove_success': 'Staff member removed',
      'manage_staff_remove_failed': 'Failed to remove staff member',
      'manage_staff_dialog_title': 'Remove staff member?',
      'manage_staff_dialog_body':
          'Are you sure you want to remove {name}? This action cannot be undone.',
      'manage_staff_dialog_cancel': 'Cancel',
      'manage_staff_dialog_remove': 'Remove',
      // ═══════════════════════════════════════════════════════════
      // Store details
      // ═══════════════════════════════════════════════════════════
      'store_details_title': 'Store details',
      'store_details_loading': 'Loading...',
      'store_details_name_label': 'Store name',
      'store_details_street_label': 'Street address',
      'store_details_city_label': 'City',
      'store_details_zip_label': 'ZIP code',
      'store_details_phone_label': 'Store phone',
      'store_details_currency_label': 'Currency',
      'store_details_timezone_label': 'Time zone',
      'store_details_info':
          'America/New_York · EST / EDT adjusts automatically. Address and phone appear on receipts.',
      'store_details_manager_note':
          'Only store managers can update store details.',
      'store_details_save_button': 'Save store details',
      'store_details_cancel_button': 'Cancel changes',
      'store_details_save_success': 'Store details updated successfully',
      'store_details_save_failed': 'Failed to update store details',
      // ═══════════════════════════════════════════════════════════
      // Taxes & discounts
      // ═══════════════════════════════════════════════════════════
      'taxes_title': 'Taxes & discounts',
      'taxes_subtitle': '{store}',
      'taxes_store_default': 'SoHo store',
      'taxes_sales_tax': 'Sales tax',
      'taxes_sales_tax_hint': 'Added at checkout after order discounts.',
      'taxes_apply_tax_title': 'Apply sales tax',
      'taxes_apply_tax_sub': 'All taxable products',
      'taxes_active_discounts': '{count} ACTIVE DISCOUNTS',
      'taxes_require_approval_title': 'Require approval above 20%',
      'taxes_require_approval_sub':
          'Store manager approval for custom discounts',
      'taxes_create_button': 'Create a discount',
      'taxes_footer_note':
          'One order discount per sale. Changes only apply to new checkouts; past receipts stay unchanged.',
      'taxes_save_button': 'Save settings',
      'taxes_save_success': 'Settings saved successfully',
      'taxes_save_failed': 'Failed to save settings',
      'taxes_edit_rate_title': 'Sales tax rate',
      'taxes_edit_rate_cancel': 'Cancel',
      'taxes_edit_rate_save': 'Save',
      'taxes_create_sheet_title': 'Create a discount',
      'taxes_create_name_label': 'Name',
      'taxes_create_value_label': 'Value',
      'taxes_create_description_percentage': '{value}% off · Whole order',
      'taxes_create_description_fixed': '\${value} off',
      'taxes_create_action': 'Create',
      'taxes_delete_dialog_title': 'Delete discount?',
      'taxes_delete_dialog_body': 'Are you sure you want to delete "{name}"?',
      'taxes_delete_dialog_cancel': 'Cancel',
      'taxes_delete_dialog_delete': 'Delete',
      // ═══════════════════════════════════════════════════════════
      // Settings (Your store)
      // ═══════════════════════════════════════════════════════════
      'settings_title': 'Your store',
      'settings_loading': 'Loading...',
      'settings_no_address': 'No address set',
      'settings_all_systems_online': 'All systems online',
      'settings_section_operations': 'STORE OPERATIONS',
      'settings_section_preferences': 'PREFERENCES',
      'settings_section_team': 'TEAM & ACCOUNT',
      'settings_menu_store_details': 'Store details',
      'settings_menu_store_details_sub': '{currency} · {timezone}',
      'settings_menu_taxes': 'Taxes & discounts',
      'settings_menu_taxes_sub': 'Sales tax {rate}% · {count} active discounts',
      'settings_menu_receipt': 'Receipt preferences',
      'settings_menu_receipt_sub': 'Logo, footer & digital receipts',
      'settings_menu_devices': 'Connected devices',
      'settings_menu_devices_sub': 'Reader 01 · Receipt printer',
      'settings_menu_theme': 'Theme',
      'settings_menu_language': 'Language',
      'settings_menu_staff': 'Staff & permissions',
      'settings_menu_staff_sub': '{name} · {role}',
      'settings_menu_staff_name_fallback': 'Alex Morgan',
      'settings_menu_staff_role_fallback': 'Store manager',
      'settings_menu_close_register': 'Close register',
      'settings_menu_close_register_open': 'Register 01 · Open since {time}',
      'settings_menu_close_register_closed': 'No active register',
      'settings_menu_sign_out': 'Sign out',
      'settings_footer': 'fold POS · Version {version} · Help & support',
      'settings_footer_version': '2.4.0',
      'settings_theme_light': 'Light',
      'settings_theme_dark': 'Dark',
      'settings_theme_system': 'System default',
      'settings_theme_sheet_title': 'Choose theme',
      'settings_language_sheet_title': 'Choose language',
      // ═══════════════════════════════════════════════════════════
      // Add customer
      // ═══════════════════════════════════════════════════════════
      'add_customer_title': 'New customer',
      'add_customer_subtitle': 'Customer directory',
      'add_customer_intro':
          'Create a profile for quicker checkouts, digital receipts and a more personal welcome.',
      'add_customer_first_name': 'First name *',
      'add_customer_last_name': 'Last name *',
      'add_customer_email': 'Email address *',
      'add_customer_phone': 'Phone number',
      'add_customer_note': 'Customer note',
      'add_customer_marketing_title': 'Send news & special offers',
      'add_customer_marketing_sub':
          'Only with the customer\'s permission. They can unsubscribe at any time.',
      'add_customer_privacy_info':
          'An email is used for receipts, not marketing, unless the customer opts in.',
      'add_customer_save_button': 'Save customer & add to sale',
      'add_customer_privacy_note': 'Customer details stay private and secure.',
      // ═══════════════════════════════════════════════════════════
      // Edit customer
      // ═══════════════════════════════════════════════════════════
      'edit_customer_title': 'Edit customer',
      'edit_customer_subtitle': '{name} · Customer since {date}',
      'edit_customer_subtitle_date': 'Jan 2026',
      'edit_customer_loading': 'Loading...',
      'edit_customer_first_name': 'First name',
      'edit_customer_last_name': 'Last name',
      'edit_customer_email': 'Email address',
      'edit_customer_phone': 'Phone number',
      'edit_customer_note': 'Customer note',
      'edit_customer_marketing_title': 'Email marketing',
      'edit_customer_marketing_on': 'Subscribed · Customer opted in',
      'edit_customer_marketing_off': 'Not subscribed · Ask for consent first',
      'edit_customer_info_banner':
          'Receipt emails are separate from marketing preferences.',
      'edit_customer_footer_note':
          'Changes update the customer profile, not past receipts.',
      'edit_customer_save_button': 'Save customer',
      'edit_customer_cancel_button': 'Cancel changes',
      'edit_customer_update_success': 'Customer updated successfully',
      'edit_customer_update_failed': 'Failed to update customer',
      // ═══════════════════════════════════════════════════════════
      // Notifications
      // ═══════════════════════════════════════════════════════════
      'notif_title': 'Notifications',
      'notif_mark_all_read': 'Mark all read',
      'notif_empty': 'No notifications yet.',
      'notif_time': '{hour}:{minute}',
      // ═══════════════════════════════════════════════════════════
      // Scan barcode
      // ═══════════════════════════════════════════════════════════
      'scan_title': 'Scan a barcode',
      'scan_subtitle': '{mode} · {register}',
      'scan_mode_sell': 'New sale',
      'scan_register_default': 'Register 01',
      'scan_instructions': 'Place barcode inside the frame',
      'scan_manual_label': 'Or enter barcode / SKU manually',
      'scan_manual_hint': 'CT-WHT-M',
      'scan_find_button': 'Find product',
      'scan_back_button': 'Back to catalog',
      'scan_error_no_barcode': 'No product found for barcode: {code}',
      'scan_error_no_sku': 'No product found with that SKU',
      // ═══════════════════════════════════════════════════════════
      // Receipt (post-sale)
      // ═══════════════════════════════════════════════════════════
      'receipt_title': 'Receipt',
      'receipt_subtitle': '{orderNumber} · Alternative card checkout',
      'receipt_not_found': 'Order not found',
      'receipt_store_address': 'SoHo · 120 Spring St, New York',
      'receipt_store_date_register': '{date} · Register 01',
      'receipt_customer_line': 'Receipt {orderNumber} · {customer}',
      'receipt_guest': 'Guest',
      'receipt_item_line': '{quantity} × {name}',
      'receipt_item_variant': '{color} / {size} · \${price} each',
      'receipt_item_default_name': 'Item',
      'receipt_subtotal': 'Subtotal',
      'receipt_discount': 'Welcome discount · 10%',
      'receipt_sales_tax': 'Sales tax · 10%',
      'receipt_total_paid': 'Total paid',
      'receipt_card_line': '{brand} **** {last4}',
      'receipt_approved_auth': 'Approved · Auth {auth}',
      'receipt_thank_you': 'Thank you for shopping with fold.',
      'receipt_delivered_banner': 'Receipt delivered to {email}.',
      'receipt_customer_fallback': 'customer',
      'receipt_send_again': 'Send again',
      'receipt_sending_again': 'Sending again...',
      'receipt_change_email': 'Change email address',
      'receipt_print_button': 'Print receipt',
      'receipt_printing': 'Printing receipt...',
      'receipt_done_button': 'Done',
      // ═══════════════════════════════════════════════════════════
      // Refund complete
      // ═══════════════════════════════════════════════════════════
      'refund_complete_title': 'Refund complete',
      'refund_complete_no_order': 'No order data.',
      'refund_complete_cash_refunded': 'Cash refunded',
      'refund_complete_partially_refunded': 'Partially refunded',
      'refund_complete_original_order': 'Original order',
      'refund_complete_reference': 'Refund reference',
      'refund_complete_method': 'Refund method',
      'refund_complete_method_cash': 'Cash',
      'refund_complete_datetime': 'Date & time',
      'refund_complete_datetime_value': '{date} · {time}',
      'refund_complete_original_total': 'Original total',
      'refund_complete_amount_refunded': 'Amount refunded',
      'refund_complete_net_sale': 'Net sale',
      'refund_complete_send_receipt': 'Send updated receipt',
      'refund_complete_back_sales': 'Back to sales',
      // ═══════════════════════════════════════════════════════════
      // Return / refund
      // ═══════════════════════════════════════════════════════════
      'return_refund_title': 'Return items',
      'return_refund_subtitle': 'Order {orderNumber}',
      'return_refund_not_found': 'Order not found',
      'return_refund_intro':
          'Select the items coming back. Discounts and tax are included in the refund.',
      'return_refund_item_unknown': 'Unknown Product',
      'return_refund_item_variant': '{color} / {size} · {qty} purchased',
      'return_refund_item_qty_only': '{qty} purchased',
      'return_refund_item_price': '\${price} each',
      'return_refund_item_fully_returned': 'Fully returned',
      'return_refund_item_already_returned': '{qty} already returned',
      'return_refund_reason_label': 'Return reason',
      'return_refund_reason_default': 'Size didn\'t fit',
      'return_refund_restock_title': 'Return to available stock',
      'return_refund_restock_sub': 'Items will be added back to inventory',
      'return_refund_summary_title': 'Refund summary',
      'return_refund_summary_subtotal': 'Subtotal',
      'return_refund_summary_discount': 'Original discount',
      'return_refund_summary_tax': 'Tax returned',
      'return_refund_summary_total': 'Refund to cash',
      'return_refund_payment_note':
          'Original payment: cash · Eligible for return until {date}.',
      'return_refund_payment_note_date': 'Nov 18',
      'return_refund_action': 'Refund \${amount} in cash',
      'return_refund_footer':
          'Confirm only after handing the cash to the customer.',
      'return_refund_error_no_selection':
          'Please select at least one item to return.',
      // ═══════════════════════════════════════════════════════════
      // Transaction detail
      // ═══════════════════════════════════════════════════════════
      'txn_detail_title': 'Order {orderNumber}',
      'txn_detail_subtitle': '{date} · {time}',
      'txn_detail_not_found': 'Order not found.',
      'txn_detail_status_fully_refunded': 'Fully refunded',
      'txn_detail_status_partially_refunded': 'Partially refunded',
      'txn_detail_status_completed': 'Completed',
      'txn_detail_sold_by': 'Sold by {name} · {register}',
      'txn_detail_cashier_default': 'Alex',
      'txn_detail_register_default': 'Register 01',
      'txn_detail_customer_guest': 'Guest customer',
      'txn_detail_customer_no_email': 'No email',
      'txn_detail_no_items': 'No items in this order',
      'txn_detail_item_unknown_variant': 'Unknown Variant',
      'txn_detail_item_variant': '{color} / {size} · Qty {qty}',
      'txn_detail_item_qty': 'Qty {qty}',
      'txn_detail_item_refunded': 'Refunded',
      'txn_detail_item_returned_qty': 'Returned: {qty}',
      'txn_detail_subtotal': 'Subtotal · {count} items',
      'txn_detail_discount': 'Welcome discount · 10%',
      'txn_detail_tax': 'Sales tax · 10%',
      'txn_detail_refunded_amount': 'Refunded amount',
      'txn_detail_net_total': 'Net total',
      'txn_detail_payment_details': 'Payment details',
      'txn_detail_total_paid': 'Total paid',
      'txn_detail_refunded_to_customer': 'Refunded to customer',
      'txn_detail_receipt_sent': 'Receipt sent to {email}',
      'txn_detail_return_button': 'Return items',
      'txn_detail_view_receipt_button': 'View receipt',
      // ═══════════════════════════════════════════════════════════
      // Manage stock
      // ═══════════════════════════════════════════════════════════
      'manage_stock_title': 'Manage stock',
      'manage_stock_store_default': 'SoHo store',
      'manage_stock_product_units': '{units} units · {variants} variants',
      'manage_stock_view_details': 'View product details',
      'manage_stock_stock_by_variant': 'Stock by variant',
      'manage_stock_add_button': 'Add',
      'manage_stock_size_default': 'M',
      'manage_stock_color_default': 'White',
      'manage_stock_sku_default': 'CT-WHT-M',
      'manage_stock_product_default': 'Essential cotton tee',
      'manage_stock_update_title': 'Update {size} · {color} / {size}',
      'manage_stock_update_sku':
          'SKU {sku} · {count} units currently available',
      'manage_stock_action_add': 'Add stock',
      'manage_stock_action_remove': 'Remove',
      'manage_stock_action_set': 'Set quantity',
      'manage_stock_quantity_label': 'Quantity',
      'manage_stock_reason_label': 'Reason',
      'manage_stock_reason_default': 'Stock received',
      'manage_stock_note_label': 'Reference note',
      'manage_stock_note_default': 'Delivery PO-0246',
      'manage_stock_current_available': 'Current available',
      'manage_stock_current_units': '{count} units',
      'manage_stock_after_update': 'After update',
      'manage_stock_after_units': '{count} units',
      'manage_stock_last_movement':
          'Last movement: {change} · {orderNumber} · {time}',
      'manage_stock_last_movement_change': '+{count} return',
      'manage_stock_last_movement_order': '#1048',
      'manage_stock_last_movement_time': 'Today, 10:08 AM',
      'manage_stock_save_button': 'Save stock update · {change} units',
      'manage_stock_save_change_positive': '+{count}',
      'manage_stock_save_change_negative': '{count}',
      'manage_stock_update_success': 'Stock updated successfully',
      'manage_stock_add_variant_title': 'Add new variant',
      'manage_stock_color_label': 'Color',
      'manage_stock_color_default_input': 'White',
      'manage_stock_size_label': 'Size',
      'manage_stock_sku_label': 'SKU',
      'manage_stock_price_label': 'Price',
      'manage_stock_initial_stock_label': 'Initial stock',
      'manage_stock_save_variant_button': 'Save variant',
      'manage_stock_add_variant_error': 'Please fill in color and SKU',
      'manage_stock_add_variant_failed': 'Failed to create variant',
      // ═══════════════════════════════════════════════════════════
      // Sale filters (date range)
      // ═══════════════════════════════════════════════════════════
      'sale_filter_title': 'Filter sales',
      'sale_filter_store_default': 'SoHo store',
      'sale_filter_date_range_title': 'Date range',
      'sale_filter_range_today': 'Today',
      'sale_filter_range_yesterday': 'Yesterday',
      'sale_filter_range_week': 'This week',
      'sale_filter_range_custom': 'Custom',
      'sale_filter_from_label': 'From',
      'sale_filter_to_label': 'To',
      'sale_filter_date_note': 'Includes the full day · New York store time',
      'sale_filter_status_title': 'Sale status',
      'sale_filter_status_all': 'All sales',
      'sale_filter_status_completed': 'Completed',
      'sale_filter_status_refunded': 'Refunded',
      'sale_filter_status_note':
          'All sales includes partially refunded transactions.',
      'sale_filter_method_title': 'Payment method',
      'sale_filter_method_all': 'All methods',
      'sale_filter_method_cash': 'Cash',
      'sale_filter_method_card': 'Card',
      'sale_filter_staff_label': 'Staff member',
      'sale_filter_staff_all': 'All staff',
      'sale_filter_info_banner':
          'Oct 19 snapshot after refund #RF-0108: \$1,941.50 net sales across 25 transactions.',
      'sale_filter_show_button': 'Show {count} transactions',
      'sale_filter_reset_button': 'Reset filters',
      'sale_filter_month_jan': 'Jan',
      'sale_filter_month_feb': 'Feb',
      'sale_filter_month_mar': 'Mar',
      'sale_filter_month_apr': 'Apr',
      'sale_filter_month_may': 'May',
      'sale_filter_month_jun': 'Jun',
      'sale_filter_month_jul': 'Jul',
      'sale_filter_month_aug': 'Aug',
      'sale_filter_month_sep': 'Sep',
      'sale_filter_month_oct': 'Oct',
      'sale_filter_month_nov': 'Nov',
      'sale_filter_month_dec': 'Dec',
      'sale_filter_date_format': '{month} {day}, {year}',
      // ═══════════════════════════════════════════════════════════
      // Sales list
      // ═══════════════════════════════════════════════════════════
      'sales_title': 'Sales',
      'sales_search_hint': 'Search order or customer',
      'sales_filter_all': 'All sales',
      'sales_filter_completed': 'Completed',
      'sales_filter_refunded': 'Refunded',
      'sales_date_today': 'Today · Oct 19, 2026',
      'sales_summary_net': 'Net sales',
      'sales_summary_transactions': 'Transactions',
      'sales_section_header': 'TODAY · {count} TRANSACTIONS',
      'sales_empty': 'No transactions found.',
      'sales_guest_first': 'Guest',
      'sales_guest_last': 'Customer',
      'sales_guest_full': 'Guest customer',
      'sales_status_fully_refunded': 'Fully refunded',
      'sales_status_partially_refunded': 'Partially refunded',
      'sales_status_completed': 'Completed',
      'sales_item_was': 'Was \${amount}',
      'sales_item_time_payment': '{time} · Payment via card',
      'customer_select_title': 'Add a customer',
      'customer_search_hint': 'Search by name, email or phone',
      'customer_matching_count': '{count} matching customers',
      'customer_new_button': '+ New customer',
      'customer_no_results': 'No customers found.',
      'customer_insight_title': 'Customer Insight',
      'customer_insight_familiar': 'A familiar face. A better experience.',
      'customer_insight_welcome': 'Welcome back.',
      'customer_insight_spent': '{name} has spent \${amount} with your store.',
      'customer_use_button': 'Use {name}',
      'customer_select_prompt': 'Select a customer',
      'customer_continue_guest': 'Continue as guest',
      // ═══════════════════════════════════════════════════════════
      // Card payment decline
      // ═══════════════════════════════════════════════════════════
      'card_decline_title': 'Card payment',
      'card_decline_subtitle': '{orderId} · Alternative checkout state',
      'card_decline_heading': 'Card declined.',
      'card_decline_description':
          'The bank didn\'t approve this payment. Ask {customerName} to try again or use a different card.',
      'card_decline_still_to_pay': 'Still to pay',
      'card_decline_card_attempted': 'Card attempted',
      'card_decline_customer': 'Customer',
      'card_decline_status': 'Payment status',
      'card_decline_status_unpaid': 'Unpaid',
      'card_decline_reader': 'Reader',
      'card_decline_reader_default': 'Reader 01',
      'card_decline_warning':
          'No payment taken. This sale is not complete and stock has not changed.',
      'card_decline_footer':
          'Alternative to the cash checkout for {orderId}, not a second charge.',
      'card_decline_retry_button': 'Retry card payment',
      'card_decline_choose_other_button': 'Choose another method',
      // ═══════════════════════════════════════════════════════════
      // Card payment
      // ═══════════════════════════════════════════════════════════
      'card_payment_title': 'Card payment',
      'card_payment_subtitle_customer': 'For {name} · Alternative payment',
      'card_payment_subtitle_generic': 'Alternative payment',
      'card_payment_reader_connected': 'Reader connected',
      'card_payment_total_due': 'Total due',
      'card_payment_tap_to_pay': 'Tap to pay',
      'card_payment_processing': 'Processing...',
      'card_payment_ready': 'Ready when they are.',
      'card_payment_instruction_named':
          'Ask {name} to tap, insert or swipe their card on the reader.',
      'card_payment_instruction_generic':
          'Ask the customer to tap, insert or swipe their card on the reader.',
      'card_payment_processing_payment': 'Processing payment...',
      'card_payment_waiting_card': 'Waiting for card...',
      'card_payment_reader_label': 'Reader',
      'card_payment_reader_name': 'Fold Reader · 01',
      'card_payment_accepted_cards':
          'Accepts Visa, Mastercard, Amex, Apple Pay and Google Pay.',
      'card_payment_simulate_button': 'Simulate Card Tap · \${amount}',
      'card_payment_cancel_button': 'Cancel & choose another method',
      'card_payment_footer':
          'Do not close this screen while the payment is processing.',
      'card_payment_failed': 'Payment failed',
      // ═══════════════════════════════════════════════════════════
      // Cash payment
      // ═══════════════════════════════════════════════════════════
      'cash_payment_title': 'Cash payment',
      'cash_payment_subtitle_customer': 'For {name}',
      'cash_payment_subtitle_guest': 'Guest customer',
      'cash_payment_total_due': 'Total due',
      'cash_payment_cash_received': 'Cash received',
      'cash_payment_quick_exact': 'Exact',
      'cash_payment_change_title': 'Change to give',
      'cash_payment_insufficient_title': 'Insufficient cash',
      'cash_payment_hand_change_named':
          'Hand the change to {name} before finishing.',
      'cash_payment_hand_change_generic':
          'Hand the change to the customer before finishing.',
      'cash_payment_insufficient_hint': 'Customer needs to pay more.',
      'cash_payment_complete_button': 'Complete sale · \${amount}',
      'cash_payment_failed': 'Payment failed',
      // ═══════════════════════════════════════════════════════════
      // Checkout
      // ═══════════════════════════════════════════════════════════
      'checkout_guard_title': 'No open register',
      'checkout_guard_hint':
          'You need to open a register before completing this sale.',
      'checkout_guard_button': 'Open a Register',
      'checkout_title': 'Checkout',
      'checkout_subtitle': '{count} items · New sale',
      'checkout_guest_customer': 'Guest Customer',
      'checkout_no_email': 'No email attached',
      'checkout_order_summary': 'Order summary',
      'checkout_edit_cart': 'Edit cart',
      'checkout_item_line': '{quantity} × {name}',
      'checkout_subtotal': 'Subtotal · {count} items',
      'checkout_discount_percentage': '{name} · {value}%',
      'checkout_discount_fixed': '{name}',
      'checkout_tax': 'Sales tax · 10%',
      'checkout_total_due': 'Total due',
      'checkout_payment_question': 'How would they like to pay?',
      'checkout_pay_cash': 'Cash',
      'checkout_pay_cash_sub': 'Accept cash & calculate change',
      'checkout_pay_card': 'Card',
      'checkout_pay_card_sub': 'Tap, insert or swipe',
      'checkout_pay_khqr': 'KHQR',
      'checkout_pay_khqr_sub': 'Scan QR code via banking app',
      'checkout_guest_name': 'Guest',
      'checkout_continue_button': 'Continue with {method} · \${amount}',
      'checkout_continue_button_cash': 'Continue with cash · \${amount}',
      'checkout_continue_button_card': 'Continue with card · \${amount}',
      'checkout_continue_button_khqr': 'Continue with KHQR · \${amount}',
      'checkout_footer': 'Stock updates automatically after payment.',
      // ═══════════════════════════════════════════════════════════
      // KHQR payment
      // ═══════════════════════════════════════════════════════════
      'khqr_title': 'Scan to pay',
      'khqr_bakong_label': 'Bakong · KHQR',
      'khqr_bakong_sub': 'Scan with any banking app',
      'khqr_amount_display': '\$ {amount}',
      'khqr_waiting_hint': 'Please do not close this screen',
      'khqr_payment_received': 'Payment of \${amount} received.',
      'khqr_creating_order': 'Creating order...',
      'khqr_failed_order': 'Failed to create order',
      // ═══════════════════════════════════════════════════════════
      // KHQR extra (generic)
      // ═══════════════════════════════════════════════════════════
      'qr_expires_in': 'QR expires in',
      'waiting_for_payment': 'Waiting for payment…',
      'qr_expired': 'QR expired',
      'generate_new_qr': 'Generate New QR',
      'payment_successful': 'Payment Successful',
      'something_went_wrong': 'Something went wrong',
      'unable_to_verify_payment': 'Unable to verify payment',
      'done': 'Done',
      'close': 'Close',
      // ═══════════════════════════════════════════════════════════
      // Sale complete
      // ═══════════════════════════════════════════════════════════
      'sale_complete_title': 'Sale complete',
      'sale_complete_heading': 'All wrapped up.',
      'sale_complete_confirmed_at': 'Payment confirmed at {time}',
      'sale_complete_paid_in': 'Paid in {method}',
      'sale_complete_method_cash': 'cash',
      'sale_complete_method_card': 'card',
      'sale_complete_method_khqr': 'khqr',
      'sale_complete_cash_received': 'Cash received',
      'sale_complete_change_given': 'Change given',
      'sale_complete_customer': 'Customer',
      'sale_complete_guest': 'Guest Customer',
      'sale_complete_items_sold': 'Items sold',
      'sale_complete_items_count': '{count} items',
      'sale_complete_send_receipt': 'Send their receipt',
      'sale_complete_email_label': 'Email receipt',
      'sale_complete_send_button': 'Send email receipt',
      'sale_complete_sent_toast': 'Receipt sent to {email}',
      'sale_complete_print_button': 'Print receipt',
      'sale_complete_share_button': 'Share receipt',
      'sale_complete_start_new': 'Start a new sale',
      'sale_complete_view_txn': 'View transaction',
      // ═══════════════════════════════════════════════════════════
      // Order note
      // ═══════════════════════════════════════════════════════════
      'order_note_title': 'Order note',
      'order_note_customer_guest': 'Guest customer',
      'order_note_heading': 'The details that matter.',
      'order_note_description':
          'Leave a helpful note for the team. Keep payment and other sensitive information out of notes.',
      'order_note_label': 'Note',
      'order_note_include_title': 'Include note on receipt',
      'order_note_include_on': 'On · Customer will see this note',
      'order_note_include_off': 'Off · Only visible to store staff',
      'order_note_added_by': 'Added by',
      'order_note_added_by_name': 'Alex Morgan',
      'order_note_visibility': 'Visibility',
      'order_note_visibility_customer': 'Customer receipt',
      'order_note_visibility_internal': 'Internal only',
      'order_note_save_button': 'Save order note',
      'order_note_cancel_button': 'Cancel changes',
      // ═══════════════════════════════════════════════════════════
      // Product detail
      // ═══════════════════════════════════════════════════════════
      'product_detail_title': 'Product details',
      'product_detail_not_found': 'Product not found.',
      'product_detail_in_stock': 'In stock',
      'product_detail_out_of_stock': 'Out of stock',
      'product_detail_sku': 'SKU {sku}',
      'product_detail_sku_na': 'N/A',
      'product_detail_color': 'Color · {color}',
      'product_detail_size': 'Size · {size}',
      'product_detail_stock_available': '{count} available at {store}',
      'product_detail_store_default': 'SoHo',
      'product_detail_quantity': 'Quantity',
      'product_detail_add_button': 'Add {count} to cart · \${amount}',
      'product_detail_error_select_variant': 'Please select a variant',
      'product_detail_error_out_of_stock': 'Out of stock',
      'product_detail_error_not_enough': 'Only {count} units available',
      'product_detail_added_toast': 'Added to cart',
      'product_detail_failed_add': 'Failed to add to cart',
      // ═══════════════════════════════════════════════════════════
      // Product filter
      // ═══════════════════════════════════════════════════════════
      'product_filter_title': 'Product filters',
      'product_filter_subtitle': 'Refine the catalog',
      'product_filter_category_title': 'Category',
      'product_filter_size_title': 'Size',
      'product_filter_color_title': 'Color',
      'product_filter_price_title': 'Price range',
      'product_filter_price_min': 'Minimum',
      'product_filter_price_max': 'Maximum',
      'product_filter_instock_title': 'In-stock products only',
      'product_filter_instock_sub': 'Hide unavailable variants at {store}',
      'product_filter_store_default': 'SoHo',
      'product_filter_footer':
          'Filters apply to the current search. Prices are before tax.',
      'product_filter_apply_button': 'Show {count} matching products',
      'product_filter_clear_button': 'Clear all filters',
      // Category chip labels
      'product_filter_cat_all': 'All',
      'product_filter_cat_tops': 'Tops',
      'product_filter_cat_bottoms': 'Bottoms',
      'product_filter_cat_knitwear': 'Knitwear',
      'product_filter_cat_classics': 'Classics',
      // Color chip labels
      'product_filter_color_any': 'Any color',
      'product_filter_color_white': 'White',
      'product_filter_color_sky': 'Sky',
      'product_filter_color_navy': 'Navy',
      'product_filter_color_sand': 'Sand',
      // ═══════════════════════════════════════════════════════════
      // Search products
      // ═══════════════════════════════════════════════════════════
      'search_products_title': 'Search products',
      'search_products_subtitle': '{store} · Before order {orderNumber}',
      'search_products_store_default': 'SoHo store',
      'search_products_order_default': '#1048',
      'search_products_label': 'Search products or SKU',
      'search_products_hint': 'Search products or scan a barcode',
      'search_products_results': '{count} results',
      'search_products_results_for': '{count} results for "{query}"',
      'search_products_filters': 'Filters',
      'search_products_empty': 'No products found for "{query}".',
      'search_products_match_note':
          'Matching product names, materials and SKUs.',
      'search_products_no_variants': 'No variants',
      'search_products_variant_line': '{color} / {size} · {sku}',
      'search_products_stock_available': '· {count} available',
      // ═══════════════════════════════════════════════════════════
      // Sell screen
      // ═══════════════════════════════════════════════════════════
      'sell_guard_title': 'No open register',
      'sell_guard_hint':
          'You need to open a register before starting a new sale.',
      'sell_guard_button': 'Open a Register',
      'sell_title_new': 'New sale',
      'sell_title_selected': '{count} selected',
      'sell_subtitle_store_register': '{store} · {register}',
      'sell_store_default': 'SoHo store',
      'sell_register_default': 'Register 01',
      'sell_subtitle_selection_hint': 'Long-press done · tap to toggle',
      'sell_select_all': 'Select all',
      'sell_search_hint': 'Search products or scan a barcode',
      'sell_error_load': 'Failed to load products: {error}',
      'sell_cancel': 'Cancel',
      'sell_copy_image': 'Copy image',
      'sell_copy_images': 'Copy {count} images',
      'sell_view_cart': 'View cart · {count} items',
      'sell_products_count': '{count} products',
      'sell_empty_title': 'No products available',
      'sell_empty_hint': 'Pull down to refresh',
      'sell_snack_nothing_copied': 'Nothing was copied',
      'sell_snack_copied_one': 'Image copied to clipboard',
      'sell_snack_copied_many':
          'Copied {count} images sequentially. The clipboard keeps only the LAST image.',
      'sell_snack_copy_failed': 'Copy failed: {error}',
      // ═══════════════════════════════════════════════════════════
      // Stock / inventory
      // ═══════════════════════════════════════════════════════════
      'stock_title': 'Inventory',
      'stock_store_default': 'SoHo store',
      'stock_search_hint': 'Search product, SKU or barcode',
      'stock_summary_products': 'Products',
      'stock_summary_units': 'Units on hand',
      'stock_summary_low': 'Low stock',
      'stock_filter_all': 'All stock',
      'stock_filter_low': 'Low stock · {count}',
      'stock_filter_out': 'Out of stock · {count}',
      'stock_list_results_for': '{count} results for "{query}"',
      'stock_list_count': '{count} products · Updated just now',
      'stock_empty_search': 'No products match "{query}"',
      'stock_empty_filter': 'No products match this filter.',
      'stock_item_variants_from': '{count} variants · From \${price}',
      'stock_item_variants_only': '{count} variants',
      'stock_status_out': '0 available · Out of stock',
      'stock_status_low': '{count} available · Reorder soon',
      'stock_status_ok': '{count} available',
      // ═══════════════════════════════════════════════════════════
      // Open register
      // ═══════════════════════════════════════════════════════════
      'open_register_title': 'Open register',
      'open_register_subtitle': '{store} · {register}',
      'open_register_heading': 'Start on a good note.',
      'open_register_description':
          'Count the cash in your drawer and enter your opening float.',
      'open_register_float_label': 'Opening float · USD',
      'open_register_float_hint':
          'Cash available for giving change. This is not a sale.',
      'open_register_note_label': 'Opening note (optional)',
      'open_register_summary_store': 'Store',
      'open_register_summary_opened_by': 'Opened by',
      'open_register_summary_opening_cash': 'Opening cash',
      'open_register_info':
          'Opening the register starts today\'s cash movement log.',
      'open_register_action': 'Open register · \${amount}',
      'open_register_snapshot': 'Opening snapshot · {date}',
      'register_choose_workspace': 'Choose your workspace',
      'register_signed_in_as': 'Signed in as {name}',
      'register_get_store_ready': "Let's get your store ready.",
      'register_your_store': 'YOUR STORE',
      'register_select_register': 'SELECT A REGISTER',
      'register_no_registers': 'No registers found',
      'register_no_registers_hint': 'Please contact your store manager.',
      'register_ready_to_open': 'Ready to open',
      'register_in_use': 'In use by another staff member',
      'register_in_use_short': 'In use',
      'register_offline': 'Offline',
      'register_needs_float':
          'The selected register needs an opening float before you can start selling.',
      'register_continue_with': 'Continue with {name}',
      'register_select_a_register': 'Select a register',
      'register_manager_line': 'Store manager • {email}',
      'register_name_generic': 'Register',
      'close_register_title': 'Close register',
      'close_register_subtitle': '{register} · Today',
      'close_register_no_open': 'No open register',
      'close_register_no_open_hint':
          'There is no active register session to close.',
      'close_register_go_back': 'Go back',
      'close_register_opening_float': 'Opening float',
      'close_register_cash_sales': 'Cash sales · After change',
      'close_register_cash_refunds': 'Cash refunds',
      'close_register_cash_in': 'Cash in · Replenishment',
      'close_register_cash_out': 'Cash out · Expenses',
      'close_register_expected_cash': 'Expected cash',
      'close_register_counted_cash': 'Counted cash · USD',
      'close_register_counted_hint': 'Count all notes and coins in the drawer.',
      'close_register_balanced': 'Balanced · Difference \$0.00',
      'close_register_difference_over': 'Difference: \${amount} over',
      'close_register_difference_short': 'Difference: \${amount} short',
      'close_register_note_label': 'Closing note',
      'close_register_action': 'Confirm & close register',
      'close_register_footer': 'This ends the current register session.',
      'close_register_success': 'Register closed successfully',
      'close_register_failed': 'Failed to close register',
      'staff_title': 'Staff & permissions',
      'staff_subtitle': '{count} active staff · {store}',
      'staff_store_default': 'SoHo store',
      'staff_team_header': 'YOUR TEAM',
      'staff_empty': 'No staff members found.',
      'staff_current_user_suffix': ' · You',
      'staff_role_manager': 'Store manager',
      'staff_role_associate': 'Sales associate',
      'staff_status_active': 'Active',
      'staff_status_inactive': 'Inactive',
      'staff_role_status': '{role} · {status}',
      'staff_manage': 'Manage',
      'staff_permissions_title_manager': 'Store manager permissions',
      'staff_permissions_title_associate': 'Sales associate permissions',
      'staff_permissions_subtitle': '{name} · Current role',
      'staff_permission_sell': 'Sell, refund & apply discounts',
      'staff_permission_registers': 'Open and close registers',
      'staff_permission_inventory': 'Adjust inventory & manage customers',
      'staff_permission_settings': 'Edit store settings & invite staff',
      'staff_footer_note':
          'Sales associates can sell and manage customers. Refunds, discounts above 20%, stock adjustments and register closing need manager approval.',
      'staff_invite_button': 'Invite a staff member',
      'staff_unknown_name': 'Unknown',
      // ── Bottom navigation labels ──
      'nav_home': 'Home',
      'nav_sell': 'Sell',
      'nav_sales': 'Sales',
      'nav_stock': 'Stock',
      'nav_more': 'More',

      // ── Header ──
      'cart_title': 'Cart',
      'cart_subtitle_items': '{count} items',

      // ── Customer banner ──
      'cart_add_customer': 'Add a customer',
      'cart_add_customer_sub': 'Attach a profile for receipts & history',

      // ── Order discount ──
      'cart_order_discount': 'Order discount',
      'cart_discount_apply': 'Apply',
      'cart_discount_change': 'Change',
      'cart_no_discount_applied': 'No discount applied',
      'cart_discount_fallback': 'Discount',
      'cart_tap_to_select_discount': 'Tap to select a discount',
      'cart_discount_subtitle_percentage': '{value}% off · -\${amount}',
      'cart_discount_subtitle_fixed': '-\${amount} off',

      // ── Discount picker sheet ──
      'cart_apply_discount_title': 'Apply a discount',
      'cart_no_discount_title': 'No discount',
      'cart_no_discount_subtitle': 'Charge the customer the full amount',

      // ── Order note ──
      'cart_add_order_note': 'Add an order note',

      // ── Order summary ──
      'cart_subtotal_items': 'Subtotal · {count} items',
      'cart_discount_summary_percentage': '{name} · {value}%',
      'cart_discount_summary_fixed': '{name}',
      'cart_sales_tax': 'Sales tax · 10%',
      'cart_total_due': 'Total due',

      // ── Cart item ──
      'cart_standard_variant': 'Standard variant',
      'cart_max_stock_reached': 'Max stock reached',

      // ── Empty state ──
      'cart_empty_title': 'Your cart is empty',
      'cart_empty_hint': 'Add products to start a new sale',
      'cart_browse_products': 'Browse products',

      // ── Bottom action ──
      'cart_continue_to_checkout': 'Continue to checkout',
      // ── Add to 'en' map ──
      'receipt_item_returned_note': '({count} returned)',
      'receipt_items_returned_count': '{count} item(s) fully returned',
      'receipt_refunded_line': 'Refunded',
      'receipt_net_paid': 'Net paid',
    },

    // ═══════════════════════════════════════════════════════════════
    // ═══════════════════════════════ KHMER ═════════════════════════
    // ═══════════════════════════════════════════════════════════════
    'km': {
      // ═══════════════════════════════════════════════════════════
      // Home
      // ═══════════════════════════════════════════════════════════
      'home_loading': 'កំពុងផ្ទុក...',
      'home_date_placeholder': 'ថ្ងៃច័ន្ទ ទី 19 តុលា',
      'home_greeting': 'អរុណសួស្តី Alex។',
      'home_register_open': 'គ្រឿងគិតលុយបើក',
      'home_register_closed': 'គ្រឿងគិតលុយបិទ',
      'home_register_since': 'គ្រឿងគិតលុយ 01 · ចាប់ពី 9:00 ព្រឹក',
      'home_no_active_session': 'គ្មានសម័យសកម្ម',
      'home_todays_net_sales': 'ការលក់សុទ្ធថ្ងៃនេះ',
      'home_trend_up': '12.8%',
      'home_vs_last_monday': 'ប្រៀបធៀបនឹងថ្ងៃច័ន្ទមុន',
      'home_stat_transactions': 'ប្រតិបត្តិការ',
      'home_stat_avg_sale': 'ការលក់មធ្យម',
      'home_stat_items_sold': 'ទំនិញលក់ចេញ',
      'home_start_new_sale': 'ចាប់ផ្តើមការលក់ថ្មី',
      'home_glance_title': 'សេចក្តីសង្ខេបហាងរបស់អ្នក',
      'home_glance_low_stock': '{count} ប្រភេទកំពុងអស់ស្តុក',
      'home_glance_low_stock_sub': 'បំពេញទំនិញលក់ដាច់បំផុតរបស់អ្នក',
      'home_glance_customers': 'អតិថិជន',
      'home_glance_customers_sub': '{count} នាក់ក្នុងសហគមន៍របស់អ្នក',
      'home_glance_cash_drawer': 'ថតប្រាក់',
      'home_glance_cash_drawer_open': '\${amount} ប្រាក់ដើម · ស្មើ',
      'home_glance_cash_drawer_closed': 'គ្មានថតប្រាក់សកម្ម',
      // ═══════════════════════════════════════════════════════════
      // Low stock
      // ═══════════════════════════════════════════════════════════
      'low_stock_title': 'ការជូនដំណឹងស្តុក',
      'low_stock_subtitle': '{count} ប្រភេទត្រូវការយកចិត្តទុកដាក់ · {store}',
      'low_stock_store_fallback': 'សូហូ',
      'low_stock_filter_all': 'ការជូនដំណឹងទាំងអស់ · {count}',
      'low_stock_filter_low': 'ស្តុកទាប · {count}',
      'low_stock_filter_out': 'អស់ · {count}',
      'low_stock_header_availability': 'ភាពអាចរកបាន · {date}',
      'low_stock_empty': 'គ្មានការជូនដំណឹងត្រូវនឹងតម្រងនេះទេ។',
      'low_stock_status_out': 'អស់',
      'low_stock_status_left': 'នៅសល់ {count}',
      'low_stock_status_min': 'អប្បបរមា {count}',
      'low_stock_unknown_product': 'មិនស្គាល់',
      // ═══════════════════════════════════════════════════════════
      // Customer directory
      // ═══════════════════════════════════════════════════════════
      'customers_title': 'អតិថិជន',
      'customers_subtitle': '{count} នាក់ក្នុងសហគមន៍របស់អ្នក',
      'customers_search_label': 'ស្វែងរកអតិថិជនរបស់អ្នក',
      'customers_search_hint': 'ឈ្មោះ អ៊ីមែល ឬទូរស័ព្ទ',
      'customers_filter_all': 'អតិថិជនទាំងអស់',
      'customers_filter_recent': 'បានបន្ថែមថ្មីៗ',
      'customers_filter_returning': 'ត្រឡប់មកវិញ',
      'customers_empty': 'រកមិនឃើញអតិថិជន។',
      'customers_add_button': 'បន្ថែមអតិថិជន',
      'customers_visits_lifetime': '{visits} ដង · សរុប \${amount}',
      // ═══════════════════════════════════════════════════════════
      // Customer profile
      // ═══════════════════════════════════════════════════════════
      'profile_title': 'ប្រវត្តិរូបអតិថិជន',
      'profile_guest_name': 'អតិថិជនភ្ញៀវ',
      'profile_no_email': 'គ្មានអ៊ីមែល',
      'profile_no_phone': 'គ្មានទូរស័ព្ទ',
      'profile_stat_visits': 'ដងចូលមក',
      'profile_stat_lifetime': 'ការចំណាយសុទ្ធសរុប',
      'profile_info_note':
          'បន្ទាប់ពីការសងប្រាក់មួយផ្នែកថ្ងៃទី 19 តុលា: ពីមុន 8 ដង / \$624.00។ ការបញ្ជាទិញ #1048 បន្ថែម \$99.00 សុទ្ធ។',
      'profile_history_header':
          'ប្រវត្តិការទិញ · ចុងក្រោយ {shown} ក្នុងចំណោម {total}',
      'profile_history_empty': 'គ្មានការបញ្ជាទិញថ្មីៗសម្រាប់អតិថិជននេះទេ។',
      'profile_payment_via_card': 'បង់ប្រាក់តាមកាត',
      'profile_status_partially_refunded': 'សងប្រាក់វិញមួយផ្នែក',
      'profile_status_short': '{status} · {time}',
      'profile_edit_button': 'កែប្រែអតិថិជន',
      'register_store_default': 'ហាងសូហូ',
      'open_register_note_default':
          'ប្រាក់ដើមពេលព្រឹកបានរាប់ និងពិនិត្យរួចហើយ។',
      'register_signed_in_as_name': 'បានចូលជា {name}',
      'register_store_address': '120 Spring St, New York',
      'register_manager_email': 'អ្នកគ្រប់គ្រងហាង • {email}',
      'close_register_failed_fallback': 'មិនអាចបិទគ្រឿងគិតលុយបាន',
      // ═══════════════════════════════════════════════════════════
      // Connected devices
      // ═══════════════════════════════════════════════════════════
      'devices_title': 'ឧបករណ៍ដែលបានភ្ជាប់',
      'devices_subtitle': '{store} · {register}',
      'devices_store_default': 'ហាងសូហូ',
      'devices_register_default': 'គ្រឿងគិតលុយ 01',
      'devices_status_ok':
          'ឧបករណ៍ទាំងអស់បានភ្ជាប់ និងរួចរាល់សម្រាប់ការលក់បន្ទាប់។',
      'devices_manage': 'គ្រប់គ្រង',
      'devices_reader_name': 'Fold Reader · 01',
      'devices_reader_status': 'បានភ្ជាប់ · ប៊្លូធូស',
      'devices_reader_battery': 'ថ្ម',
      'devices_reader_last_checked': 'ពិនិត្យចុងក្រោយ',
      'devices_reader_last_checked_value': 'ថ្ងៃនេះ 10:30 ព្រឹក',
      'devices_reader_methods': 'ការទូទាត់ដោយគ្មានប៉ះ ឈីប និងការអូស',
      'devices_printer_name': 'ម៉ាស៊ីនព្រីនបង្កាន់ដៃ',
      'devices_printer_status': 'លើបណ្តាញ · Wi-Fi សូហូ',
      'devices_printer_model': 'ម៉ូដែល',
      'devices_printer_model_value': 'Epson TM-m30III',
      'devices_printer_paper': 'ក្រដាស',
      'devices_printer_paper_value': 'រួចរាល់ · 80 mm',
      'devices_printer_test': 'ព្រីនសាកល្បង',
      'devices_connection_header': 'ការភ្ជាប់',
      'devices_network': 'បណ្តាញហាង',
      'devices_network_name': 'fold-SoHo',
      'devices_network_hint':
          'រក្សាឧបករណ៍នេះ និងម៉ាស៊ីនព្រីនបង្កាន់ដៃនៅលើបណ្តាញ Wi-Fi តែមួយ។',
      'devices_add_button': 'បន្ថែមឧបករណ៍',
      // ═══════════════════════════════════════════════════════════
      // Help & support
      // ═══════════════════════════════════════════════════════════
      'help_title': 'ជំនួយ និងការគាំទ្រ',
      'help_subtitle': 'នៅទីនេះសម្រាប់អ្នក និងហាងរបស់អ្នក',
      'help_heading': 'ជំនួយបន្តិច នាំឱ្យទៅមុខបានឆ្ងាយ។',
      'help_search_label': 'ស្វែងរកមជ្ឈមណ្ឌលជំនួយ',
      'help_search_hint': 'តើយើងអាចជួយអ្នកអ្វីបាន?',
      'help_guides_header': 'មគ្គុទ្ទេសក៍ពេញនិយម',
      'help_guide_reader_title': 'ភ្ជាប់ម៉ាស៊ីនអានកាតរបស់អ្នក',
      'help_guide_reader_sub': 'ភ្ជាប់ សាកល្បង និងដោះស្រាយបញ្ហា Reader 01',
      'help_guide_returns_title': 'ការត្រឡប់ និងការសងប្រាក់វិញ',
      'help_guide_returns_sub': 'រកការលក់ ហើយសងប្រាក់វិញសម្រាប់ទំនិញ',
      'help_guide_reconcile_title': 'ផ្ទៀងផ្ទាត់ថតប្រាក់របស់អ្នក',
      'help_guide_reconcile_sub': 'រាប់ប្រាក់ ហើយបិទដោយទំនុកចិត្ត',
      'help_guide_offline_title': 'ការលក់ពេលគ្មានអ៊ីនធឺណិត',
      'help_guide_offline_sub':
          'រក្សាកន្ត្រកឱ្យមានសុវត្ថិភាពពេលមានបញ្ហាការភ្ជាប់',
      'help_email_title': 'ចង់ផ្ញើអ៊ីមែល?',
      'help_email_address': 'support@foldstore.com',
      'help_email_hint': 'សូមបញ្ជាក់ហាង គ្រឿងគិតលុយ និងលេខការបញ្ជាទិញរបស់អ្នក។',
      'help_footer_version': 'fold POS · កំណែ {version} · {store} · {register}',
      'help_footer_version_number': '2.4.0',
      'help_footer_store': 'សូហូ',
      'help_footer_register': 'គ្រឿងគិតលុយ 01',
      'help_chat_button': 'ជជែកជាមួយជំនួយ',
      'help_chat_hours':
          'រៀងរាល់ថ្ងៃ 8 ព្រឹក–8 ល្ងាច ET · ជាធម្មតាឆ្លើយតបក្នុងរយៈពេល 5 នាទី',
      // ═══════════════════════════════════════════════════════════
      // Receipt preferences
      // ═══════════════════════════════════════════════════════════
      'receipt_pref_title': 'ចំណូលចិត្តបង្កាន់ដៃ',
      'receipt_pref_subtitle': '{store} · ព្រីន និងឌីជីថល',
      'receipt_pref_header_label': 'ក្បាលបង្កាន់ដៃ',
      'receipt_pref_store_address': 'សូហូ · 120 Spring St, New York',
      'receipt_pref_footer_label': 'ជើងបង្កាន់ដៃ',
      'receipt_pref_toggle_logo_title': 'បង្ហាញឡូហ្គោហាង',
      'receipt_pref_toggle_logo_sub': 'ប្រើសញ្ញាពាក្យ fold',
      'receipt_pref_toggle_tax_title': 'បង្ហាញការបំបែកពន្ធ',
      'receipt_pref_toggle_tax_sub': 'បង្ហាញពន្ធលក់ដោយឡែក',
      'receipt_pref_toggle_email_title': 'ផ្តល់បង្កាន់ដៃតាមអ៊ីមែល',
      'receipt_pref_toggle_email_sub': 'សួរអតិថិជនបន្ទាប់ពីការទូទាត់',
      'receipt_pref_toggle_auto_title': 'ព្រីនបង្កាន់ដៃដោយស្វ័យប្រវត្តិ',
      'receipt_pref_toggle_auto_on': 'បើក',
      'receipt_pref_toggle_auto_off': 'បិទ · ព្រីននៅពេលស្នើសុំ',
      'receipt_pref_note':
          'អ៊ីមែលបង្កាន់ដៃគឺជាប្រតិបត្តិការ ហើយមិនជាវអតិថិជនសម្រាប់ទីផ្សារទេ។',
      'receipt_pref_save_button': 'រក្សាទុកចំណូលចិត្ត',
      'receipt_pref_print_button': 'ព្រីនបង្កាន់ដៃសាកល្បង',
      'receipt_pref_save_success': 'បានរក្សាទុកចំណូលចិត្តដោយជោគជ័យ',
      'receipt_pref_save_failed': 'មិនអាចរក្សាទុកចំណូលចិត្តបាន',
      'receipt_pref_print_success': 'បានផ្ញើបង្កាន់ដៃសាកល្បងទៅម៉ាស៊ីនព្រីន',
      // ═══════════════════════════════════════════════════════════
      // Invite staff
      // ═══════════════════════════════════════════════════════════
      'invite_title': 'អញ្ជើញបុគ្គលិក',
      'invite_heading': 'បង្កើនក្រុមការងាររបស់អ្នក។',
      'invite_description':
          'អញ្ជើញសមាជិកបុគ្គលិកថ្មីឱ្យចូលរួមហាងរបស់អ្នក។ ពួកគេនឹងទទួលបានអ៊ីមែលដើម្បីរៀបចំគណនី។',
      'invite_email_label': 'អាសយដ្ឋានអ៊ីមែល',
      'invite_email_hint': 'name@example.com',
      'invite_role_label': 'តួនាទី',
      'invite_role_associate': 'អ្នកលក់',
      'invite_role_associate_sub': 'អាចលក់ និងគ្រប់គ្រងអតិថិជន',
      'invite_role_manager': 'អ្នកគ្រប់គ្រងហាង',
      'invite_role_manager_sub': 'សិទ្ធិពេញលេញលើមុខងារទាំងអស់',
      'invite_footer_note':
          'សមាជិកបុគ្គលិកថ្មីនឹងត្រូវផ្ទៀងផ្ទាត់អ៊ីមែល និងបង្កើតពាក្យសម្ងាត់ មុនពេលចូលប្រើហាង។',
      'invite_send_button': 'ផ្ញើការអញ្ជើញ',
      'invite_error_email': 'សូមបញ្ចូលអាសយដ្ឋានអ៊ីមែលត្រឹមត្រូវ',
      'invite_success': 'បានផ្ញើការអញ្ជើញដោយជោគជ័យ',
      'invite_failed': 'មិនអាចផ្ញើការអញ្ជើញបាន',
      // ═══════════════════════════════════════════════════════════
      // Manage staff
      // ═══════════════════════════════════════════════════════════
      'manage_staff_title': 'គ្រប់គ្រងបុគ្គលិក',
      'manage_staff_not_found': 'រកមិនឃើញសមាជិកបុគ្គលិក។',
      'manage_staff_name_label': 'ឈ្មោះពេញ',
      'manage_staff_email_label': 'អាសយដ្ឋានអ៊ីមែល',
      'manage_staff_role_label': 'តួនាទី',
      'manage_staff_role_associate': 'អ្នកលក់',
      'manage_staff_role_associate_sub': 'អាចលក់ និងគ្រប់គ្រងអតិថិជន',
      'manage_staff_role_manager': 'អ្នកគ្រប់គ្រងហាង',
      'manage_staff_role_manager_sub': 'សិទ្ធិពេញលេញលើមុខងារទាំងអស់',
      'manage_staff_active_title': 'សមាជិកបុគ្គលិកសកម្ម',
      'manage_staff_active_on': 'អាចចូល និងលក់',
      'manage_staff_active_off': 'មិនអាចចូល',
      'manage_staff_danger_header': 'តំបន់គ្រោះថ្នាក់',
      'manage_staff_remove_button': 'លុបសមាជិកបុគ្គលិក',
      'manage_staff_save_button': 'រក្សាទុកការផ្លាស់ប្តូរ',
      'manage_staff_update_success':
          'បានធ្វើបច្ចុប្បន្នភាពសមាជិកបុគ្គលិកដោយជោគជ័យ',
      'manage_staff_update_failed': 'មិនអាចធ្វើបច្ចុប្បន្នភាពសមាជិកបុគ្គលិកបាន',
      'manage_staff_remove_success': 'បានលុបសមាជិកបុគ្គលិក',
      'manage_staff_remove_failed': 'មិនអាចលុបសមាជិកបុគ្គលិកបាន',
      'manage_staff_dialog_title': 'លុបសមាជិកបុគ្គលិក?',
      'manage_staff_dialog_body':
          'តើអ្នកប្រាកដថាចង់លុប {name}? សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ។',
      'manage_staff_dialog_cancel': 'បោះបង់',
      'manage_staff_dialog_remove': 'លុប',
      // ═══════════════════════════════════════════════════════════
      // Store details
      // ═══════════════════════════════════════════════════════════
      'store_details_title': 'ព័ត៌មានលម្អិតហាង',
      'store_details_loading': 'កំពុងផ្ទុក...',
      'store_details_name_label': 'ឈ្មោះហាង',
      'store_details_street_label': 'អាសយដ្ឋានផ្លូវ',
      'store_details_city_label': 'ទីក្រុង',
      'store_details_zip_label': 'កូដតំបន់',
      'store_details_phone_label': 'ទូរស័ព្ទហាង',
      'store_details_currency_label': 'រូបិយប័ណ្ណ',
      'store_details_timezone_label': 'តំបន់ពេលវេលា',
      'store_details_info':
          'America/New_York · EST / EDT កែតម្រូវដោយស្វ័យប្រវត្តិ។ អាសយដ្ឋាន និងទូរស័ព្ទបង្ហាញនៅលើបង្កាន់ដៃ។',
      'store_details_manager_note':
          'មានតែអ្នកគ្រប់គ្រងហាងប៉ុណ្ណោះដែលអាចធ្វើបច្ចុប្បន្នភាពព័ត៌មានលម្អិតហាង។',
      'store_details_save_button': 'រក្សាទុកព័ត៌មានលម្អិតហាង',
      'store_details_cancel_button': 'បោះបង់ការផ្លាស់ប្តូរ',
      'store_details_save_success':
          'បានធ្វើបច្ចុប្បន្នភាពព័ត៌មានលម្អិតហាងដោយជោគជ័យ',
      'store_details_save_failed':
          'មិនអាចធ្វើបច្ចុប្បន្នភាពព័ត៌មានលម្អិតហាងបាន',
      // ═══════════════════════════════════════════════════════════
      // Taxes & discounts
      // ═══════════════════════════════════════════════════════════
      'taxes_title': 'ពន្ធ និងការបញ្ចុះតម្លៃ',
      'taxes_subtitle': '{store}',
      'taxes_store_default': 'ហាងសូហូ',
      'taxes_sales_tax': 'ពន្ធលក់',
      'taxes_sales_tax_hint':
          'បន្ថែមនៅពេលបង់ប្រាក់ បន្ទាប់ពីការបញ្ចុះតម្លៃលើការបញ្ជាទិញ។',
      'taxes_apply_tax_title': 'អនុវត្តពន្ធលក់',
      'taxes_apply_tax_sub': 'ផលិតផលជាប់ពន្ធទាំងអស់',
      'taxes_active_discounts': '{count} ការបញ្ចុះតម្លៃសកម្ម',
      'taxes_require_approval_title': 'ត្រូវការការអនុម័តលើស 20%',
      'taxes_require_approval_sub':
          'ការអនុម័តពីអ្នកគ្រប់គ្រងហាងសម្រាប់ការបញ្ចុះតម្លៃផ្ទាល់ខ្លួន',
      'taxes_create_button': 'បង្កើតការបញ្ចុះតម្លៃ',
      'taxes_footer_note':
          'ការបញ្ចុះតម្លៃមួយក្នុងមួយការលក់។ ការផ្លាស់ប្តូរអនុវត្តចំពោះតែការបង់ប្រាក់ថ្មីៗប៉ុណ្ណោះ។ បង្កាន់ដៃចាស់ៗមិនផ្លាស់ប្តូរទេ។',
      'taxes_save_button': 'រក្សាទុកការកំណត់',
      'taxes_save_success': 'បានរក្សាទុកការកំណត់ដោយជោគជ័យ',
      'taxes_save_failed': 'មិនអាចរក្សាទុកការកំណត់បាន',
      'taxes_edit_rate_title': 'អត្រាពន្ធលក់',
      'taxes_edit_rate_cancel': 'បោះបង់',
      'taxes_edit_rate_save': 'រក្សាទុក',
      'taxes_create_sheet_title': 'បង្កើតការបញ្ចុះតម្លៃ',
      'taxes_create_name_label': 'ឈ្មោះ',
      'taxes_create_value_label': 'តម្លៃ',
      'taxes_create_description_percentage':
          'បញ្ចុះ {value}% · លើការបញ្ជាទិញទាំងមូល',
      'taxes_create_description_fixed': 'បញ្ចុះ \${value}',
      'taxes_create_action': 'បង្កើត',
      'taxes_delete_dialog_title': 'លុបការបញ្ចុះតម្លៃ?',
      'taxes_delete_dialog_body': 'តើអ្នកប្រាកដថាចង់លុប "{name}"?',
      'taxes_delete_dialog_cancel': 'បោះបង់',
      'taxes_delete_dialog_delete': 'លុប',
      // ═══════════════════════════════════════════════════════════
      // Settings (Your store)
      // ═══════════════════════════════════════════════════════════
      'settings_title': 'ហាងរបស់អ្នក',
      'settings_loading': 'កំពុងផ្ទុក...',
      'settings_no_address': 'គ្មានអាសយដ្ឋានកំណត់',
      'settings_all_systems_online': 'ប្រព័ន្ធទាំងអស់ដំណើរការ',
      'settings_section_operations': 'ប្រតិបត្តិការហាង',
      'settings_section_preferences': 'ចំណូលចិត្ត',
      'settings_section_team': 'ក្រុមការងារ & គណនី',
      'settings_menu_store_details': 'ព័ត៌មានលម្អិតហាង',
      'settings_menu_store_details_sub': '{currency} · {timezone}',
      'settings_menu_taxes': 'ពន្ធ និងការបញ្ចុះតម្លៃ',
      'settings_menu_taxes_sub':
          'ពន្ធលក់ {rate}% · ការបញ្ចុះតម្លៃសកម្ម {count}',
      'settings_menu_receipt': 'ចំណូលចិត្តបង្កាន់ដៃ',
      'settings_menu_receipt_sub': 'ឡូហ្គោ ជើង និងបង្កាន់ដៃឌីជីថល',
      'settings_menu_devices': 'ឧបករណ៍ដែលបានភ្ជាប់',
      'settings_menu_devices_sub': 'Reader 01 · ម៉ាស៊ីនព្រីនបង្កាន់ដៃ',
      'settings_menu_theme': 'រូបរាង',
      'settings_menu_language': 'ភាសា',
      'settings_menu_staff': 'បុគ្គលិក និងសិទ្ធិ',
      'settings_menu_staff_sub': '{name} · {role}',
      'settings_menu_staff_name_fallback': 'Alex Morgan',
      'settings_menu_staff_role_fallback': 'អ្នកគ្រប់គ្រងហាង',
      'settings_menu_close_register': 'បិទគ្រឿងគិតលុយ',
      'settings_menu_close_register_open': 'គ្រឿងគិតលុយ 01 · បើកតាំងពី {time}',
      'settings_menu_close_register_closed': 'គ្មានគ្រឿងគិតលុយសកម្ម',
      'settings_menu_sign_out': 'ចាកចេញ',
      'settings_footer': 'fold POS · កំណែ {version} · ជំនួយ & ការគាំទ្រ',
      'settings_footer_version': '2.4.0',
      'settings_theme_light': 'ភ្លឺ',
      'settings_theme_dark': 'ងងឹត',
      'settings_theme_system': 'តាមប្រព័ន្ធ',
      'settings_theme_sheet_title': 'ជ្រើសរើសរូបរាង',
      'settings_language_sheet_title': 'ជ្រើសរើសភាសា',
      // ═══════════════════════════════════════════════════════════
      // Add customer
      // ═══════════════════════════════════════════════════════════
      'add_customer_title': 'អតិថិជនថ្មី',
      'add_customer_subtitle': 'បញ្ជីអតិថិជន',
      'add_customer_intro':
          'បង្កើតប្រវត្តិរូបសម្រាប់ការបង់ប្រាក់រហ័ស បង្កាន់ដៃឌីជីថល និងការស្វាគមន៍ផ្ទាល់ខ្លួនបន្ថែម។',
      'add_customer_first_name': 'នាមខ្លួន *',
      'add_customer_last_name': 'នាមត្រកូល *',
      'add_customer_email': 'អាសយដ្ឋានអ៊ីមែល *',
      'add_customer_phone': 'លេខទូរស័ព្ទ',
      'add_customer_note': 'កំណត់ចំណាំអតិថិជន',
      'add_customer_marketing_title': 'ផ្ញើព័ត៌មាន និងការផ្តល់ជូនពិសេស',
      'add_customer_marketing_sub':
          'មានតែដោយមានការអនុញ្ញាតពីអតិថិជនប៉ុណ្ណោះ។ ពួកគេអាចឈប់ទទួលបានគ្រប់ពេល។',
      'add_customer_privacy_info':
          'អ៊ីមែលត្រូវបានប្រើសម្រាប់បង្កាន់ដៃ មិនមែនសម្រាប់ទីផ្សារទេ លុះត្រាតែអតិថិជនជ្រើសរើស។',
      'add_customer_save_button': 'រក្សាទុកអតិថិជន & បន្ថែមទៅការលក់',
      'add_customer_privacy_note':
          'ព័ត៌មានលម្អិតអតិថិជននៅឯកជន និងមានសុវត្ថិភាព។',
      // ═══════════════════════════════════════════════════════════
      // Edit customer
      // ═══════════════════════════════════════════════════════════
      'edit_customer_title': 'កែប្រែអតិថិជន',
      'edit_customer_subtitle': '{name} · អតិថិជនតាំងពី {date}',
      'edit_customer_subtitle_date': 'មករា 2026',
      'edit_customer_loading': 'កំពុងផ្ទុក...',
      'edit_customer_first_name': 'នាមខ្លួន',
      'edit_customer_last_name': 'នាមត្រកូល',
      'edit_customer_email': 'អាសយដ្ឋានអ៊ីមែល',
      'edit_customer_phone': 'លេខទូរស័ព្ទ',
      'edit_customer_note': 'កំណត់ចំណាំអតិថិជន',
      'edit_customer_marketing_title': 'ទីផ្សារតាមអ៊ីមែល',
      'edit_customer_marketing_on': 'បានជាវ · អតិថិជនបានយល់ព្រម',
      'edit_customer_marketing_off': 'មិនបានជាវ · សួររកការយល់ព្រមជាមុន',
      'edit_customer_info_banner':
          'អ៊ីមែលបង្កាន់ដៃដាច់ដោយឡែកពីចំណូលចិត្តទីផ្សារ។',
      'edit_customer_footer_note':
          'ការផ្លាស់ប្តូរធ្វើបច្ចុប្បន្នភាពប្រវត្តិរូបអតិថិជន មិនមែនបង្កាន់ដៃចាស់ៗទេ។',
      'edit_customer_save_button': 'រក្សាទុកអតិថិជន',
      'edit_customer_cancel_button': 'បោះបង់ការផ្លាស់ប្តូរ',
      'edit_customer_update_success': 'បានធ្វើបច្ចុប្បន្នភាពអតិថិជនដោយជោគជ័យ',
      'edit_customer_update_failed': 'មិនអាចធ្វើបច្ចុប្បន្នភាពអតិថិជនបាន',
      // ═══════════════════════════════════════════════════════════
      // Notifications
      // ═══════════════════════════════════════════════════════════
      'notif_title': 'ការជូនដំណឹង',
      'notif_mark_all_read': 'សម្គាល់ទាំងអស់ថាបានអាន',
      'notif_empty': 'មិនទាន់មានការជូនដំណឹង។',
      'notif_time': '{hour}:{minute}',
      // ═══════════════════════════════════════════════════════════
      // Scan barcode
      // ═══════════════════════════════════════════════════════════
      'scan_title': 'ស្កេនបាកូដ',
      'scan_subtitle': '{mode} · {register}',
      'scan_mode_sell': 'ការលក់ថ្មី',
      'scan_register_default': 'គ្រឿងគិតលុយ 01',
      'scan_instructions': 'ដាក់បាកូដក្នុងស៊ុម',
      'scan_manual_label': 'ឬបញ្ចូលបាកូដ / SKU ដោយដៃ',
      'scan_manual_hint': 'CT-WHT-M',
      'scan_find_button': 'រកផលិតផល',
      'scan_back_button': 'ត្រឡប់ទៅកាតាឡុក',
      'scan_error_no_barcode': 'រកមិនឃើញផលិតផលសម្រាប់បាកូដ: {code}',
      'scan_error_no_sku': 'រកមិនឃើញផលិតផលដែលមាន SKU នេះ',
      // ═══════════════════════════════════════════════════════════
      // Receipt (post-sale)
      // ═══════════════════════════════════════════════════════════
      'receipt_title': 'បង្កាន់ដៃ',
      'receipt_subtitle': '{orderNumber} · ការទូទាត់កាតជម្មើស',
      'receipt_not_found': 'រកមិនឃើញការបញ្ជាទិញ',
      'receipt_store_address': 'សូហូ · 120 Spring St, New York',
      'receipt_store_date_register': '{date} · គ្រឿងគិតលុយ 01',
      'receipt_customer_line': 'បង្កាន់ដៃ {orderNumber} · {customer}',
      'receipt_guest': 'ភ្ញៀវ',
      'receipt_item_line': '{quantity} × {name}',
      'receipt_item_variant': '{color} / {size} · \${price} ក្នុងមួយ',
      'receipt_item_default_name': 'ទំនិញ',
      'receipt_subtotal': 'សរុបរង',
      'receipt_discount': 'ការបញ្ចុះតម្លៃស្វាគមន៍ · 10%',
      'receipt_sales_tax': 'ពន្ធលក់ · 10%',
      'receipt_total_paid': 'សរុបបានបង់',
      'receipt_card_line': '{brand} **** {last4}',
      'receipt_approved_auth': 'បានអនុម័ត · Auth {auth}',
      'receipt_thank_you': 'សូមអរគុណសម្រាប់ការទិញទំនិញជាមួយ fold។',
      'receipt_delivered_banner': 'បង្កាន់ដៃបានផ្ញើទៅ {email}។',
      'receipt_customer_fallback': 'អតិថិជន',
      'receipt_send_again': 'ផ្ញើម្តងទៀត',
      'receipt_sending_again': 'កំពុងផ្ញើម្តងទៀត...',
      'receipt_change_email': 'ប្តូរអាសយដ្ឋានអ៊ីមែល',
      'receipt_print_button': 'ព្រីនបង្កាន់ដៃ',
      'receipt_printing': 'កំពុងព្រីនបង្កាន់ដៃ...',
      'receipt_done_button': 'រួចរាល់',
      // ═══════════════════════════════════════════════════════════
      // Refund complete
      // ═══════════════════════════════════════════════════════════
      'refund_complete_title': 'ការសងប្រាក់វិញបានបញ្ចប់',
      'refund_complete_no_order': 'គ្មានទិន្នន័យការបញ្ជាទិញ។',
      'refund_complete_cash_refunded': 'សងប្រាក់ជាសាច់ប្រាក់វិញ',
      'refund_complete_partially_refunded': 'សងប្រាក់វិញមួយផ្នែក',
      'refund_complete_original_order': 'ការបញ្ជាទិញដើម',
      'refund_complete_reference': 'លេខយោងសងប្រាក់វិញ',
      'refund_complete_method': 'វិធីសងប្រាក់វិញ',
      'refund_complete_method_cash': 'សាច់ប្រាក់',
      'refund_complete_datetime': 'កាលបរិច្ឆេទ & ពេលវេលា',
      'refund_complete_datetime_value': '{date} · {time}',
      'refund_complete_original_total': 'សរុបដើម',
      'refund_complete_amount_refunded': 'ចំនួនទឹកប្រាក់បានសងវិញ',
      'refund_complete_net_sale': 'ការលក់សុទ្ធ',
      'refund_complete_send_receipt': 'ផ្ញើបង្កាន់ដៃដែលបានធ្វើបច្ចុប្បន្នភាព',
      'refund_complete_back_sales': 'ត្រឡប់ទៅការលក់',
      // ═══════════════════════════════════════════════════════════
      // Return / refund
      // ═══════════════════════════════════════════════════════════
      'return_refund_title': 'ត្រឡប់ទំនិញ',
      'return_refund_subtitle': 'ការបញ្ជាទិញ {orderNumber}',
      'return_refund_not_found': 'រកមិនឃើញការបញ្ជាទិញ',
      'return_refund_intro':
          'ជ្រើសរើសទំនិញដែលត្រឡប់មកវិញ។ ការបញ្ចុះតម្លៃ និងពន្ធត្រូវបានរាប់បញ្ចូលក្នុងការសងប្រាក់វិញ។',
      'return_refund_item_unknown': 'ផលិតផលមិនស្គាល់',
      'return_refund_item_variant': '{color} / {size} · បានទិញ {qty}',
      'return_refund_item_qty_only': 'បានទិញ {qty}',
      'return_refund_item_price': '\${price} ក្នុងមួយ',
      'return_refund_item_fully_returned': 'បានត្រឡប់ទាំងអស់',
      'return_refund_item_already_returned': 'បានត្រឡប់រួច {qty}',
      'return_refund_reason_label': 'មូលហេតុត្រឡប់',
      'return_refund_reason_default': 'ទំហំមិនត្រូវ',
      'return_refund_restock_title': 'ត្រឡប់ទៅស្តុកដែលអាចរកបាន',
      'return_refund_restock_sub': 'ទំនិញនឹងត្រូវបានបន្ថែមត្រឡប់ទៅស្តុកវិញ',
      'return_refund_summary_title': 'សេចក្តីសង្ខេបការសងប្រាក់វិញ',
      'return_refund_summary_subtotal': 'សរុបរង',
      'return_refund_summary_discount': 'ការបញ្ចុះតម្លៃដើម',
      'return_refund_summary_tax': 'ពន្ធដែលបានត្រឡប់',
      'return_refund_summary_total': 'សងប្រាក់ជាសាច់ប្រាក់វិញ',
      'return_refund_payment_note':
          'ការទូទាត់ដើម: សាច់ប្រាក់ · មានសិទ្ធិត្រឡប់រហូតដល់ {date}។',
      'return_refund_payment_note_date': '18 វិច្ឆិកា',
      'return_refund_action': 'សងប្រាក់វិញ \${amount} ជាសាច់ប្រាក់',
      'return_refund_footer':
          'បញ្ជាក់តែបន្ទាប់ពីប្រគល់ប្រាក់សាច់ប្រាក់ជូនអតិថិជនរួចប៉ុណ្ណោះ។',
      'return_refund_error_no_selection':
          'សូមជ្រើសរើសទំនិញយ៉ាងហោចណាស់មួយដើម្បីត្រឡប់។',
      // ═══════════════════════════════════════════════════════════
      // Transaction detail
      // ═══════════════════════════════════════════════════════════
      'txn_detail_title': 'ការបញ្ជាទិញ {orderNumber}',
      'txn_detail_subtitle': '{date} · {time}',
      'txn_detail_not_found': 'រកមិនឃើញការបញ្ជាទិញ។',
      'txn_detail_status_fully_refunded': 'សងប្រាក់វិញពេញលេញ',
      'txn_detail_status_partially_refunded': 'សងប្រាក់វិញមួយផ្នែក',
      'txn_detail_status_completed': 'បានបញ្ចប់',
      'txn_detail_sold_by': 'លក់ដោយ {name} · {register}',
      'txn_detail_cashier_default': 'Alex',
      'txn_detail_register_default': 'គ្រឿងគិតលុយ 01',
      'txn_detail_customer_guest': 'អតិថិជនភ្ញៀវ',
      'txn_detail_customer_no_email': 'គ្មានអ៊ីមែល',
      'txn_detail_no_items': 'គ្មានទំនិញក្នុងការបញ្ជាទិញនេះ',
      'txn_detail_item_unknown_variant': 'វ៉ារ្យ៉ង់មិនស្គាល់',
      'txn_detail_item_variant': '{color} / {size} · ចំនួន {qty}',
      'txn_detail_item_qty': 'ចំនួន {qty}',
      'txn_detail_item_refunded': 'បានសងវិញ',
      'txn_detail_item_returned_qty': 'បានត្រឡប់: {qty}',
      'txn_detail_subtotal': 'សរុបរង · {count} ទំនិញ',
      'txn_detail_discount': 'ការបញ្ចុះតម្លៃស្វាគមន៍ · 10%',
      'txn_detail_tax': 'ពន្ធលក់ · 10%',
      'txn_detail_refunded_amount': 'ចំនួនបានសងវិញ',
      'txn_detail_net_total': 'សរុបសុទ្ធ',
      'txn_detail_payment_details': 'ព័ត៌មានលម្អិតការទូទាត់',
      'txn_detail_total_paid': 'សរុបបានបង់',
      'txn_detail_refunded_to_customer': 'សងវិញដល់អតិថិជន',
      'txn_detail_receipt_sent': 'បង្កាន់ដៃបានផ្ញើទៅ {email}',
      'txn_detail_return_button': 'ត្រឡប់ទំនិញ',
      'txn_detail_view_receipt_button': 'មើលបង្កាន់ដៃ',
      // ═══════════════════════════════════════════════════════════
      // Manage stock
      // ═══════════════════════════════════════════════════════════
      'manage_stock_title': 'គ្រប់គ្រងស្តុក',
      'manage_stock_store_default': 'ហាងសូហូ',
      'manage_stock_product_units': '{units} គ្រឿង · {variants} វ៉ារ្យ៉ង់',
      'manage_stock_view_details': 'មើលព័ត៌មានលម្អិតផលិតផល',
      'manage_stock_stock_by_variant': 'ស្តុកតាមវ៉ារ្យ៉ង់',
      'manage_stock_add_button': 'បន្ថែម',
      'manage_stock_size_default': 'M',
      'manage_stock_color_default': 'ស',
      'manage_stock_sku_default': 'CT-WHT-M',
      'manage_stock_product_default': 'អាវកប្បាសធម្មតា',
      'manage_stock_update_title':
          'ធ្វើបច្ចុប្បន្នភាព {size} · {color} / {size}',
      'manage_stock_update_sku': 'SKU {sku} · បច្ចុប្បន្នមាន {count} គ្រឿង',
      'manage_stock_action_add': 'បន្ថែមស្តុក',
      'manage_stock_action_remove': 'ដកចេញ',
      'manage_stock_action_set': 'កំណត់ចំនួន',
      'manage_stock_quantity_label': 'ចំនួន',
      'manage_stock_reason_label': 'មូលហេតុ',
      'manage_stock_reason_default': 'ទទួលបានស្តុក',
      'manage_stock_note_label': 'ចំណាំយោង',
      'manage_stock_note_default': 'ការដឹកជញ្ជូន PO-0246',
      'manage_stock_current_available': 'មានបច្ចុប្បន្ន',
      'manage_stock_current_units': '{count} គ្រឿង',
      'manage_stock_after_update': 'បន្ទាប់ពីធ្វើបច្ចុប្បន្នភាព',
      'manage_stock_after_units': '{count} គ្រឿង',
      'manage_stock_last_movement':
          'ចលនាចុងក្រោយ: {change} · {orderNumber} · {time}',
      'manage_stock_last_movement_change': '+{count} ត្រឡប់',
      'manage_stock_last_movement_order': '#1048',
      'manage_stock_last_movement_time': 'ថ្ងៃនេះ 10:08 ព្រឹក',
      'manage_stock_save_button':
          'រក្សាទុកការធ្វើបច្ចុប្បន្នភាព · {change} គ្រឿង',
      'manage_stock_save_change_positive': '+{count}',
      'manage_stock_save_change_negative': '{count}',
      'manage_stock_update_success': 'បានធ្វើបច្ចុប្បន្នភាពស្តុកដោយជោគជ័យ',
      'manage_stock_add_variant_title': 'បន្ថែមវ៉ារ្យ៉ង់ថ្មី',
      'manage_stock_color_label': 'ពណ៌',
      'manage_stock_color_default_input': 'ស',
      'manage_stock_size_label': 'ទំហំ',
      'manage_stock_sku_label': 'SKU',
      'manage_stock_price_label': 'តម្លៃ',
      'manage_stock_initial_stock_label': 'ស្តុកដំបូង',
      'manage_stock_save_variant_button': 'រក្សាទុកវ៉ារ្យ៉ង់',
      'manage_stock_add_variant_error': 'សូមបំពេញពណ៌ និង SKU',
      'manage_stock_add_variant_failed': 'មិនអាចបង្កើតវ៉ារ្យ៉ង់បាន',
      // ═══════════════════════════════════════════════════════════
      // Sale filters (date range)
      // ═══════════════════════════════════════════════════════════
      'sale_filter_title': 'ត្រងការលក់',
      'sale_filter_store_default': 'ហាងសូហូ',
      'sale_filter_date_range_title': 'ជួរកាលបរិច្ឆេទ',
      'sale_filter_range_today': 'ថ្ងៃនេះ',
      'sale_filter_range_yesterday': 'ម្សិលមិញ',
      'sale_filter_range_week': 'សប្តាហ៍នេះ',
      'sale_filter_range_custom': 'ផ្ទាល់ខ្លួន',
      'sale_filter_from_label': 'ពី',
      'sale_filter_to_label': 'ដល់',
      'sale_filter_date_note': 'រួមបញ្ចូលថ្ងៃពេញ · ម៉ោងហាងញូវយ៉ក',
      'sale_filter_status_title': 'ស្ថានភាពការលក់',
      'sale_filter_status_all': 'ការលក់ទាំងអស់',
      'sale_filter_status_completed': 'បានបញ្ចប់',
      'sale_filter_status_refunded': 'បានសងប្រាក់វិញ',
      'sale_filter_status_note':
          'ការលក់ទាំងអស់រួមបញ្ចូលប្រតិបត្តិការដែលបានសងប្រាក់វិញមួយផ្នែក។',
      'sale_filter_method_title': 'វិធីទូទាត់',
      'sale_filter_method_all': 'វិធីទាំងអស់',
      'sale_filter_method_cash': 'សាច់ប្រាក់',
      'sale_filter_method_card': 'កាត',
      'sale_filter_staff_label': 'សមាជិកបុគ្គលិក',
      'sale_filter_staff_all': 'បុគ្គលិកទាំងអស់',
      'sale_filter_info_banner':
          'រូបភាពថ្ងៃទី 19 តុលា បន្ទាប់ពីការសងប្រាក់វិញ #RF-0108: ការលក់សុទ្ធ \$1,941.50 ក្នុង 25 ប្រតិបត្តិការ។',
      'sale_filter_show_button': 'បង្ហាញ {count} ប្រតិបត្តិការ',
      'sale_filter_reset_button': 'កំណត់តម្រងឡើងវិញ',
      'sale_filter_month_jan': 'មករា',
      'sale_filter_month_feb': 'កុម្ភៈ',
      'sale_filter_month_mar': 'មីនា',
      'sale_filter_month_apr': 'មេសា',
      'sale_filter_month_may': 'ឧសភា',
      'sale_filter_month_jun': 'មិថុនា',
      'sale_filter_month_jul': 'កក្កដា',
      'sale_filter_month_aug': 'សីហា',
      'sale_filter_month_sep': 'កញ្ញា',
      'sale_filter_month_oct': 'តុលា',
      'sale_filter_month_nov': 'វិច្ឆិកា',
      'sale_filter_month_dec': 'ធ្នូ',
      'sale_filter_date_format': '{day} {month}, {year}',
      // ═══════════════════════════════════════════════════════════
      // Sales list
      // ═══════════════════════════════════════════════════════════
      'sales_title': 'ការលក់',
      'sales_search_hint': 'ស្វែងរកការបញ្ជាទិញ ឬអតិថិជន',
      'sales_filter_all': 'ការលក់ទាំងអស់',
      'sales_filter_completed': 'បានបញ្ចប់',
      'sales_filter_refunded': 'បានសងប្រាក់វិញ',
      'sales_date_today': 'ថ្ងៃនេះ · 19 តុលា 2026',
      'sales_summary_net': 'ការលក់សុទ្ធ',
      'sales_summary_transactions': 'ប្រតិបត្តិការ',
      'sales_section_header': 'ថ្ងៃនេះ · {count} ប្រតិបត្តិការ',
      'sales_empty': 'រកមិនឃើញប្រតិបត្តិការ។',
      'sales_guest_first': 'ភ្ញៀវ',
      'sales_guest_last': 'អតិថិជន',
      'sales_guest_full': 'អតិថិជនភ្ញៀវ',
      'sales_status_fully_refunded': 'សងប្រាក់វិញពេញលេញ',
      'sales_status_partially_refunded': 'សងប្រាក់វិញមួយផ្នែក',
      'sales_status_completed': 'បានបញ្ចប់',
      'sales_item_was': 'ពីមុន \${amount}',
      'sales_item_time_payment': '{time} · បង់ប្រាក់តាមកាត',
      'customer_select_title': 'បន្ថែមអតិថិជន',
      'customer_search_hint': 'ស្វែងរកតាមឈ្មោះ អ៊ីមែល ឬទូរស័ព្ទ',
      'customer_matching_count': '{count} អតិថិជនត្រូវគ្នា',
      'customer_new_button': '+ អតិថិជនថ្មី',
      'customer_no_results': 'រកមិនឃើញអតិថិជន។',
      'customer_insight_title': 'ការយល់ដឹងអំពីអតិថិជន',
      'customer_insight_familiar': 'មុខដែលធ្លាប់ឃើញ។ បទពិសោធន៍កាន់តែប្រសើរ។',
      'customer_insight_welcome': 'សូមស្វាគមន៍ត្រឡប់មកវិញ។',
      'customer_insight_spent': '{name} បានចំណាយ \${amount} ជាមួយហាងរបស់អ្នក។',
      'customer_use_button': 'ប្រើ {name}',
      'customer_select_prompt': 'ជ្រើសរើសអតិថិជន',
      'customer_continue_guest': 'បន្តជាភ្ញៀវ',
      // ═══════════════════════════════════════════════════════════
      // Card payment decline
      // ═══════════════════════════════════════════════════════════
      'card_decline_title': 'ការទូទាត់តាមកាត',
      'card_decline_subtitle': '{orderId} · ស្ថានភាពបង់ប្រាក់ជម្មើស',
      'card_decline_heading': 'កាតត្រូវបានបដិសេធ។',
      'card_decline_description':
          'ធនាគារមិនបានអនុម័តការទូទាត់នេះទេ។ សូមសួរ {customerName} ឱ្យព្យាយាមម្តងទៀត ឬប្រើកាតផ្សេង។',
      'card_decline_still_to_pay': 'នៅត្រូវបង់',
      'card_decline_card_attempted': 'កាតដែលបានព្យាយាម',
      'card_decline_customer': 'អតិថិជន',
      'card_decline_status': 'ស្ថានភាពការទូទាត់',
      'card_decline_status_unpaid': 'មិនបានបង់',
      'card_decline_reader': 'ម៉ាស៊ីនអាន',
      'card_decline_reader_default': 'ម៉ាស៊ីនអាន 01',
      'card_decline_warning':
          'មិនបានកាត់ប្រាក់ទេ។ ការលក់នេះមិនទាន់បានបញ្ចប់ ហើយស្តុកមិនបានផ្លាស់ប្តូរទេ។',
      'card_decline_footer':
          'ជម្មើសសម្រាប់ការបង់ប្រាក់ជាសាច់ប្រាក់សម្រាប់ {orderId} មិនមែនជាការគិតថ្លៃទីពីរទេ។',
      'card_decline_retry_button': 'ព្យាយាមបង់ប្រាក់តាមកាតម្តងទៀត',
      'card_decline_choose_other_button': 'ជ្រើសរើសវិធីផ្សេង',
      // ═══════════════════════════════════════════════════════════
      // Card payment
      // ═══════════════════════════════════════════════════════════
      'card_payment_title': 'ការទូទាត់តាមកាត',
      'card_payment_subtitle_customer': 'សម្រាប់ {name} · ការទូទាត់ជម្មើស',
      'card_payment_subtitle_generic': 'ការទូទាត់ជម្មើស',
      'card_payment_reader_connected': 'ម៉ាស៊ីនអានបានភ្ជាប់',
      'card_payment_total_due': 'សរុបត្រូវបង់',
      'card_payment_tap_to_pay': 'ប៉ះដើម្បីបង់ប្រាក់',
      'card_payment_processing': 'កំពុងដំណើរការ...',
      'card_payment_ready': 'រួចរាល់នៅពេលពួកគេរួចរាល់។',
      'card_payment_instruction_named':
          'សួរ {name} ឱ្យប៉ះ បញ្ចូល ឬអូសកាតរបស់ពួកគេនៅលើម៉ាស៊ីនអាន។',
      'card_payment_instruction_generic':
          'សួរអតិថិជនឱ្យប៉ះ បញ្ចូល ឬអូសកាតរបស់ពួកគេនៅលើម៉ាស៊ីនអាន។',
      'card_payment_processing_payment': 'កំពុងដំណើរការការទូទាត់...',
      'card_payment_waiting_card': 'កំពុងរង់ចាំកាត...',
      'card_payment_reader_label': 'ម៉ាស៊ីនអាន',
      'card_payment_reader_name': 'Fold Reader · 01',
      'card_payment_accepted_cards':
          'ទទួលយក Visa, Mastercard, Amex, Apple Pay និង Google Pay។',
      'card_payment_simulate_button': 'ក្លែងធ្វើការប៉ះកាត · \${amount}',
      'card_payment_cancel_button': 'បោះបង់ & ជ្រើសរើសវិធីផ្សេង',
      'card_payment_footer': 'កុំបិទអេក្រង់នេះខណៈពេលការទូទាត់កំពុងដំណើរការ។',
      'card_payment_failed': 'ការទូទាត់បរាជ័យ',
      // ═══════════════════════════════════════════════════════════
      // Cash payment
      // ═══════════════════════════════════════════════════════════
      'cash_payment_title': 'ការទូទាត់ជាសាច់ប្រាក់',
      'cash_payment_subtitle_customer': 'សម្រាប់ {name}',
      'cash_payment_subtitle_guest': 'អតិថិជនភ្ញៀវ',
      'cash_payment_total_due': 'សរុបត្រូវបង់',
      'cash_payment_cash_received': 'ប្រាក់សាច់ប្រាក់ទទួលបាន',
      'cash_payment_quick_exact': 'ចំនួនត្រូវគ្នា',
      'cash_payment_change_title': 'ប្រាក់អាប់ត្រូវផ្តល់',
      'cash_payment_insufficient_title': 'ប្រាក់មិនគ្រប់',
      'cash_payment_hand_change_named':
          'ផ្តល់ប្រាក់អាប់ដល់ {name} មុនពេលបញ្ចប់។',
      'cash_payment_hand_change_generic':
          'ផ្តល់ប្រាក់អាប់ដល់អតិថិជន មុនពេលបញ្ចប់។',
      'cash_payment_insufficient_hint': 'អតិថិជនត្រូវបង់បន្ថែម។',
      'cash_payment_complete_button': 'បញ្ចប់ការលក់ · \${amount}',
      'cash_payment_failed': 'ការទូទាត់បរាជ័យ',
      // ═══════════════════════════════════════════════════════════
      // Checkout
      // ═══════════════════════════════════════════════════════════
      'checkout_guard_title': 'គ្មានគ្រឿងគិតលុយបើក',
      'checkout_guard_hint': 'អ្នកត្រូវបើកគ្រឿងគិតលុយ មុនពេលបញ្ចប់ការលក់នេះ។',
      'checkout_guard_button': 'បើកគ្រឿងគិតលុយ',
      'checkout_title': 'ការបង់ប្រាក់',
      'checkout_subtitle': '{count} ទំនិញ · ការលក់ថ្មី',
      'checkout_guest_customer': 'អតិថិជនភ្ញៀវ',
      'checkout_no_email': 'គ្មានអ៊ីមែលភ្ជាប់',
      'checkout_order_summary': 'សេចក្តីសង្ខេបការបញ្ជាទិញ',
      'checkout_edit_cart': 'កែប្រែកន្ត្រក',
      'checkout_item_line': '{quantity} × {name}',
      'checkout_subtotal': 'សរុបរង · {count} ទំនិញ',
      'checkout_discount_percentage': '{name} · {value}%',
      'checkout_discount_fixed': '{name}',
      'checkout_tax': 'ពន្ធលក់ · 10%',
      'checkout_total_due': 'សរុបត្រូវបង់',
      'checkout_payment_question': 'តើពួកគេចង់បង់ប្រាក់ដោយវិធីណា?',
      'checkout_pay_cash': 'សាច់ប្រាក់',
      'checkout_pay_cash_sub': 'ទទួលប្រាក់សាច់ប្រាក់ & គណនាប្រាក់អាប់',
      'checkout_pay_card': 'កាត',
      'checkout_pay_card_sub': 'ប៉ះ បញ្ចូល ឬអូស',
      'checkout_pay_khqr': 'KHQR',
      'checkout_pay_khqr_sub': 'ស្កេនកូដ QR តាមកម្មវិធីធនាគារ',
      'checkout_guest_name': 'ភ្ញៀវ',
      'checkout_continue_button': 'បន្តជាមួយ {method} · \${amount}',
      'checkout_continue_button_cash': 'បន្តជាមួយសាច់ប្រាក់ · \${amount}',
      'checkout_continue_button_card': 'បន្តជាមួយកាត · \${amount}',
      'checkout_continue_button_khqr': 'បន្តជាមួយ KHQR · \${amount}',
      'checkout_footer':
          'ស្តុកធ្វើបច្ចុប្បន្នភាពដោយស្វ័យប្រវត្តិ បន្ទាប់ពីការទូទាត់។',
      // ═══════════════════════════════════════════════════════════
      // KHQR extra (generic)
      // ═══════════════════════════════════════════════════════════
      'qr_expires_in': 'QR ផុតកំណត់ក្នុង',
      'waiting_for_payment': 'កំពុងរង់ចាំការទូទាត់…',
      'qr_expired': 'QR ផុតកំណត់',
      'generate_new_qr': 'បង្កើត QR ថ្មី',
      'payment_successful': 'ការទូទាត់ជោគជ័យ',
      'something_went_wrong': 'មានបញ្ហាកើតឡើង',
      'unable_to_verify_payment': 'មិនអាចផ្ទៀងផ្ទាត់ការទូទាត់បាន',
      'done': 'រួចរាល់',
      'close': 'បិទ',
      // ═══════════════════════════════════════════════════════════
      // Sale complete
      // ═══════════════════════════════════════════════════════════
      'sale_complete_title': 'ការលក់បានបញ្ចប់',
      'sale_complete_heading': 'បានបញ្ចប់ទាំងអស់។',
      'sale_complete_confirmed_at': 'ការទូទាត់បានបញ្ជាក់នៅ {time}',
      'sale_complete_paid_in': 'បានបង់ដោយ {method}',
      'sale_complete_method_cash': 'សាច់ប្រាក់',
      'sale_complete_method_card': 'កាត',
      'sale_complete_method_khqr': 'KHQR',
      'sale_complete_cash_received': 'ប្រាក់សាច់ប្រាក់ទទួលបាន',
      'sale_complete_change_given': 'ប្រាក់អាប់បានផ្តល់',
      'sale_complete_customer': 'អតិថិជន',
      'sale_complete_guest': 'អតិថិជនភ្ញៀវ',
      'sale_complete_items_sold': 'ទំនិញលក់ចេញ',
      'sale_complete_items_count': '{count} ទំនិញ',
      'sale_complete_send_receipt': 'ផ្ញើបង្កាន់ដៃរបស់ពួកគេ',
      'sale_complete_email_label': 'បង្កាន់ដៃតាមអ៊ីមែល',
      'sale_complete_send_button': 'ផ្ញើបង្កាន់ដៃតាមអ៊ីមែល',
      'sale_complete_sent_toast': 'បានផ្ញើបង្កាន់ដៃទៅ {email}',
      'sale_complete_print_button': 'ព្រីនបង្កាន់ដៃ',
      'sale_complete_share_button': 'ចែករំលែកបង្កាន់ដៃ',
      'sale_complete_start_new': 'ចាប់ផ្តើមការលក់ថ្មី',
      'sale_complete_view_txn': 'មើលប្រតិបត្តិការ',
      // ═══════════════════════════════════════════════════════════
      // Order note
      // ═══════════════════════════════════════════════════════════
      'order_note_title': 'កំណត់ចំណាំការបញ្ជាទិញ',
      'order_note_customer_guest': 'អតិថិជនភ្ញៀវ',
      'order_note_heading': 'ព័ត៌មានលម្អិតដែលសំខាន់។',
      'order_note_description':
          'ទុកកំណត់ចំណាំដែលមានប្រយោជន៍សម្រាប់ក្រុមការងារ។ សូមរក្សាព័ត៌មានទូទាត់ និងព័ត៌មានសំខាន់ៗផ្សេងទៀតឱ្យនៅក្រៅកំណត់ចំណាំ។',
      'order_note_label': 'កំណត់ចំណាំ',
      'order_note_include_title': 'រួមបញ្ចូលកំណត់ចំណាំលើបង្កាន់ដៃ',
      'order_note_include_on': 'បើក · អតិថិជននឹងឃើញកំណត់ចំណាំនេះ',
      'order_note_include_off': 'បិទ · មើលឃើញតែដោយបុគ្គលិកហាង',
      'order_note_added_by': 'បន្ថែមដោយ',
      'order_note_added_by_name': 'Alex Morgan',
      'order_note_visibility': 'ភាពមើលឃើញ',
      'order_note_visibility_customer': 'បង្កាន់ដៃអតិថិជន',
      'order_note_visibility_internal': 'ផ្ទៃក្នុងតែប៉ុណ្ណោះ',
      'order_note_save_button': 'រក្សាទុកកំណត់ចំណាំ',
      'order_note_cancel_button': 'បោះបង់ការផ្លាស់ប្តូរ',
      // ═══════════════════════════════════════════════════════════
      // Product detail
      // ═══════════════════════════════════════════════════════════
      'product_detail_title': 'ព័ត៌មានលម្អិតផលិតផល',
      'product_detail_not_found': 'រកមិនឃើញផលិតផល។',
      'product_detail_in_stock': 'មានស្តុក',
      'product_detail_out_of_stock': 'អស់ស្តុក',
      'product_detail_sku': 'SKU {sku}',
      'product_detail_sku_na': 'N/A',
      'product_detail_color': 'ពណ៌ · {color}',
      'product_detail_size': 'ទំហំ · {size}',
      'product_detail_stock_available': 'មាន {count} នៅ {store}',
      'product_detail_store_default': 'សូហូ',
      'product_detail_quantity': 'ចំនួន',
      'product_detail_add_button': 'បន្ថែម {count} ទៅកន្ត្រក · \${amount}',
      'product_detail_error_select_variant': 'សូមជ្រើសរើសវ៉ារ្យ៉ង់',
      'product_detail_error_out_of_stock': 'អស់ស្តុក',
      'product_detail_error_not_enough': 'មានតែ {count} គ្រឿងប៉ុណ្ណោះ',
      'product_detail_added_toast': 'បានបន្ថែមទៅកន្ត្រក',
      'product_detail_failed_add': 'មិនអាចបន្ថែមទៅកន្ត្រកបាន',
      // ═══════════════════════════════════════════════════════════
      // Product filter
      // ═══════════════════════════════════════════════════════════
      'product_filter_title': 'តម្រងផលិតផល',
      'product_filter_subtitle': 'ចម្រាញ់កាតាឡុក',
      'product_filter_category_title': 'ប្រភេទ',
      'product_filter_size_title': 'ទំហំ',
      'product_filter_color_title': 'ពណ៌',
      'product_filter_price_title': 'ជួរតម្លៃ',
      'product_filter_price_min': 'អប្បបរមា',
      'product_filter_price_max': 'អតិបរមា',
      'product_filter_instock_title': 'ផលិតផលដែលមានស្តុកតែប៉ុណ្ណោះ',
      'product_filter_instock_sub': 'លាក់វ៉ារ្យ៉ង់ដែលមិនមាននៅ {store}',
      'product_filter_store_default': 'សូហូ',
      'product_filter_footer':
          'តម្រងអនុវត្តចំពោះការស្វែងរកបច្ចុប្បន្ន។ តម្លៃគឺមុនពន្ធ។',
      'product_filter_apply_button': 'បង្ហាញ {count} ផលិតផលត្រូវគ្នា',
      'product_filter_clear_button': 'សម្អាតតម្រងទាំងអស់',
      // Category chip labels
      'product_filter_cat_all': 'ទាំងអស់',
      'product_filter_cat_tops': 'អាវ',
      'product_filter_cat_bottoms': 'ខោ',
      'product_filter_cat_knitwear': 'សម្លៀកបំពាក់ប៉ាក់',
      'product_filter_cat_classics': 'បុរាណ',
      // Color chip labels
      'product_filter_color_any': 'ពណ៌ណាមួយ',
      'product_filter_color_white': 'ស',
      'product_filter_color_sky': 'មេឃ',
      'product_filter_color_navy': 'ទឹកប៊ិច',
      'product_filter_color_sand': 'ខ្សាច់',
      // ═══════════════════════════════════════════════════════════
      // Search products
      // ═══════════════════════════════════════════════════════════
      'search_products_title': 'ស្វែងរកផលិតផល',
      'search_products_subtitle': '{store} · មុនការបញ្ជាទិញ {orderNumber}',
      'search_products_store_default': 'ហាងសូហូ',
      'search_products_order_default': '#1048',
      'search_products_label': 'ស្វែងរកផលិតផល ឬ SKU',
      'search_products_hint': 'ស្វែងរកផលិតផល ឬស្កេនបាកូដ',
      'search_products_results': '{count} លទ្ធផល',
      'search_products_results_for': '{count} លទ្ធផលសម្រាប់ "{query}"',
      'search_products_filters': 'តម្រង',
      'search_products_empty': 'រកមិនឃើញផលិតផលសម្រាប់ "{query}"។',
      'search_products_match_note': 'ត្រូវគ្នានឹងឈ្មោះផលិតផល សម្ភារៈ និង SKU។',
      'search_products_no_variants': 'គ្មានវ៉ារ្យ៉ង់',
      'search_products_variant_line': '{color} / {size} · {sku}',
      'search_products_stock_available': '· មាន {count}',
      // ═══════════════════════════════════════════════════════════
      // Sell screen
      // ═══════════════════════════════════════════════════════════
      'sell_guard_title': 'គ្មានគ្រឿងគិតលុយបើក',
      'sell_guard_hint': 'អ្នកត្រូវបើកគ្រឿងគិតលុយ មុនពេលចាប់ផ្តើមការលក់ថ្មី។',
      'sell_guard_button': 'បើកគ្រឿងគិតលុយ',
      'sell_title_new': 'ការលក់ថ្មី',
      'sell_title_selected': 'បានជ្រើសរើស {count}',
      'sell_subtitle_store_register': '{store} · {register}',
      'sell_store_default': 'ហាងសូហូ',
      'sell_register_default': 'គ្រឿងគិតលុយ 01',
      'sell_subtitle_selection_hint': 'ចុចឱ្យជាប់រួចហើយ · ប៉ះដើម្បីបិទ/បើក',
      'sell_select_all': 'ជ្រើសរើសទាំងអស់',
      'sell_search_hint': 'ស្វែងរកផលិតផល ឬស្កេនបាកូដ',
      'sell_error_load': 'មិនអាចផ្ទុកផលិតផលបាន: {error}',
      'sell_cancel': 'បោះបង់',
      'sell_copy_image': 'ចម្លងរូបភាព',
      'sell_copy_images': 'ចម្លងរូបភាព {count}',
      'sell_view_cart': 'មើលកន្ត្រក · {count} ទំនិញ',
      'sell_products_count': '{count} ផលិតផល',
      'sell_empty_title': 'គ្មានផលិតផល',
      'sell_empty_hint': 'ទាញចុះក្រោមដើម្បីផ្ទុកឡើងវិញ',
      'sell_snack_nothing_copied': 'គ្មានអ្វីត្រូវបានចម្លង',
      'sell_snack_copied_one': 'បានចម្លងរូបភាពទៅក្តារតម្បៀតខ្ទាស់',
      'sell_snack_copied_many':
          'បានចម្លងរូបភាព {count} ជាបន្តបន្ទាប់។ ក្តារតម្បៀតខ្ទាស់រក្សាទុកតែរូបភាពចុងក្រោយ។',
      'sell_snack_copy_failed': 'ការចម្លងបរាជ័យ: {error}',
      // ═══════════════════════════════════════════════════════════
      // Stock / inventory
      // ═══════════════════════════════════════════════════════════
      'stock_title': 'ស្តុកទំនិញ',
      'stock_store_default': 'ហាងសូហូ',
      'stock_search_hint': 'ស្វែងរកផលិតផល SKU ឬបាកូដ',
      'stock_summary_products': 'ផលិតផល',
      'stock_summary_units': 'គ្រឿងនៅក្នុងស្តុក',
      'stock_summary_low': 'ស្តុកទាប',
      'stock_filter_all': 'ស្តុកទាំងអស់',
      'stock_filter_low': 'ស្តុកទាប · {count}',
      'stock_filter_out': 'អស់ស្តុក · {count}',
      'stock_list_results_for': '{count} លទ្ធផលសម្រាប់ "{query}"',
      'stock_list_count': '{count} ផលិតផល · បានធ្វើបច្ចុប្បន្នភាពថ្មីៗ',
      'stock_empty_search': 'គ្មានផលិតផលត្រូវនឹង "{query}"',
      'stock_empty_filter': 'គ្មានផលិតផលត្រូវនឹងតម្រងនេះទេ។',
      'stock_item_variants_from': '{count} វ៉ារ្យ៉ង់ · ចាប់ពី \${price}',
      'stock_item_variants_only': '{count} វ៉ារ្យ៉ង់',
      'stock_status_out': 'មាន 0 · អស់ស្តុក',
      'stock_status_low': 'មាន {count} · ត្រូវបំពេញឆាប់ៗ',
      'stock_status_ok': 'មាន {count}',
      // ═══════════════════════════════════════════════════════════
      // Open register
      // ═══════════════════════════════════════════════════════════
      'open_register_title': 'បើកគ្រឿងគិតលុយ',
      'open_register_subtitle': '{store} · {register}',
      'open_register_heading': 'ចាប់ផ្តើមដោយអារម្មណ៍ល្អ។',
      'open_register_description':
          'រាប់ប្រាក់ក្នុងថតរបស់អ្នក ហើយបញ្ចូលប្រាក់ដើម។',
      'open_register_float_label': 'ប្រាក់ដើម · USD',
      'open_register_float_hint':
          'ប្រាក់សម្រាប់ផ្តល់ប្រាក់អាប់។ នេះមិនមែនជាការលក់ទេ។',
      'open_register_note_label': 'កំណត់ចំណាំបើក (ស្រេចចិត្ត)',
      'open_register_summary_store': 'ហាង',
      'open_register_summary_opened_by': 'បើកដោយ',
      'open_register_summary_opening_cash': 'ប្រាក់បើក',
      'open_register_info':
          'ការបើកគ្រឿងគិតលុយចាប់ផ្តើមកំណត់ហេតុចលនាប្រាក់ថ្ងៃនេះ។',
      'open_register_action': 'បើកគ្រឿងគិតលុយ · \${amount}',
      'open_register_snapshot': 'រូបភាពបើក · {date}',
      'register_choose_workspace': 'ជ្រើសរើសកន្លែងធ្វើការរបស់អ្នក',
      'register_signed_in_as': 'បានចូលជា {name}',
      'register_get_store_ready': 'តោះរៀបចំហាងរបស់អ្នកឱ្យរួចរាល់។',
      'register_your_store': 'ហាងរបស់អ្នក',
      'register_select_register': 'ជ្រើសរើសគ្រឿងគិតលុយ',
      'register_no_registers': 'រកមិនឃើញគ្រឿងគិតលុយ',
      'register_no_registers_hint': 'សូមទាក់ទងអ្នកគ្រប់គ្រងហាងរបស់អ្នក។',
      'register_ready_to_open': 'រួចរាល់ក្នុងការបើក',
      'register_in_use': 'កំពុងប្រើដោយបុគ្គលិកផ្សេង',
      'register_in_use_short': 'កំពុងប្រើ',
      'register_offline': 'គ្មានដំណើរការ',
      'register_needs_float':
          'គ្រឿងគិតលុយដែលបានជ្រើសរើសត្រូវការប្រាក់ដើមដើម្បីចាប់ផ្តើមលក់។',
      'register_continue_with': 'បន្តជាមួយ {name}',
      'register_select_a_register': 'ជ្រើសរើសគ្រឿងគិតលុយ',
      'register_manager_line': 'អ្នកគ្រប់គ្រងហាង • {email}',
      'register_name_generic': 'គ្រឿងគិតលុយ',
      'close_register_title': 'បិទគ្រឿងគិតលុយ',
      'close_register_subtitle': '{register} · ថ្ងៃនេះ',
      'close_register_no_open': 'គ្មានគ្រឿងគិតលុយបើក',
      'close_register_no_open_hint': 'គ្មានសម័យគ្រឿងគិតលុយសកម្មដើម្បីបិទទេ។',
      'close_register_go_back': 'ត្រឡប់ក្រោយ',
      'close_register_opening_float': 'ប្រាក់ដើម',
      'close_register_cash_sales': 'ការលក់ជាសាច់ប្រាក់ · បន្ទាប់ពីប្តូរ',
      'close_register_cash_refunds': 'ការសងប្រាក់ជាសាច់ប្រាក់',
      'close_register_cash_in': 'ប្រាក់ចូល · ការបំពេញ',
      'close_register_cash_out': 'ប្រាក់ចេញ · ការចំណាយ',
      'close_register_expected_cash': 'ប្រាក់រំពឹងទុក',
      'close_register_counted_cash': 'ប្រាក់ដែលបានរាប់ · USD',
      'close_register_counted_hint': 'រាប់ក្រដាសប្រាក់ និងកាក់ទាំងអស់ក្នុងថត។',
      'close_register_balanced': 'ស្មើ · ភាពខុសគ្នា \$0.00',
      'close_register_difference_over': 'ភាពខុសគ្នា: \${amount} លើស',
      'close_register_difference_short': 'ភាពខុសគ្នា: \${amount} ខ្វះ',
      'close_register_note_label': 'កំណត់ចំណាំបិទ',
      'close_register_action': 'បញ្ជាក់ & បិទគ្រឿងគិតលុយ',
      'close_register_footer': 'នេះបញ្ចប់សម័យគ្រឿងគិតលុយបច្ចុប្បន្ន។',
      'close_register_success': 'បានបិទគ្រឿងគិតលុយដោយជោគជ័យ',
      'close_register_failed': 'មិនអាចបិទគ្រឿងគិតលុយបាន',
      'staff_title': 'បុគ្គលិក និងសិទ្ធិ',
      'staff_subtitle': '{count} សមាជិកសកម្ម · {store}',
      'staff_store_default': 'ហាងសូហូ',
      'staff_team_header': 'ក្រុមការងាររបស់អ្នក',
      'staff_empty': 'រកមិនឃើញសមាជិកបុគ្គលិក។',
      'staff_current_user_suffix': ' · អ្នក',
      'staff_role_manager': 'អ្នកគ្រប់គ្រងហាង',
      'staff_role_associate': 'អ្នកលក់',
      'staff_status_active': 'សកម្ម',
      'staff_status_inactive': 'អសកម្ម',
      'staff_role_status': '{role} · {status}',
      'staff_manage': 'គ្រប់គ្រង',
      'staff_permissions_title_manager': 'សិទ្ធិអ្នកគ្រប់គ្រងហាង',
      'staff_permissions_title_associate': 'សិទ្ធិអ្នកលក់',
      'staff_permissions_subtitle': '{name} · តួនាទីបច្ចុប្បន្ន',
      'staff_permission_sell': 'លក់ សងប្រាក់វិញ & អនុវត្តការបញ្ចុះតម្លៃ',
      'staff_permission_registers': 'បើក និងបិទគ្រឿងគិតលុយ',
      'staff_permission_inventory': 'កែស្តុក & គ្រប់គ្រងអតិថិជន',
      'staff_permission_settings': 'កែការកំណត់ហាង & អញ្ជើញបុគ្គលិក',
      'staff_footer_note':
          'អ្នកលក់អាចលក់ និងគ្រប់គ្រងអតិថិជន។ ការសងប្រាក់វិញ ការបញ្ចុះតម្លៃលើស 20% ការកែស្តុក និងការបិទគ្រឿងគិតលុយត្រូវការការអនុម័តពីអ្នកគ្រប់គ្រង។',
      'staff_invite_button': 'អញ្ជើញសមាជិកបុគ្គលិក',
      'staff_unknown_name': 'មិនស្គាល់',
      // ── Bottom navigation labels ──
      'nav_home': 'ដើម',
      'nav_sell': 'លក់',
      'nav_sales': 'ការលក់',
      'nav_stock': 'ស្តុក',
      'nav_more': 'ផ្សេងៗ',
      // ── Header ──
      'cart_title': 'កន្ត្រក',
      'cart_subtitle_items': '{count} ទំនិញ',

      // ── Customer banner ──
      'cart_add_customer': 'បន្ថែមអតិថិជន',
      'cart_add_customer_sub': 'ភ្ជាប់ប្រវត្តិរូបសម្រាប់បង្កាន់ដៃ & ប្រវត្តិ',

      // ── Order discount ──
      'cart_order_discount': 'ការបញ្ចុះតម្លៃលើការបញ្ជាទិញ',
      'cart_discount_apply': 'អនុវត្ត',
      'cart_discount_change': 'ផ្លាស់ប្តូរ',
      'cart_no_discount_applied': 'គ្មានការបញ្ចុះតម្លៃត្រូវបានអនុវត្ត',
      'cart_discount_fallback': 'ការបញ្ចុះតម្លៃ',
      'cart_tap_to_select_discount': 'ប៉ះដើម្បីជ្រើសរើសការបញ្ចុះតម្លៃ',
      'cart_discount_subtitle_percentage': 'បញ្ចុះ {value}% · -\${amount}',
      'cart_discount_subtitle_fixed': 'បញ្ចុះ -\${amount}',

      // ── Discount picker sheet ──
      'cart_apply_discount_title': 'អនុវត្តការបញ្ចុះតម្លៃ',
      'cart_no_discount_title': 'គ្មានការបញ្ចុះតម្លៃ',
      'cart_no_discount_subtitle': 'គិតថ្លៃអតិថិជនពេញចំនួន',

      // ── Order note ──
      'cart_add_order_note': 'បន្ថែមកំណត់ចំណាំការបញ្ជាទិញ',

      // ── Order summary ──
      'cart_subtotal_items': 'សរុបរង · {count} ទំនិញ',
      'cart_discount_summary_percentage': '{name} · {value}%',
      'cart_discount_summary_fixed': '{name}',
      'cart_sales_tax': 'ពន្ធលក់ · 10%',
      'cart_total_due': 'សរុបត្រូវបង់',

      // ── Cart item ──
      'cart_standard_variant': 'វ៉ារ្យ៉ង់ស្តង់ដារ',
      'cart_max_stock_reached': 'ឈានដល់ស្តុកអតិបរមា',

      // ── Empty state ──
      'cart_empty_title': 'កន្ត្រករបស់អ្នកទទេ',
      'cart_empty_hint': 'បន្ថែមទំនិញដើម្បីចាប់ផ្តើមការលក់ថ្មី',
      'cart_browse_products': 'រកមើលទំនិញ',

      // ── Bottom action ──
      'cart_continue_to_checkout': 'បន្តទៅការបង់ប្រាក់',
      // ── Add to 'km' map ──
      'receipt_item_returned_note': '(បានត្រឡប់ {count})',
      'receipt_items_returned_count': 'ទំនិញ {count} បានត្រឡប់ទាំងស្រុង',
      'receipt_refunded_line': 'បានសងវិញ',
      'receipt_net_paid': 'សរុបបានបង់សុទ្ធ',
    },
  };

  // ══════════════════════════════════════════════════════════════
  // Public API
  // ══════════════════════════════════════════════════════════════

  /// Returns the translated string for [key] in the given [locale],
  /// falling back to English, then to the key itself.
  static String translate(String key, {String? locale}) {
    final String languageCode = locale ?? 'en';
    return _localizedStrings[languageCode]?[key] ??
        _localizedStrings['en']?[key] ??
        key;
  }

  /// Returns the translated string with `{placeholder}` tokens replaced
  /// using the given [params] map.
  static String translateWithParams(
    String key,
    Map<String, String> params, {
    String? locale,
  }) {
    String text = translate(key, locale: locale);
    params.forEach((paramKey, value) {
      text = text.replaceAll('{$paramKey}', value);
    });
    return text;
  }

  /// Convenience helper for pluralization.
  ///
  /// Example:
  /// ```dart
  /// AppLocalizations.plural('items_count', count, locale: 'en')
  /// ```
  static String plural(
    String baseKey,
    int count, {
    String? locale,
    Map<String, String>? extraParams,
  }) {
    final key = count == 1 ? '${baseKey}_one' : baseKey;
    final params = <String, String>{'count': '$count', ...?extraParams};
    return translateWithParams(key, params, locale: locale);
  }

  // ══════════════════════════════════════════════════════════════
  // Short aliases — for terser call sites
  //
  // These are thin wrappers around the long-form methods above.
  // Use them when you don't have a BuildContext (services, tests,
  // providers) or when you want a shorter name.
  //
  // Screens should keep using `context.t(...)` / `context.tp(...)` /
  // `context.tn(...)` — those read the locale from LanguageProvider
  // automatically.
  // ══════════════════════════════════════════════════════════════

  /// Alias for [translate].
  ///
  /// Example: `AppLocalizations.t('my_cart', locale: 'en')`
  static String t(String key, {String? locale}) =>
      translate(key, locale: locale);

  /// Alias for [translateWithParams].
  ///
  /// Example: `AppLocalizations.tp('items_count', {'count': '3'})`
  static String tp(String key, Map<String, String> params, {String? locale}) =>
      translateWithParams(key, params, locale: locale);

  /// Alias for [plural].
  ///
  /// Example: `AppLocalizations.tn('items_count', 3)`
  static String tn(
    String baseKey,
    int count, {
    String? locale,
    Map<String, String>? extraParams,
  }) => plural(baseKey, count, locale: locale, extraParams: extraParams);
}
