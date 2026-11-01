import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_system/providers/store_provider.dart';
import 'package:pos_system/shared/helper/safe_pop.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  // Controllers for the form fields
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _timeZoneController = TextEditingController();

  bool _isFieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    // 👇 TRIGGER THE FETCH when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().fetchStore();
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    _currencyController.dispose();
    _timeZoneController.dispose();
    super.dispose();
  }

  // 👇 Populate fields from the provider once data is available
  void _populateFieldsFromProvider(StoreProvider provider) {
    final store = provider.store;
    if (store != null && !_isFieldsPopulated) {
      _storeNameController.text = store.name;
      _streetAddressController.text = store.addressLine;
      _cityController.text = store.city;
      _zipCodeController.text = store.zipCode;
      _phoneController.text = store.phone;
      _currencyController.text = store.currency;
      _timeZoneController.text = store.timeZone;
      _isFieldsPopulated = true;
    }
  }

  Future<void> _saveStoreDetails() async {
    final storeProvider = context.read<StoreProvider>();

    final success = await storeProvider.updateStore({
      'name': _storeNameController.text,
      'address_line': _streetAddressController.text,
      'city': _cityController.text,
      'zip_code': _zipCodeController.text,
      'phone': _phoneController.text,
      'currency': _currencyController.text,
      'time_zone': _timeZoneController.text,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Store details updated successfully'),
          backgroundColor: Color(0xFF137333),
        ),
      );
      context.safePop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            storeProvider.error ?? 'Failed to update store details',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final textStyles = AppTextStylesX(context);
    final storeProvider = context.watch<StoreProvider>();

    // 👇 Populate fields immediately when the data arrives (via notifyListeners)
    _populateFieldsFromProvider(storeProvider);

    // Show loading only when the store isn't loaded yet
    if (storeProvider.isLoading && storeProvider.store == null) {
      return Scaffold(
        backgroundColor: c.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store details',
                        style: textStyles.heading2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _storeNameController.text.isEmpty
                            ? 'Loading...'
                            : _storeNameController.text,
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
                    _buildInputGroup(
                      label: 'Store name',
                      controller: _storeNameController,
                      icon: Icons.store_outlined,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 20),
                    _buildInputGroup(
                      label: 'Street address',
                      controller: _streetAddressController,
                      icon: Icons.location_on_outlined,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputGroup(
                            label: 'City',
                            controller: _cityController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputGroup(
                            label: 'ZIP code',
                            controller: _zipCodeController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputGroup(
                      label: 'Store phone',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      c: c,
                      textStyles: textStyles,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputGroup(
                            label: 'Currency',
                            controller: _currencyController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputGroup(
                            label: 'Time zone',
                            controller: _timeZoneController,
                            c: c,
                            textStyles: textStyles,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FF),
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
                              'America/New_York · EST / EDT adjusts automatically. Address and phone appear on receipts.',
                              style: textStyles.bodySmall.copyWith(
                                color: c.primaryCoral,
                                height: 1.4,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Only store managers can update store details.',
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
                  ElevatedButton(
                    onPressed: storeProvider.isLoading
                        ? null
                        : _saveStoreDetails,
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
                    child: storeProvider.isLoading
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
                                'Save store details',
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
                  TextButton(
                    onPressed: () => context.safePop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF4F8FF),
                      foregroundColor: c.primaryCoral,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel changes',
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

  Widget _buildInputGroup({
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
