class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      // ═══════════════════════════════════════════════════════════
      // Cart Screen
      // ═══════════════════════════════════════════════════════════
      'my_cart': 'My Cart',
      'your_cart_is_empty': 'Your cart is empty',
      'browse_restaurants': 'Browse Restaurants',
      'confirm_payment': 'Confirm Payment',
      'proceed_payment': 'Proceeding to payment',
      'items': 'items',
      'promo_applied': 'Promo applied!',
      'invalid_promo': 'Invalid promo code',
      'subtotal': 'Subtotal',
      'delivery_fee': 'Delivery Fee',
      'promo_discount': 'Promo Discount',
      'total_amount': 'Total Amount',

      'signin_cart_message': 'Sign in to view your cart and place orders.',
      'proceed_payment_amount': 'Proceeding to payment • \${amount}',
      'confirm_payment_amount': 'Confirm Payment  •  \${amount}',
      'items_count': '{count} items',
      'items_count_one': '{count} item',
      'cart_empty_subtitle':
          'Looks like you haven\'t added anything yet.\nStart exploring our delicious menu!',
      'promo_label': 'Promo: ',
      'have_promo_code': 'Have a promo code?',
      'add_items_before_checkout': 'Add items before checking out.',
      'no_promo': 'NO PROMO',
      'free': 'FREE',

      // ── Common actions ──
      'save': 'Save',
      'apply': 'APPLY',
      'applied': 'APPLIED',
      'view_all': 'View All',
      'mark_all': 'Mark all',
      'checkout': 'Checkout',
      'add_to_cart': 'Add to Cart',
      'new_badge': 'NEW',
      'name': 'Name',
      'cancel': 'Cancel',
      'retry': 'Retry',
      'loading': 'Loading...',
      'estimated': 'Estimated',

      // ═══════════════════════════════════════════════════════════
      // Bottom Nav
      // ═══════════════════════════════════════════════════════════
      'home': 'Explore',
      'restaurant': 'Restaurant',
      'cart': 'Cart',
      'profile': 'Profile',

      // ═══════════════════════════════════════════════════════════
      // Home / Restaurant
      // ═══════════════════════════════════════════════════════════
      'popular_foods': 'Popular Foods',
      'all_restaurants': 'All Restaurants',
      'all_restaurants_lower': 'All restaurants',
      'featured_restaurants': 'Featured Restaurants',
      'delivering_to': 'Delivering to',
      'select_location': 'Select your location',
      'search_products': 'Search for products',
      'find_restaurant': 'Find another restaurant...',
      'no_restaurants_category': 'No restaurants in this category',
      'no_foods_available': 'No foods available',
      'no_restaurants_found': 'No restaurants found',
      'no_foods_yet': 'No foods yet',
      'no_restaurants_yet': 'No restaurants yet',
      'failed_load_foods': 'Failed to load foods',
      'failed_load_restaurants': 'Failed to load restaurants',
      'restaurant_not_found': 'Restaurant not found',
      'best_seller': 'Best Seller',
      'no_items_category': 'No items in this category',
      'distance_away': '{km} km away',

      'cat_all': 'All',
      'cat_khmer': 'Khmer Food',
      'cat_fast_food': 'Fast Food',
      'cat_japanese': 'Japanese Food',
      'cat_italian': 'Italian Food',

      'filter_rating_45': 'Rating 4.5+',
      'filter_under_25m': 'Under 25m',
      'filter_free_delivery': 'Free Delivery',

      'promo_30_off': '30% OFF',
      'promo_banner_title': 'Fresh bowls,\nmade to\nimpress.',
      'promo_banner_subtitle':
          'Chef-curated salads, juicy\nburgers, and crave-worthy\nrolls.',

      // ═══════════════════════════════════════════════════════════
      // Profile
      // ═══════════════════════════════════════════════════════════
      'signin_message': 'Sign in to view and manage your profile.',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to log out?',
      'profile_load_error': 'Couldn\'t load your profile',
      'guest': 'Guest',
      'not_set': 'Not set',
      'phone': 'Phone',
      'email': 'Email',
      'address': 'Address',
      'personalize': 'Personalize',
      'saved_address': 'My Saved Address',
      'saved_address_sub': 'Edit your delivery locations',
      'orders_history': 'Orders History',
      'orders_history_sub': 'Reorder past delicious bowls',
      'favorites': 'Favorites',
      'favorites_sub': 'All of your favorite food are here',
      'app_preferences': 'App Preferences',
      'app_preferences_sub': 'Notification and vegan-only toggle',

      'edit_profile': 'Edit Profile',
      'choose_from_gallery': 'Choose from gallery',
      'take_photo': 'Take a photo',
      'remove_photo': 'Remove photo',
      'could_not_pick_image': 'Could not pick image: {error}',
      'fill_name_email': 'Please fill in name and email',
      'failed_to_save': 'Failed to save: {error}',

      // ═══════════════════════════════════════════════════════════
      // Order History
      // ═══════════════════════════════════════════════════════════
      'sort_filter': 'Sort & Filter',
      'filter_all': 'All',
      'filter_delivered': 'Delivered',
      'filter_pending': 'Pending',
      'filter_canceled': 'Canceled',
      'no_orders_yet': 'No orders yet',
      'order_id': 'Order {id}',
      'view_details': 'View Details',
      'payment': 'Payment:',

      // ═══════════════════════════════════════════════════════════
      // Track Order
      // ═══════════════════════════════════════════════════════════
      'track_delivery': 'Track Delivery',
      'arriving_in': 'Arriving in {minutes} min',
      'distance_time': '{distance} km, {minutes} min',
      'status_timeline': 'Status Timeline',
      'order_placed': 'Order Placed',
      'order_placed_subtitle': 'We\'ve received your salad request',
      'bowl_preparation': 'Bowl Preparation',
      'bowl_preparation_subtitle': 'Chef Rossi is handcrafting your poke',
      'on_the_way': 'On The Way',
      'on_the_way_subtitle': 'David is scooting at 30mph',
      'delivered': 'Delivered',
      'delivered_subtitle': 'Healthy bite arrived!',

      // ═══════════════════════════════════════════════════════════
      // Save Address (list screen)
      // ═══════════════════════════════════════════════════════════
      'receiving_address': 'Receiving Address',
      'add_address': 'Add address',
      'address_added': 'Address added',
      'pick_again': 'Pick Again',
      'save_location': 'Save Location',
      'my_address': 'My Address',
      'default': 'Default',
      'lat': 'LAT',
      'lng': 'LNG',

      'deliver_to': 'Deliver to',
      'delivery_address': 'Delivery Address',
      'add_new_address': 'Add new address',
      'pick_location_map': 'Pick a location on the map',
      'no_saved_addresses': 'No saved addresses yet',
      'select_delivery_address': 'Please select a delivery address',

      // ── AE Address (add / edit form) ──
      'edit_address': 'Edit Address',
      'update_address': 'Update Address',
      'address_updated': 'Address updated',
      'use_current_location': 'Use current location',
      'contact': 'Contact',
      'select_receiving_address': 'Select receiving address',
      'detail': 'Detail',
      'address_detail_hint': 'Building, floor, room, etc.',
      'tag': 'Tag',
      'tag_temp': 'Temp',
      'tag_office': 'Office',
      'tag_school': 'School',
      'tag_other': 'Other',
      'default_address': 'Default address',
      'address_photos': 'Address photos',
      'up_to_5': '(up to 5)',
      'add_photo': 'Add photo',
      'address_photos_hint':
          'Add clear photos of your building entrance or street view so the driver can find you faster.',
      'save_address': 'Save Address',
      'please_fill_name_address': 'Please fill in name and address',

      // ═══════════════════════════════════════════════════════════
      // App Preferences
      // ═══════════════════════════════════════════════════════════
      'notifications': 'Notifications',
      'dietary_preferences': 'Dietary Preferences',
      'app_settings': 'App Settings',
      'account_security': 'Account & Security',
      'about': 'About',
      'push_notifications': 'Push Notifications',
      'push_notifications_sub': 'Get alerts on your device',
      'order_updates': 'Order Updates',
      'order_updates_sub': 'Track your order in real time',
      'promotions_deals': 'Promotions & Deals',
      'promotions_deals_sub': 'Receive discount codes and offers',
      'email_notifications': 'Email Notifications',
      'email_notifications_sub': 'Get email receipts and updates',
      'vegan_only': 'Vegan Only',
      'vegan_only_sub': 'Show only vegan-friendly restaurants',
      'gluten_free': 'Gluten-Free',
      'gluten_free_sub': 'Filter gluten-free options',
      'nut_free': 'Nut-Free',
      'nut_free_sub': 'Hide dishes containing nuts',
      'language': 'Language',
      'currency': 'Currency',
      'dark_mode': 'Dark Mode',
      'dark_mode_sub': 'Switch to dark theme',
      'location_services': 'Location Services',
      'location_services_sub': 'Allow app to use your location',
      'change_password': 'Change Password',
      'privacy_policy': 'Privacy Policy',
      'terms_service': 'Terms of Service',
      'app_version': 'App Version',
      'rate_app': 'Rate the App',
      'help_support': 'Help & Support',
      'select_language': 'Select Language',
      'select_currency': 'Select Currency',

      'lang_english': 'English',
      'lang_khmer': 'Khmer',
      'lang_chinese': 'Chinese',
      'lang_thai': 'Thai',
      'lang_vietnamese': 'Vietnamese',

      // ═══════════════════════════════════════════════════════════
      // Favorites
      // ═══════════════════════════════════════════════════════════
      'my_favorites': 'My Favorites',
      'favorites_restaurants_count': 'Restaurants ({count})',
      'favorites_foods_count': 'Foods ({count})',
      'no_fav_restaurants': 'No favorite restaurants yet',
      'no_fav_restaurants_sub':
          'Tap the heart on a restaurant to save it here.',
      'no_fav_foods': 'No favorite foods yet',
      'no_fav_foods_sub': 'Tap the heart on a dish to save it here.',
      'no_favorites': 'No favorites yet',
      'no_favorites_sub': 'Start adding your favorite restaurants\nand dishes!',
      'explore_restaurants': 'Explore Restaurants',

      // ═══════════════════════════════════════════════════════════
      // Food Item Detail
      // ═══════════════════════════════════════════════════════════
      'added_to_cart': 'Added {qty} × {name} to cart',
      'choose_size': 'Choose Size',
      'size_regular': 'Regular',
      'size_large': 'Large',
      'size_large_price': 'Large (+ \$1.50)',
      'add_extra_toppings': 'Add Extra Toppings',
      'topping_double_salmon': 'Double Salmon (+ \$3.50)',
      'topping_avocado': 'Avocado Slices (+ \$1.20)',
      'topping_seeds': 'Extra Seed Mix (+ \$0.50)',
      'topping_double_salmon_label': 'Double Salmon',
      'topping_avocado_label': 'Avocado',
      'topping_seeds_label': 'Extra Seeds',

      // ═══════════════════════════════════════════════════════════
      // Notifications
      // ═══════════════════════════════════════════════════════════
      'failed_load_notifications': 'Couldn\'t load notifications',
      'no_notifications': 'No notifications yet',
      'no_notifications_sub':
          'You\'ll see updates about your orders\nand promos here.',
      'just_now': 'Just now',
      'minutes_ago': '{n} min ago',
      'hours_ago': '{n} hr ago',
      'hours_ago_plural': '{n} hrs ago',
      'days_ago': '{n} day ago',
      'days_ago_plural': '{n} days ago',

      // ═══════════════════════════════════════════════════════════
      // Order Confirm
      // ═══════════════════════════════════════════════════════════
      'order_confirmed': 'Order Confirmed',
      'package_on_the_way': 'Your package is on the way',
      'estimated_delivery': 'Estimated Delivery',
      'order_number': 'Order Number',
      'track_my_order': 'Track My Order',
      'back_to_home': 'Back to Home',

      // ═══════════════════════════════════════════════════════════
      // Change Password
      // ═══════════════════════════════════════════════════════════
      'password_requirements':
          'Your new password must be at least 8 characters with a mix of letters and numbers.',
      'current_password': 'Current Password',
      'enter_current_password': 'Enter current password',
      'please_enter_current_password': 'Please enter your current password',
      'new_password': 'New Password',
      'enter_new_password': 'Enter new password',
      'please_enter_password': 'Please enter a password',
      'must_be_8_chars': 'Must be at least 8 characters',
      'must_contain_letters': 'Must contain letters',
      'must_contain_numbers': 'Must contain numbers',
      'confirm_new_password': 'Confirm New Password',
      'reenter_new_password': 'Re-enter new password',
      'please_confirm_password': 'Please confirm password',
      'passwords_do_not_match': 'Passwords do not match',
      'update_password': 'Update Password',
      'password_updated_success': 'Password updated successfully',

      // ═══════════════════════════════════════════════════════════
      // Help & Support
      // ═══════════════════════════════════════════════════════════
      'banner_title': 'We\'re here to help',
      'banner_subtitle': 'Find answers or reach out to our team',
      'contact_us': 'Contact Us',
      'faq': 'Frequently Asked Questions',
      'live_chat': 'Live Chat',
      'available_24_7': 'Available 24/7',
      'email_support': 'Email Support',
      'call_us': 'Call Us',
      'still_need_help':
          'Still need help? Chat with our team — we usually reply within minutes.',

      'faq_q1': 'How do I track my order?',
      'faq_a1':
          'Once your order is confirmed, go to Orders History in your profile. Tap the order you want to track and select "Track Order" to see real-time updates.',
      'faq_q2': 'Can I cancel my order?',
      'faq_a2':
          'Yes, you can cancel an order before the restaurant starts preparing it. Go to Orders History, open the order, and tap "Cancel Order". Once preparation has started, cancellation may not be possible.',
      'faq_q3': 'What payment methods do you accept?',
      'faq_a3':
          'We accept Visa, Mastercard, ABA Pay, Wing, and cash on delivery. You can manage your payment methods in the App Preferences screen.',
      'faq_q4': 'How do I request a refund?',
      'faq_a4':
          'If there was an issue with your order, go to Orders History, open the affected order, and tap "Report Issue". Our support team will review it within 24 hours.',
      'faq_q5': 'How do I change my delivery address?',
      'faq_a5':
          'Go to Profile → My Saved Address to add, edit, or remove delivery addresses. You can also set a default address for faster checkout.',
      'faq_q6': 'Is there a minimum order amount?',
      'faq_a6':
          'Minimum order amounts vary by restaurant. You\'ll see the requirement on each restaurant\'s page and at checkout.',
      'faq_q7': 'How can I contact a driver?',
      'faq_a7':
          'Once your order is out for delivery, you\'ll see a "Call Driver" button on the Track Order screen. Please use it only for delivery-related matters.',

      // ═══════════════════════════════════════════════════════════
      // App Version
      // ═══════════════════════════════════════════════════════════
      'app_name': 'Miko Delivery',
      'version_build': 'Version {version} (Build {build})',
      'up_to_date': 'Up to date',
      'build_info': 'Build Information',
      'version': 'Version',
      'build_number': 'Build Number',
      'release_date': 'Release Date',
      'platform': 'Platform',
      'whats_new': 'What\'s New',
      'footer_rights': '© 2026 Miko Delivery. All rights reserved.',

      'changelog_100_1': '🎉 Initial release of Miko Delivery',
      'changelog_100_2': '🍜 Browse restaurants and order food',
      'changelog_100_3': '🚚 Real-time order tracking',
      'changelog_100_4': '❤️ Save your favorite dishes',
      'changelog_100_5': '📍 Multiple delivery addresses',
      'changelog_090_1': 'Beta testing phase',
      'changelog_090_2': 'Bug fixes and performance improvements',

      // ═══════════════════════════════════════════════════════════
      // Privacy Policy
      // ═══════════════════════════════════════════════════════════
      'last_updated': 'Last updated: {date}',
      'section_intro_title': '1. Introduction',
      'section_info_collect_title': '2. Information We Collect',
      'section_use_info_title': '3. How We Use Your Information',
      'section_share_info_title': '4. Sharing Your Information',
      'section_data_security_title': '5. Data Security',
      'section_rights_title': '6. Your Rights',
      'section_children_title': '7. Children\'s Privacy',
      'section_changes_title': '8. Changes to This Policy',
      'section_contact_title': '9. Contact Us',

      'privacy_intro_body':
          'Welcome to Miko Delivery. We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
      'privacy_collect_body':
          'We may collect the following types of information:\n\n'
          '• Personal Information: Name, email address, phone number, and delivery address.\n'
          '• Payment Information: Card details (processed securely by third-party payment processors).\n'
          '• Location Data: GPS location to provide delivery services and show nearby restaurants.\n'
          '• Usage Data: App interactions, order history, and preferences.\n'
          '• Device Information: Device model, OS version, and unique device identifiers.',
      'privacy_use_info_body':
          'We use the collected information to:\n\n'
          '• Process and deliver your orders.\n'
          '• Personalize your app experience.\n'
          '• Send order updates and promotional offers (with your consent).\n'
          '• Improve our services and prevent fraud.\n'
          '• Comply with legal obligations.',
      'privacy_share_info_body':
          'We do not sell your personal data. We may share it with:\n\n'
          '• Restaurants and delivery partners to fulfill your orders.\n'
          '• Payment processors to complete transactions.\n'
          '• Service providers who assist our operations.\n'
          '• Law enforcement when required by law.',
      'privacy_data_security_body':
          'We implement industry-standard security measures to protect your data, including encryption, secure servers, and access controls. However, no method of transmission over the internet is 100% secure.',
      'privacy_rights_body':
          'You have the right to:\n\n'
          '• Access, correct, or delete your personal data.\n'
          '• Opt out of marketing communications.\n'
          '• Withdraw consent at any time.\n'
          '• Lodge a complaint with a supervisory authority.',
      'privacy_children_body':
          'Our services are not intended for children under 13. We do not knowingly collect data from children. If you believe we have, please contact us immediately.',
      'privacy_changes_body':
          'We may update this Privacy Policy from time to time. We will notify you of significant changes via the app or email.',
      'privacy_contact_body':
          'If you have questions about this Privacy Policy, contact us at:\n\n'
          '• Email: privacy@mikodelivery.com\n'
          '• Phone: +855 777 3721\n'
          '• Address: Green Garden, Apt 4B, Phnom Penh, Cambodia',

      // ═══════════════════════════════════════════════════════════
      // Terms of Service
      // ═══════════════════════════════════════════════════════════
      'section_acceptance_title': '1. Acceptance of Terms',
      'section_eligibility_title': '2. Eligibility',
      'section_account_title': '3. Account Registration',
      'section_orders_title': '4. Orders and Payments',
      'section_delivery_title': '5. Delivery',
      'section_refunds_title': '6. Refunds and Cancellations',
      'section_prohibited_title': '7. Prohibited Conduct',
      'section_ip_title': '8. Intellectual Property',
      'section_liability_title': '9. Limitation of Liability',
      'section_termination_title': '10. Termination',
      'section_law_title': '11. Governing Law',
      'section_contact_terms_title': '12. Contact Us',

      'terms_acceptance_body':
          'By downloading, accessing, or using the Miko Delivery mobile application, you agree to be bound by these Terms of Service. If you do not agree, please do not use our services.',
      'terms_eligibility_body':
          'You must be at least 18 years old to create an account and place orders. By using the app, you represent that you meet this requirement.',
      'terms_account_body':
          'You are responsible for:\n\n'
          '• Providing accurate and complete information.\n'
          '• Maintaining the confidentiality of your account credentials.\n'
          '• All activities that occur under your account.\n\n'
          'Notify us immediately if you suspect unauthorized access.',
      'terms_orders_body':
          '• All orders are subject to acceptance and availability.\n'
          '• Prices are displayed in the app and may change without notice.\n'
          '• Payment must be completed before delivery.\n'
          '• We reserve the right to cancel orders due to errors, fraud, or stock issues.',
      'terms_delivery_body':
          '• Estimated delivery times are not guaranteed.\n'
          '• You must provide an accurate delivery address.\n'
          '• If no one is available to receive the order, it may be left at the door or returned at your cost.',
      'terms_refunds_body':
          '• Orders can be cancelled before preparation begins.\n'
          '• Refunds are issued at our discretion in cases of incorrect or missing items.\n'
          '• Contact support within 24 hours of delivery for any issues.',
      'terms_prohibited_body':
          'You agree not to:\n\n'
          '• Use the app for unlawful purposes.\n'
          '• Impersonate others or misrepresent your identity.\n'
          '• Interfere with the app\'s operation or security.\n'
          '• Post false reviews or abusive content.',
      'terms_ip_body':
          'All content in the app — logos, text, images, and code — is owned by Miko Delivery or its licensors. You may not copy, modify, or distribute without permission.',
      'terms_liability_body':
          'Miko Delivery is not liable for indirect, incidental, or consequential damages arising from your use of the app, to the maximum extent permitted by law.',
      'terms_termination_body':
          'We may suspend or terminate your account at any time for violations of these Terms. You may delete your account at any time through the app settings.',
      'terms_law_body':
          'These Terms are governed by the laws of Cambodia. Any disputes will be resolved in the courts of Phnom Penh.',
      'terms_contact_body':
          'For questions about these Terms, contact us at:\n\n'
          '• Email: legal@mikodelivery.com\n'
          '• Phone: +855 777 3721',
      // ── Payment method (checkout) ──
      'pay_cash': 'Pay with Cash',
      'pay_khqr': 'Pay with KHQR',
      'payment_method': 'Payment Method',
      'choose_payment_method': 'Choose how you\'d like to pay',
      'cash_on_delivery': 'Cash on Delivery',
      'pay_when_you_receive': 'Pay the driver when your order arrives',
      'khqr_payment': 'KHQR / Bakong',
      'pay_now_with_bakong': 'Scan the QR with any Bakong-enabled bank app',

      // ── KHQR sheet ──
      'scan_to_pay': 'Scan to pay',
      'waiting_for_payment': 'Waiting for payment…',
      'qr_expires_in': 'QR expires in',
      'qr_expired': 'QR expired',
      'payment_successful': 'Payment Successful',
      'amount_added_to_balance': '\${amount} has been added to your balance',
      'new_balance': 'New balance',
      'done': 'Done',
      'generate_new_qr': 'Generate New QR',
      'something_went_wrong': 'Something went wrong',
      'unable_to_verify_payment': 'Unable to verify payment',
      'failed_to_generate_qr': 'Failed to generate QR',
      'close': 'Close',
    },

    // ═══════════════════════════════════════════════════════════════
    // ═══════════════════════════════ KHMER ═════════════════════════
    // ═══════════════════════════════════════════════════════════════
    'km': {
      // ═══════════════════════════════════════════════════════════
      // Cart Screen
      // ═══════════════════════════════════════════════════════════
      'my_cart': 'កន្ត្រករបស់ខ្ញុំ',
      'your_cart_is_empty': 'កន្ត្រករបស់អ្នកទទេ',
      'browse_restaurants': 'រកមើលភោជនីយដ្ឋាន',
      'confirm_payment': 'បញ្ជាក់ការទូទាត់',
      'proceed_payment': 'កំពុងបន្តទៅការទូទាត់',
      'items': 'មុខម្ហូប',
      'promo_applied': 'បានអនុវត្តកូដបញ្ចុះតម្លៃ!',
      'invalid_promo': 'កូដបញ្ចុះតម្លៃមិនត្រឹមត្រូវ',
      'subtotal': 'សរុបរង',
      'delivery_fee': 'ថ្លៃដឹកជញ្ជូន',
      'promo_discount': 'ការបញ្ចុះតម្លៃ',
      'total_amount': 'ចំនួនសរុប',

      'signin_cart_message':
          'សូមចូលដើម្បីមើលកន្ត្រក និងធ្វើការបញ្ជាទិញរបស់អ្នក។',
      'proceed_payment_amount': 'កំពុងបន្តទៅការទូទាត់ • \${amount}',
      'confirm_payment_amount': 'បញ្ជាក់ការទូទាត់  •  \${amount}',
      'items_count': '{count} មុខម្ហូប',
      'items_count_one': '{count} មុខម្ហូប',
      'cart_empty_subtitle':
          'មើលទៅអ្នកមិនទាន់បានបន្ថែមអ្វីទេ។\nចាប់ផ្តើមរុករកមុខម្ហូបឆ្ងាញ់ៗរបស់យើង!',
      'promo_label': 'ប្រូម៉ូ៖ ',
      'have_promo_code': 'មានកូដប្រូម៉ូ?',
      'add_items_before_checkout': 'សូមបន្ថែមមុខម្ហូបមុនពេលបង់ប្រាក់។',
      'no_promo': 'គ្មានប្រូម៉ូ',
      'free': 'ឥតគិតថ្លៃ',

      'save': 'រក្សាទុក',
      'apply': 'អនុវត្ត',
      'applied': 'បានអនុវត្ត',
      'view_all': 'មើលទាំងអស់',
      'mark_all': 'សម្គាល់ទាំងអស់',
      'checkout': 'បង់ប្រាក់',
      'add_to_cart': 'បន្ថែមទៅកន្ត្រក',
      'new_badge': 'ថ្មី',
      'name': 'ឈ្មោះ',
      'cancel': 'បោះបង់',
      'retry': 'ព្យាយាមម្តងទៀត',
      'loading': 'កំពុងផ្ទុក...',
      'estimated': 'ប៉ាន់ស្មាន',

      // ═══════════════════════════════════════════════════════════
      // Bottom Nav
      // ═══════════════════════════════════════════════════════════
      'home': 'ស្វែងរក',
      'restaurant': 'ភោជនីយដ្ឋាន',
      'cart': 'កន្ត្រក',
      'profile': 'ប្រវត្តិរូប',

      // ═══════════════════════════════════════════════════════════
      // Home / Restaurant
      // ═══════════════════════════════════════════════════════════
      'popular_foods': 'មុខម្ហូបពេញនិយម',
      'all_restaurants': 'ភោជនីយដ្ឋានទាំងអស់',
      'all_restaurants_lower': 'ភោជនីយដ្ឋានទាំងអស់',
      'featured_restaurants': 'ភោជនីយដ្ឋានពិសេស',
      'delivering_to': 'ដឹកជញ្ជូនទៅ',
      'select_location': 'ជ្រើសរើសទីតាំងរបស់អ្នក',
      'search_products': 'ស្វែងរកផលិតផល',
      'find_restaurant': 'រកភោជនីយដ្ឋានផ្សេង...',
      'no_restaurants_category': 'គ្មានភោជនីយដ្ឋានក្នុងប្រភេទនេះ',
      'no_foods_available': 'គ្មានមុខម្ហូបទេ',
      'no_restaurants_found': 'រកមិនឃើញភោជនីយដ្ឋាន',
      'no_foods_yet': 'មិនទាន់មានមុខម្ហូប',
      'no_restaurants_yet': 'មិនទាន់មានភោជនីយដ្ឋាន',
      'failed_load_foods': 'មិនអាចផ្ទុកមុខម្ហូបបាន',
      'failed_load_restaurants': 'មិនអាចផ្ទុកភោជនីយដ្ឋានបាន',
      'restaurant_not_found': 'រកមិនឃើញភោជនីយដ្ឋាន',
      'best_seller': 'លក់ដាច់បំផុត',
      'no_items_category': 'គ្មានមុខម្ហូបក្នុងប្រភេទនេះ',
      'distance_away': 'ចម្ងាយ {km} គ.ម',

      'cat_all': 'ទាំងអស់',
      'cat_khmer': 'អាហារខ្មែរ',
      'cat_fast_food': 'អាហាររហ័ស',
      'cat_japanese': 'អាហារជប៉ុន',
      'cat_italian': 'អាហារអ៊ីតាលី',

      'filter_rating_45': 'ការវាយតម្លៃ 4.5+',
      'filter_under_25m': 'ក្រោម 25 នាទី',
      'filter_free_delivery': 'ដឹកជញ្ជូនឥតគិតថ្លៃ',

      'promo_30_off': 'បញ្ចុះ 30%',
      'promo_banner_title': 'ចានស្រស់ៗ\nធ្វើឡើងដើម្បី\nចាប់អារម្មណ៍។',
      'promo_banner_subtitle':
          'សាឡាត់ដែលចម្អិនដោយចុងភៅ បឺហ្គឺរស្រស់\nនិងរមៀលដ៏ឈ្ងុយឆ្ងាញ់។',

      // ═══════════════════════════════════════════════════════════
      // Profile
      // ═══════════════════════════════════════════════════════════
      'signin_message': 'ចូលដើម្បីមើល និងគ្រប់គ្រងប្រវត្តិរូបរបស់អ្នក។',
      'logout': 'ចាកចេញ',
      'logout_confirm': 'តើអ្នកប្រាកដថាចង់ចាកចេញឬ?',
      'profile_load_error': 'មិនអាចផ្ទុកប្រវត្តិរូបរបស់អ្នកបាន',
      'guest': 'ភ្ញៀវ',
      'not_set': 'មិនបានកំណត់',
      'phone': 'ទូរស័ព្ទ',
      'email': 'អ៊ីមែល',
      'address': 'អាស័យដ្ឋាន',
      'personalize': 'ផ្ទាល់ខ្លួន',
      'saved_address': 'អាស័យដ្ឋានដែលបានរក្សាទុក',
      'saved_address_sub': 'កែប្រែទីតាំងដឹកជញ្ជូន',
      'orders_history': 'ប្រវត្តិការបញ្ជាទិញ',
      'orders_history_sub': 'បញ្ជាទិញម្ហូបដែលបានបញ្ជាទិញពីមុន',
      'favorites': 'ចំណូលចិត្ត',
      'favorites_sub': 'ម្ហូបចំណូលចិត្តទាំងអស់របស់អ្នកនៅទីនេះ',
      'app_preferences': 'ការកំណត់កម្មវិធី',
      'app_preferences_sub': 'ការជូនដំណឹង និងជម្រើសអាហារបួស',

      'edit_profile': 'កែប្រែប្រវត្តិរូប',
      'choose_from_gallery': 'ជ្រើសរើសពីវិចិត្រសាល',
      'take_photo': 'ថតរូប',
      'remove_photo': 'លុបរូបថត',
      'could_not_pick_image': 'មិនអាចជ្រើសរើសរូបភាពបាន៖ {error}',
      'fill_name_email': 'សូមបំពេញឈ្មោះ និងអ៊ីមែល',
      'failed_to_save': 'មិនអាចរក្សាទុកបាន៖ {error}',

      // ═══════════════════════════════════════════════════════════
      // Order History
      // ═══════════════════════════════════════════════════════════
      'sort_filter': 'តម្រៀប និងត្រង',
      'filter_all': 'ទាំងអស់',
      'filter_delivered': 'បានដឹកជញ្ជូន',
      'filter_pending': 'កំពុងរង់ចាំ',
      'filter_canceled': 'បានបោះបង់',
      'no_orders_yet': 'មិនទាន់មានការបញ្ជាទិញ',
      'order_id': 'ការបញ្ជាទិញ {id}',
      'view_details': 'មើលព័ត៌មានលម្អិត',
      'payment': 'ការទូទាត់:',

      // ═══════════════════════════════════════════════════════════
      // Track Order
      // ═══════════════════════════════════════════════════════════
      'track_delivery': 'តាមដានការដឹកជញ្ជូន',
      'arriving_in': 'មកដល់ក្នុង {minutes} នាទី',
      'distance_time': '{distance} គម, {minutes} នាទី',
      'status_timeline': 'ដំណាក់កាលស្ថានភាព',
      'order_placed': 'បានបញ្ជាទិញ',
      'order_placed_subtitle': 'យើងបានទទួលការបញ្ជាទិញរបស់អ្នក',
      'bowl_preparation': 'កំពុងរៀបចំ',
      'bowl_preparation_subtitle': 'អ្នកចុងកំពុងរៀបចំម្ហូប',
      'on_the_way': 'កំពុងដឹក',
      'on_the_way_subtitle': 'អ្នកដឹកកំពុងមក',
      'delivered': 'បានដឹកជញ្ជូន',
      'delivered_subtitle': 'ម្ហូបបានមកដល់!',

      // ═══════════════════════════════════════════════════════════
      // Save Address (list screen)
      // ═══════════════════════════════════════════════════════════
      'receiving_address': 'អាស័យដ្ឋានទទួល',
      'add_address': 'បន្ថែមអាស័យដ្ឋាន',
      'address_added': 'បានបន្ថែមអាស័យដ្ឋាន',
      'pick_again': 'ជ្រើសរើសម្តងទៀត',
      'save_location': 'រក្សាទុកទីតាំង',
      'my_address': 'អាស័យដ្ឋានរបស់ខ្ញុំ',
      'default': 'លំនាំដើម',
      'lat': 'LAT',
      'lng': 'LNG',

      'deliver_to': 'ដឹកជញ្ជូនទៅ',
      'delivery_address': 'អាស័យដ្ឋានដឹកជញ្ជូន',
      'add_new_address': 'បន្ថែមអាស័យដ្ឋានថ្មី',
      'pick_location_map': 'ជ្រើសរើសទីតាំងនៅលើផែនទី',
      'no_saved_addresses': 'មិនទាន់មានអាស័យដ្ឋានដែលបានរក្សាទុក',
      'select_delivery_address': 'សូមជ្រើសរើសអាស័យដ្ឋានដឹកជញ្ជូន',

      // ── AE Address (add / edit form) ──
      'edit_address': 'កែប្រែអាស័យដ្ឋាន',
      'update_address': 'ធ្វើបច្ចុប្បន្នភាពអាស័យដ្ឋាន',
      'address_updated': 'បានធ្វើបច្ចុប្បន្នភាពអាស័យដ្ឋាន',
      'use_current_location': 'ប្រើទីតាំងបច្ចុប្បន្ន',
      'contact': 'ទំនាក់ទំនង',
      'select_receiving_address': 'ជ្រើសរើសអាស័យដ្ឋានទទួល',
      'detail': 'លម្អិត',
      'address_detail_hint': 'អគារ ជាន់ បន្ទប់ ។ល។',
      'tag': 'ស្លាក',
      'tag_temp': 'បណ្តោះអាសន្ន',
      'tag_office': 'ការិយាល័យ',
      'tag_school': 'សាលារៀន',
      'tag_other': 'ផ្សេងៗ',
      'default_address': 'អាស័យដ្ឋានលំនាំដើម',
      'address_photos': 'រូបថតអាស័យដ្ឋាន',
      'up_to_5': '(រហូតដល់ 5)',
      'add_photo': 'បន្ថែមរូបថត',
      'address_photos_hint':
          'សូមបន្ថែមរូបថតច្បាស់ៗនៃច្រកចូលអគារ ឬទិដ្ឋភាពផ្លូវ ដើម្បីឱ្យអ្នកដឹកជញ្ជូនរកអ្នកបានលឿនជាង។',
      'save_address': 'រក្សាទុកអាស័យដ្ឋាន',
      'please_fill_name_address': 'សូមបំពេញឈ្មោះ និងអាស័យដ្ឋាន',

      // ═══════════════════════════════════════════════════════════
      // App Preferences
      // ═══════════════════════════════════════════════════════════
      'notifications': 'ការជូនដំណឹង',
      'dietary_preferences': 'ចំណូលចិត្តអាហារ',
      'app_settings': 'ការកំណត់កម្មវិធី',
      'account_security': 'គណនី និងសុវត្ថិភាព',
      'about': 'អំពី',
      'push_notifications': 'ការជូនដំណឹង',
      'push_notifications_sub': 'ទទួលការជូនដំណឹងលើឧបករណ៍',
      'order_updates': 'ព័ត៌មានបញ្ជាទិញ',
      'order_updates_sub': 'តាមដានការបញ្ជាទិញក្នុងពេលជាក់ស្តែង',
      'promotions_deals': 'ការផ្តល់ជូន និងការបញ្ចុះតម្លៃ',
      'promotions_deals_sub': 'ទទួលកូដបញ្ចុះតម្លៃ និងការផ្តល់ជូន',
      'email_notifications': 'ការជូនដំណឹងតាមអ៊ីមែល',
      'email_notifications_sub': 'ទទួលបង្កាន់ដៃ និងព័ត៌មានតាមអ៊ីមែល',
      'vegan_only': 'អាហារបួស',
      'vegan_only_sub': 'បង្ហាញតែភោជនីយដ្ឋានអាហារបួស',
      'gluten_free': 'គ្មាន Gluten',
      'gluten_free_sub': 'ត្រងជម្រើសគ្មាន Gluten',
      'nut_free': 'គ្មានគ្រាប់ធញ្ញជាតិ',
      'nut_free_sub': 'លាក់ម្ហូបដែលមានគ្រាប់ធញ្ញជាតិ',
      'language': 'ភាសា',
      'currency': 'រូបិយប័ណ្ណ',
      'dark_mode': 'របៀបងងឹត',
      'dark_mode_sub': 'ប្តូរទៅរបៀបងងឹត',
      'location_services': 'សេវាកម្មទីតាំង',
      'location_services_sub': 'អនុញ្ញាតឱ្យកម្មវិធីប្រើទីតាំង',
      'change_password': 'ប្តូរពាក្យសម្ងាត់',
      'privacy_policy': 'គោលការណ៍ឯកជន',
      'terms_service': 'លក្ខខណ្ឌសេវាកម្ម',
      'app_version': 'កំណែកម្មវិធី',
      'rate_app': 'វាយតម្លៃកម្មវិធី',
      'help_support': 'ជំនួយ និងការគាំទ្រ',
      'select_language': 'ជ្រើសរើសភាសា',
      'select_currency': 'ជ្រើសរើសរូបិយប័ណ្ណ',

      'lang_english': 'អង់គ្លេស',
      'lang_khmer': 'ខ្មែរ',
      'lang_chinese': 'ចិន',
      'lang_thai': 'ថៃ',
      'lang_vietnamese': 'វៀតណាម',

      // ═══════════════════════════════════════════════════════════
      // Favorites
      // ═══════════════════════════════════════════════════════════
      'my_favorites': 'ចំណូលចិត្តរបស់ខ្ញុំ',
      'favorites_restaurants_count': 'ភោជនីយដ្ឋាន ({count})',
      'favorites_foods_count': 'មុខម្ហូប ({count})',
      'no_fav_restaurants': 'មិនទាន់មានភោជនីយដ្ឋានចំណូលចិត្ត',
      'no_fav_restaurants_sub': 'ចុចបេះដូងលើភោជនីយដ្ឋានដើម្បីរក្សាទុកនៅទីនេះ។',
      'no_fav_foods': 'មិនទាន់មានមុខម្ហូបចំណូលចិត្ត',
      'no_fav_foods_sub': 'ចុចបេះដូងលើមុខម្ហូបដើម្បីរក្សាទុកនៅទីនេះ។',
      'no_favorites': 'មិនទាន់មានចំណូលចិត្ត',
      'no_favorites_sub':
          'ចាប់ផ្តើមបន្ថែមភោជនីយដ្ឋាន និងមុខម្ហូប\nចំណូលចិត្តរបស់អ្នក!',
      'explore_restaurants': 'រុករកភោជនីយដ្ឋាន',

      // ═══════════════════════════════════════════════════════════
      // Food Item Detail
      // ═══════════════════════════════════════════════════════════
      'added_to_cart': 'បានបន្ថែម {qty} × {name} ទៅកន្ត្រក',
      'choose_size': 'ជ្រើសរើសទំហំ',
      'size_regular': 'ធម្មតា',
      'size_large': 'ធំ',
      'size_large_price': 'ធំ (+ \$1.50)',
      'add_extra_toppings': 'បន្ថែមគ្រឿងផ្សំ',
      'topping_double_salmon': 'សាល់ម៉ុនទ្វេ (+ \$3.50)',
      'topping_avocado': 'អាវ៉ូកាដូ (+ \$1.20)',
      'topping_seeds': 'គ្រាប់ពូជបន្ថែម (+ \$0.50)',
      'topping_double_salmon_label': 'សាល់ម៉ុនទ្វេ',
      'topping_avocado_label': 'អាវ៉ូកាដូ',
      'topping_seeds_label': 'គ្រាប់ពូជបន្ថែម',

      // ═══════════════════════════════════════════════════════════
      // Notifications
      // ═══════════════════════════════════════════════════════════
      'failed_load_notifications': 'មិនអាចផ្ទុកការជូនដំណឹងបាន',
      'no_notifications': 'មិនទាន់មានការជូនដំណឹង',
      'no_notifications_sub':
          'អ្នកនឹងឃើញព័ត៌មានអំពីការបញ្ជាទិញ\nនិងប្រូម៉ូនៅទីនេះ។',
      'just_now': 'ទើបតែឥឡូវ',
      'minutes_ago': '{n} នាទីមុន',
      'hours_ago': '{n} ម៉ោងមុន',
      'hours_ago_plural': '{n} ម៉ោងមុន',
      'days_ago': '{n} ថ្ងៃមុន',
      'days_ago_plural': '{n} ថ្ងៃមុន',

      // ═══════════════════════════════════════════════════════════
      // Order Confirm
      // ═══════════════════════════════════════════════════════════
      'order_confirmed': 'ការបញ្ជាទិញត្រូវបានបញ្ជាក់',
      'package_on_the_way': 'កញ្ចប់របស់អ្នកកំពុងធ្វើដំណើរ',
      'estimated_delivery': 'ការដឹកជញ្ជូនប៉ាន់ស្មាន',
      'order_number': 'លេខការបញ្ជាទិញ',
      'track_my_order': 'តាមដានការបញ្ជាទិញរបស់ខ្ញុំ',
      'back_to_home': 'ត្រឡប់ទៅទំព័រដើម',

      // ═══════════════════════════════════════════════════════════
      // Change Password
      // ═══════════════════════════════════════════════════════════
      'password_requirements':
          'ពាក្យសម្ងាត់ថ្មីត្រូវមានយ៉ាងហោចណាស់ 8 តួអក្សរ និងមានទាំងអក្សរ និងលេខ។',
      'current_password': 'ពាក្យសម្ងាត់បច្ចុប្បន្ន',
      'enter_current_password': 'បញ្ចូលពាក្យសម្ងាត់បច្ចុប្បន្ន',
      'please_enter_current_password': 'សូមបញ្ចូលពាក្យសម្ងាត់បច្ចុប្បន្ន',
      'new_password': 'ពាក្យសម្ងាត់ថ្មី',
      'enter_new_password': 'បញ្ចូលពាក្យសម្ងាត់ថ្មី',
      'please_enter_password': 'សូមបញ្ចូលពាក្យសម្ងាត់',
      'must_be_8_chars': 'ត្រូវមានយ៉ាងហោចណាស់ 8 តួអក្សរ',
      'must_contain_letters': 'ត្រូវមានអក្សរ',
      'must_contain_numbers': 'ត្រូវមានលេខ',
      'confirm_new_password': 'បញ្ជាក់ពាក្យសម្ងាត់ថ្មី',
      'reenter_new_password': 'បញ្ចូលពាក្យសម្ងាត់ថ្មីម្តងទៀត',
      'please_confirm_password': 'សូមបញ្ជាក់ពាក្យសម្ងាត់',
      'passwords_do_not_match': 'ពាក្យសម្ងាត់មិនត្រូវគ្នា',
      'update_password': 'ធ្វើបច្ចុប្បន្នភាពពាក្យសម្ងាត់',
      'password_updated_success': 'ពាក្យសម្ងាត់បានធ្វើបច្ចុប្បន្នភាពដោយជោគជ័យ',

      // ═══════════════════════════════════════════════════════════
      // Help & Support
      // ═══════════════════════════════════════════════════════════
      'banner_title': 'យើងនៅទីនេះដើម្បីជួយ',
      'banner_subtitle': 'ស្វែងរកចម្លើយ ឬទាក់ទងក្រុមការងាររបស់យើង',
      'contact_us': 'ទាក់ទងយើង',
      'faq': 'សំណួរញឹកញាប់',
      'live_chat': 'ជជែកផ្ទាល់',
      'available_24_7': 'មានជូន 24/7',
      'email_support': 'ជំនួយតាមអ៊ីមែល',
      'call_us': 'ទូរស័ព្ទ',
      'still_need_help':
          'ត្រូវការជំនួយបន្ថែម? ជជែកជាមួយក្រុមការងាររបស់យើង — យើងភាគច្រើនឆ្លើយតបក្នុងរយៈពេលពីរបីនាទី។',

      'faq_q1': 'តើខ្ញុំតាមដានការបញ្ជាទិញរបស់ខ្ញុំដូចម្តេច?',
      'faq_a1':
          'នៅពេលការបញ្ជាទិញរបស់អ្នកត្រូវបានបញ្ជាក់ សូមចូលទៅប្រវត្តិការបញ្ជាទិញក្នុងប្រវត្តិរូបរបស់អ្នក។ ចុចលើការបញ្ជាទិញដែលអ្នកចង់តាមដាន ហើយជ្រើសរើស "តាមដានការបញ្ជាទិញ" ដើម្បីមើលបច្ចុប្បន្នភាពជាក់ស្តែង។',
      'faq_q2': 'តើខ្ញុំអាចបោះបង់ការបញ្ជាទិញរបស់ខ្ញុំបានទេ?',
      'faq_a2':
          'បាទ/ចាស អ្នកអាចបោះបង់ការបញ្ជាទិញមុនពេលភោជនីយដ្ឋានចាប់ផ្តើមរៀបចំ។ សូមចូលទៅប្រវត្តិការបញ្ជាទិញ បើកការបញ្ជាទិញ ហើយចុច "បោះបង់ការបញ្ជាទិញ"។ នៅពេលការរៀបចំបានចាប់ផ្តើម ការបោះបង់អាចមិនអាចធ្វើទៅបាន។',
      'faq_q3': 'តើអ្នកទទួលយកវិធីទូទាត់អ្វីខ្លះ?',
      'faq_a3':
          'យើងទទួលយក Visa, Mastercard, ABA Pay, Wing និងប្រាក់សុទ្ធពេលប្រគល់។ អ្នកអាចគ្រប់គ្រងវិធីទូទាត់របស់អ្នកនៅក្នុងអេក្រង់ការកំណត់កម្មវិធី។',
      'faq_q4': 'តើខ្ញុំស្នើសុំសងប្រាក់វិញដូចម្តេច?',
      'faq_a4':
          'ប្រសិនបើមានបញ្ហាជាមួយការបញ្ជាទិញរបស់អ្នក សូមចូលទៅប្រវត្តិការបញ្ជាទិញ បើកការបញ្ជាទិញដែលរងផលប៉ះពាល់ ហើយចុច "រាយការណ៍បញ្ហា"។ ក្រុមការងារជំនួយរបស់យើងនឹងពិនិត្យក្នុងរយៈពេល 24 ម៉ោង។',
      'faq_q5': 'តើខ្ញុំប្តូរអាស័យដ្ឋានដឹកជញ្ជូនរបស់ខ្ញុំដូចម្តេច?',
      'faq_a5':
          'ចូលទៅប្រវត្តិរូប → អាស័យដ្ឋានដែលបានរក្សាទុករបស់ខ្ញុំ ដើម្បីបន្ថែម កែប្រែ ឬលុបអាស័យដ្ឋានដឹកជញ្ជូន។ អ្នកក៏អាចកំណត់អាស័យដ្ឋានលំនាំដើមសម្រាប់ការបង់ប្រាក់លឿនជាង។',
      'faq_q6': 'តើមានចំនួនបញ្ជាទិញអប្បបរមាទេ?',
      'faq_a6':
          'ចំនួនបញ្ជាទិញអប្បបរមាប្រែប្រួលតាមភោជនីយដ្ឋាន។ អ្នកនឹងឃើញតម្រូវការនៅលើទំព័រភោជនីយដ្ឋាននីមួយៗ និងពេលបង់ប្រាក់។',
      'faq_q7': 'តើខ្ញុំអាចទាក់ទងអ្នកដឹកជញ្ជូនដូចម្តេច?',
      'faq_a7':
          'នៅពេលការបញ្ជាទិញរបស់អ្នកកំពុងដឹកជញ្ជូន អ្នកនឹងឃើញប៊ូតុង "ហៅអ្នកដឹក" នៅលើអេក្រង់តាមដានការបញ្ជាទិញ។ សូមប្រើវាសម្រាប់តែបញ្ហាទាក់ទងនឹងការដឹកជញ្ជូនប៉ុណ្ណោះ។',

      // ═══════════════════════════════════════════════════════════
      // App Version
      // ═══════════════════════════════════════════════════════════
      'app_name': 'Miko Delivery',
      'version_build': 'កំណែ {version} (Build {build})',
      'up_to_date': 'ទាន់សម័យ',
      'build_info': 'ព័ត៌មាន Build',
      'version': 'កំណែ',
      'build_number': 'លេខ Build',
      'release_date': 'កាលបរិច្ឆេទចេញផ្សាយ',
      'platform': 'វេទិកា',
      'whats_new': 'អ្វីថ្មី',
      'footer_rights': '© 2026 Miko Delivery. រក្សាសិទ្ធិគ្រប់យ៉ាង។',

      'changelog_100_1': '🎉 ការចេញផ្សាយដំបូងរបស់ Miko Delivery',
      'changelog_100_2': '🍜 រកមើលភោជនីយដ្ឋាន និងបញ្ជាទិញអាហារ',
      'changelog_100_3': '🚚 តាមដានការបញ្ជាទិញជាក់ស្តែង',
      'changelog_100_4': '❤️ រក្សាទុកមុខម្ហូបចំណូលចិត្តរបស់អ្នក',
      'changelog_100_5': '📍 អាស័យដ្ឋានដឹកជញ្ជូនច្រើន',
      'changelog_090_1': 'ដំណាក់កាលសាកល្បងបេតា',
      'changelog_090_2': 'ការជួសជុលកំហុស និងការកែលម្អសមត្ថភាព',

      // ═══════════════════════════════════════════════════════════
      // Privacy Policy
      // ═══════════════════════════════════════════════════════════
      'last_updated': 'បានធ្វើបច្ចុប្បន្នភាពចុងក្រោយ: {date}',
      'section_intro_title': '១. ការណែនាំ',
      'section_info_collect_title': '២. ព័ត៌មានដែលយើងប្រមូល',
      'section_use_info_title': '៣. វិធីប្រើប្រាស់ព័ត៌មានរបស់អ្នក',
      'section_share_info_title': '៤. ការចែករំលែកព័ត៌មានរបស់អ្នក',
      'section_data_security_title': '៥. សុវត្ថិភាពទិន្នន័យ',
      'section_rights_title': '៦. សិទ្ធិរបស់អ្នក',
      'section_children_title': '៧. ឯកជនភាពកុមារ',
      'section_changes_title': '៨. ការផ្លាស់ប្តូរនៅក្នុងគោលការណ៍នេះ',
      'section_contact_title': '៩. ទាក់ទងយើង',

      'privacy_intro_body':
          'សូមស្វាគមន៍មកកាន់ Miko Delivery។ យើងគោរពឯកជនភាពរបស់អ្នក និងប្តេជ្ញាការពារទិន្នន័យផ្ទាល់ខ្លួនរបស់អ្នក។ គោលការណ៍ឯកជនភាពនេះពន្យល់ពីរបៀបដែលយើងប្រមូល ប្រើប្រាស់ បង្ហាញ និងការពារព័ត៌មានរបស់អ្នក នៅពេលអ្នកប្រើកម្មវិធីទូរស័ព្ទរបស់យើង។',
      'privacy_collect_body':
          'យើងអាចប្រមូលព័ត៌មានប្រភេទដូចខាងក្រោម៖\n\n'
          '• ព័ត៌មានផ្ទាល់ខ្លួន៖ ឈ្មោះ អ៊ីមែល លេខទូរស័ព្ទ និងអាស័យដ្ឋានដឹកជញ្ជូន។\n'
          '• ព័ត៌មានទូទាត់៖ ព័ត៌មានកាត (ដំណើរការដោយសុវត្ថិភាពដោយអ្នកផ្តល់សេវាទូទាត់ភាគីទីបី)។\n'
          '• ទិន្នន័យទីតាំង៖ ទីតាំង GPS ដើម្បីផ្តល់សេវាដឹកជញ្ជូន និងបង្ហាញភោជនីយដ្ឋានក្បែរ។\n'
          '• ទិន្នន័យប្រើប្រាស់៖ អន្តរកម្មកម្មវិធី ប្រវត្តិការបញ្ជាទិញ និងចំណូលចិត្ត។\n'
          '• ព័ត៌មានឧបករណ៍៖ ម៉ូដែលឧបករណ៍ កំណែ OS និងលេខសម្គាល់ឧបករណ៍តែមួយគត់។',
      'privacy_use_info_body':
          'យើងប្រើព័ត៌មានដែលប្រមូលបានដើម្បី៖\n\n'
          '• ដំណើរការ និងដឹកជញ្ជូនការបញ្ជាទិញរបស់អ្នក។\n'
          '• ធ្វើឱ្យបទពិសោធន៍កម្មវិធីរបស់អ្នកមានលក្ខណៈផ្ទាល់ខ្លួន។\n'
          '• ផ្ញើបច្ចុប្បន្នភាពការបញ្ជាទិញ និងការផ្តល់ជូនផ្សព្វផ្សាយ (ដោយមានការយល់ព្រមរបស់អ្នក)។\n'
          '• កែលម្អសេវាកម្មរបស់យើង និងការពារការឆបោក។\n'
          '• អនុលោមតាមកាតព្វកិច្ចផ្លូវច្បាប់។',
      'privacy_share_info_body':
          'យើងមិនលក់ទិន្នន័យផ្ទាល់ខ្លួនរបស់អ្នកទេ។ យើងអាចចែករំលែកវាជាមួយ៖\n\n'
          '• ភោជនីយដ្ឋាន និងដៃគូដឹកជញ្ជូន ដើម្បីបំពេញការបញ្ជាទិញរបស់អ្នក។\n'
          '• អ្នកដំណើរការទូទាត់ ដើម្បីបញ្ចប់ប្រតិបត្តិការ។\n'
          '• អ្នកផ្តល់សេវា ដែលជួយប្រតិបត្តិការរបស់យើង។\n'
          '• អាជ្ញាធរអនុវត្តច្បាប់ នៅពេលច្បាប់តម្រូវ។',
      'privacy_data_security_body':
          'យើងអនុវត្តវិធានការសុវត្ថិភាពស្តង់ដារឧស្សាហកម្ម ដើម្បីការពារទិន្នន័យរបស់អ្នក រួមទាំងការអ៊ិនគ្រីប ម៉ាស៊ីនមេសុវត្ថិភាព និងការគ្រប់គ្រងការចូលប្រើ។ ទោះជាយ៉ាងណា គ្មានវិធីសាស្ត្របញ្ជូនណាមួយតាមអ៊ីនធឺណិតមានសុវត្ថិភាព 100% ទេ។',
      'privacy_rights_body':
          'អ្នកមានសិទ្ធិ៖\n\n'
          '• ចូលប្រើ កែតម្រូវ ឬលុបទិន្នន័យផ្ទាល់ខ្លួនរបស់អ្នក។\n'
          '• បដិសេធការទំនាក់ទំនងទីផ្សារ។\n'
          '• ដកការយល់ព្រមបានគ្រប់ពេល។\n'
          '• ដាក់ពាក្យបណ្តឹងទៅអាជ្ញាធរត្រួតពិនិត្យ។',
      'privacy_children_body':
          'សេវាកម្មរបស់យើងមិនមានបំណងសម្រាប់កុមារក្រោមអាយុ 13 ឆ្នាំទេ។ យើងមិនប្រមូលទិន្នន័យពីកុមារដោយដឹងខ្លួនទេ។ ប្រសិនបើអ្នកជឿថាយើងបានធ្វើ សូមទាក់ទងយើងភ្លាមៗ។',
      'privacy_changes_body':
          'យើងអាចធ្វើបច្ចុប្បន្នភាពគោលការណ៍ឯកជនភាពនេះពីពេលមួយទៅពេលមួយ។ យើងនឹងជូនដំណឹងអ្នកអំពីការផ្លាស់ប្តូរសំខាន់ៗតាមរយៈកម្មវិធី ឬអ៊ីមែល។',
      'privacy_contact_body':
          'ប្រសិនបើអ្នកមានសំណួរអំពីគោលការណ៍ឯកជនភាពនេះ សូមទាក់ទងយើងតាម៖\n\n'
          '• អ៊ីមែល៖ privacy@mikodelivery.com\n'
          '• ទូរស័ព្ទ៖ +855 777 3721\n'
          '• អាស័យដ្ឋាន៖ Green Garden, Apt 4B, ភ្នំពេញ, កម្ពុជា',

      // ═══════════════════════════════════════════════════════════
      // Terms of Service
      // ═══════════════════════════════════════════════════════════
      'section_acceptance_title': '១. ការទទួលយកលក្ខខណ្ឌ',
      'section_eligibility_title': '២. សិទ្ធិចូលរួម',
      'section_account_title': '៣. ការចុះឈ្មោះគណនី',
      'section_orders_title': '៤. ការបញ្ជាទិញ និងការទូទាត់',
      'section_delivery_title': '៥. ការដឹកជញ្ជូន',
      'section_refunds_title': '៦. ការសងប្រាក់ និងការបោះបង់',
      'section_prohibited_title': '៧. អាកប្បកិរិយាដែលហាមឃាត់',
      'section_ip_title': '៨. មូលសិទ្ធិបញ្ញា',
      'section_liability_title': '៩. ការទទួលខុសត្រូវ',
      'section_termination_title': '១០. ការបញ្ចប់',
      'section_law_title': '១១. ច្បាប់គ្រប់គ្រង',
      'section_contact_terms_title': '១២. ទាក់ទងយើង',

      'terms_acceptance_body':
          'តាមរយៈការទាញយក ចូលប្រើ ឬប្រើកម្មវិធីទូរស័ព្ទ Miko Delivery អ្នកយល់ព្រមចងភ្ជាប់ដោយលក្ខខណ្ឌសេវាកម្មទាំងនេះ។ ប្រសិនបើអ្នកមិនយល់ព្រម សូមកុំប្រើសេវាកម្មរបស់យើង។',
      'terms_eligibility_body':
          'អ្នកត្រូវមានអាយុយ៉ាងហោចណាស់ 18 ឆ្នាំ ដើម្បីបង្កើតគណនី និងបញ្ជាទិញ។ តាមរយៈការប្រើកម្មវិធី អ្នកបញ្ជាក់ថាអ្នកបំពេញតម្រូវការនេះ។',
      'terms_account_body':
          'អ្នកទទួលខុសត្រូវចំពោះ៖\n\n'
          '• ការផ្តល់ព័ត៌មានត្រឹមត្រូវ និងពេញលេញ។\n'
          '• ការរក្សាការសម្ងាត់នៃព័ត៌មានចូលគណនីរបស់អ្នក។\n'
          '• សកម្មភាពទាំងអស់ដែលកើតឡើងក្រោមគណនីរបស់អ្នក។\n\n'
          'សូមជូនដំណឹងយើងភ្លាមៗ ប្រសិនបើអ្នកសង្ស័យថាមានការចូលប្រើដោយគ្មានការអនុញ្ញាត។',
      'terms_orders_body':
          '• ការបញ្ជាទិញទាំងអស់អាស្រ័យលើការទទួលយក និងភាពអាចរកបាន។\n'
          '• តម្លៃត្រូវបានបង្ហាញក្នុងកម្មវិធី ហើយអាចផ្លាស់ប្តូរដោយគ្មានការជូនដំណឹង។\n'
          '• ការទូទាត់ត្រូវបញ្ចប់មុនពេលដឹកជញ្ជូន។\n'
          '• យើងរក្សាសិទ្ធិបោះបង់ការបញ្ជាទិញដោយសារកំហុស ការឆបោក ឬបញ្ហាស្តុក។',
      'terms_delivery_body':
          '• ពេលវេលាដឹកជញ្ជូនប៉ាន់ស្មានមិនត្រូវបានធានាទេ។\n'
          '• អ្នកត្រូវផ្តល់អាស័យដ្ឋានដឹកជញ្ជូនត្រឹមត្រូវ។\n'
          '• ប្រសិនបើគ្មាននរណាម្នាក់ទទួលការបញ្ជាទិញ វាអាចត្រូវបានទុកនៅមុខទ្វារ ឬត្រឡប់មកវិញដោយចំណាយរបស់អ្នក។',
      'terms_refunds_body':
          '• ការបញ្ជាទិញអាចបោះបង់មុនពេលការរៀបចំចាប់ផ្តើម។\n'
          '• ការសងប្រាក់វិញត្រូវបានចេញតាមការសម្រេចចិត្តរបស់យើងក្នុងករណីមុខម្ហូបមិនត្រឹមត្រូវ ឬបាត់។\n'
          '• សូមទាក់ទងជំនួយក្នុងរយៈពេល 24 ម៉ោងបន្ទាប់ពីការដឹកជញ្ជូនសម្រាប់បញ្ហាណាមួយ។',
      'terms_prohibited_body':
          'អ្នកយល់ព្រមមិន៖\n\n'
          '• ប្រើកម្មវិធីសម្រាប់គោលបំណងខុសច្បាប់។\n'
          '• ក្លែងបន្លំអ្នកដទៃ ឬបង្ហាញអត្តសញ្ញាណខុស។\n'
          '• ជ្រៀតជ្រែកប្រតិបត្តិការ ឬសុវត្ថិភាពកម្មវិធី។\n'
          '• បង្ហោះការវាយតម្លៃមិនពិត ឬខ្លឹមសារបំពាន។',
      'terms_ip_body':
          'ខ្លឹមសារទាំងអស់ក្នុងកម្មវិធី — រូបសញ្ញា អក្សរ រូបភាព និងកូដ — ជាកម្មសិទ្ធិរបស់ Miko Delivery ឬអ្នកផ្តល់អាជ្ញាបណ្ណរបស់ខ្លួន។ អ្នកមិនអាចចម្លង កែប្រែ ឬចែកចាយដោយគ្មានការអនុញ្ញាតទេ។',
      'terms_liability_body':
          'Miko Delivery មិនទទួលខុសត្រូវចំពោះការខូចខាតដោយប្រយោល ចៃដន្យ ឬជាលទ្ធផលដែលកើតឡើងពីការប្រើកម្មវិធីរបស់អ្នក ក្នុងកម្រិតអតិបរមាដែលច្បាប់អនុញ្ញាត។',
      'terms_termination_body':
          'យើងអាចផ្អាក ឬបញ្ចប់គណនីរបស់អ្នកបានគ្រប់ពេលសម្រាប់ការបំពានលក្ខខណ្ឌទាំងនេះ។ អ្នកអាចលុបគណនីរបស់អ្នកបានគ្រប់ពេលតាមរយៈការកំណត់កម្មវិធី។',
      'terms_law_body':
          'លក្ខខណ្ឌទាំងនេះត្រូវបានគ្រប់គ្រងដោយច្បាប់កម្ពុជា។ វិវាទណាមួយនឹងត្រូវបានដោះស្រាយនៅតុលាការភ្នំពេញ។',
      'terms_contact_body':
          'សម្រាប់សំណួរអំពីលក្ខខណ្ឌទាំងនេះ សូមទាក់ទងយើងតាម៖\n\n'
          '• អ៊ីមែល៖ legal@mikodelivery.com\n'
          '• ទូរស័ព្ទ៖ +855 777 3721',
      // ── Payment method (checkout) ──
      'pay_cash': 'បង់ប្រាក់ជាសាច់ប្រាក់',
      'pay_khqr': 'បង់ប្រាក់តាម KHQR',
      'payment_method': 'វិធីទូទាត់',
      'choose_payment_method': 'ជ្រើសរើសវិធីទូទាត់របស់អ្នក',
      'cash_on_delivery': 'សាច់ប្រាក់ពេលប្រគល់',
      'pay_when_you_receive': 'បង់ប្រាក់ឱ្យអ្នកដឹកជញ្ជូនពេលការបញ្ជាទិញមកដល់',
      'khqr_payment': 'KHQR / បាគង',
      'pay_now_with_bakong': 'ស្កេន QR ជាមួយកម្មវិធីធនាគារដែលប្រើ Bakong',

      // ── KHQR sheet ──
      'scan_to_pay': 'ស្កេនដើម្បីបង់ប្រាក់',
      'waiting_for_payment': 'កំពុងរង់ចាំការទូទាត់…',
      'qr_expires_in': 'QR ផុតកំណត់ក្នុង',
      'qr_expired': 'QR ផុតកំណត់ហើយ',
      'payment_successful': 'ការទូទាត់បានជោគជ័យ',
      'amount_added_to_balance': '\${amount} ត្រូវបានបន្ថែមទៅសមតុល្យរបស់អ្នក',
      'new_balance': 'សមតុល្យថ្មី',
      'done': 'រួចរាល់',
      'generate_new_qr': 'បង្កើត QR ថ្មី',
      'something_went_wrong': 'មានបញ្ហាកើតឡើង',
      'unable_to_verify_payment': 'មិនអាចផ្ទៀងផ្ទាត់ការទូទាត់បាន',
      'failed_to_generate_qr': 'មិនអាចបង្កើត QR បាន',
      'close': 'បិទ',
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
