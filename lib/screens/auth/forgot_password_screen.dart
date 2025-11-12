import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/brand_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _emailSent = false;
  bool _isEmailFocused = false;

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late AnimationController _successAnimationController;
  late Animation<double> _successScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _successScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));

    // Add focus listener
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _buttonAnimationController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
      _successAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BrandColors.background,
              BrandColors.backgroundAlt,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _emailSent ? _buildEmailSentView() : _buildResetForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSentView() {
    return AnimatedBuilder(
      animation: _successScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _successScaleAnimation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Icon
              Hero(
                tag: 'app_icon',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [BrandColors.success, BrandColors.successDeep],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: BrandColors.success.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                'CHECK YOUR EMAIL',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                'We\'ve sent a password reset link to:',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: BrandColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Email address
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: AppTheme.neuromorphicDecoration(
                  color: BrandColors.surfaceElevated,
                ),
                child: Text(
                  _emailController.text.trim(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.neuromorphicDecoration(
                  color: BrandColors.surfaceElevated,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrandColors.accent.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: BrandColors.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please check your inbox and click the reset link to create a new password. The link will expire in 1 hour.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: BrandColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Back to Login Button
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BrandColors.primary, BrandColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'BACK TO LOGIN',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend Link
              TextButton(
                onPressed: () {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  authProvider.clearError();
                  _successAnimationController.reset();
                  setState(() {
                    _emailSent = false;
                  });
                },
                child: Text(
                  'Send to a different email',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.accent,
                    decoration: TextDecoration.underline,
                    decorationColor: BrandColors.accent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Icon
          Hero(
            tag: 'app_icon',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [BrandColors.primary, BrandColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: BrandColors.accent.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            'FORGOT PASSWORD',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Enter your email to reset',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: BrandColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Email Input
          Container(
            decoration: AppTheme.inputDecoration(isFocused: _isEmailFocused),
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: GoogleFonts.inter(
                  color: BrandColors.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: BrandColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 32),

          // Reset Password Button
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [BrandColors.primary, BrandColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: BrandColors.accent.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            authProvider.isLoading ? null : _sendResetEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'RESET PASSWORD',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Error Message
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.error != null) {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.neuromorphicDecoration(
                    color: BrandColors.errorContainer,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: BrandColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          authProvider.error!,
                          style: GoogleFonts.inter(
                            color: BrandColors.errorTint,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 32),

          // Back to Login Link
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                'Remember your password? Sign In',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: BrandColors.accent,
                  decoration: TextDecoration.underline,
                  decorationColor: BrandColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
