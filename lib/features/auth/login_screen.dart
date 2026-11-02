import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/routes/route_names.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_text_style_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    // Access our custom theme colors and text styles
    final c = context.colors;
    final textStyles = AppTextStylesX(context);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Top Image ──
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/Store editorial.png',
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200,
                                  // ✅ FIXED: was c.surfaceLight
                                  color: c.surfaceTint,
                                  child: Icon(
                                    Icons.store,
                                    size: 50,
                                    // ✅ FIXED: was c.textMuted
                                    color: c.primaryCoral,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Headers ──
                        Text(
                          'A good day starts here.',
                          style:
                              textStyles.heading1, // Using your global heading1
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in and make every sale feel effortless.',
                          style: textStyles
                              .bodyMedium, // Using your global bodyMedium
                        ),
                        const SizedBox(height: 24),

                        // ── Form ──
                        Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Work Email Label
                              Text('Work email', style: textStyles.labelMedium),
                              const SizedBox(height: 8),
                              _buildTextField(
                                context: context,
                                c: c,
                                textStyles: textStyles,
                                hintText: 'alex@foldstore.com',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),

                              // Password Label
                              Text('Password', style: textStyles.labelMedium),
                              const SizedBox(height: 8),
                              _buildTextField(
                                context: context,
                                c: c,
                                textStyles: textStyles,
                                hintText: '••••••••••••',
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                              ),

                              const SizedBox(height: 12),

                              // Remember Me & Forgot Password Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: c.primaryCoral,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: c.textMuted,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remember this store',
                                        // using labelSmall or bodySmall for the checkbox text
                                        style: textStyles.labelSmall.copyWith(
                                          color: c.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.pushNamed(
                                        RouteNames.forgetPasswordName,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Forgot password?',
                                      // Using labelSmall but overriding color to match primary
                                      style: textStyles.labelSmall.copyWith(
                                        color: c.primaryCoral,
                                        fontWeight: FontWeight
                                            .w700, // make it pop a bit more
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ── Spacer pushes the bottom elements down ──
                        const Spacer(),

                        // ── Bottom Submit Button ──
                        ElevatedButton(
                          onPressed: () {
                            context.pushNamed(RouteNames.storeRegisterName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primaryCoral,
                            foregroundColor: c.textLight,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: c.textLight,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sign in to your store',
                                style: textStyles.labelMedium.copyWith(
                                  color: c.textLight,
                                  fontSize:
                                      16, // Slightly larger for button text
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Footer text ──
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            // Use bodySmall for footer
                            style: textStyles.bodySmall,
                            children: [
                              const TextSpan(text: 'Need access? '),
                              TextSpan(
                                text: 'Contact your store manager.',
                                style: textStyles.bodySmall.copyWith(
                                  color: c
                                      .textPrimary, // slightly darker than muted
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Helper Widget for Text Fields ──
  Widget _buildTextField({
    required BuildContext context,
    required AppThemeColors c,
    required AppTextStylesX textStyles,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: textStyles.bodyLarge, // Use global input text style
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyles.bodyLarge.copyWith(color: c.textMuted),
        filled: true,
        fillColor: c.surfaceLight,
        prefixIcon: Icon(icon, color: c.textMuted, size: 22),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primaryCoral, width: 1.5),
        ),
      ),
    );
  }
}
