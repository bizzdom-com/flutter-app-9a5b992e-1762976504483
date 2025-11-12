import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/brand_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updatePassword(
          newPassword: _passwordController.text);

      if (!mounted) return;

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!'),
            backgroundColor: BrandColors.successBright,
          ),
        );

        // Navigate back to main app
        context.go('/customer');
      } else {
        // Show error from auth provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating password: ${authProvider.error}'),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating password: $e'),
          backgroundColor: BrandColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.neutralBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(
            color: BrandColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Header
              Icon(
                Icons.lock_reset,
                size: 64,
                color: BrandColors.info,
              ),
              const SizedBox(height: 24),

              Text(
                'Set New Password',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: BrandColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Enter your new password below. Make sure it\'s secure and memorable.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: BrandColors.textMuted,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              // New Password Field
              Container(
                decoration: BoxDecoration(
                  color: BrandColors.neutralVariantBase,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: BrandColors.mutedSlate,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: GoogleFonts.inter(
                      color: BrandColors.textMuted,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              Container(
                decoration: BoxDecoration(
                  color: BrandColors.neutralVariantBase,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: BrandColors.mutedSlate,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: GoogleFonts.inter(
                      color: BrandColors.textMuted,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),

              // Update Password Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BrandColors.info, BrandColors.infoBright],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.info.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Update Password',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Cancel Button
              TextButton(
                onPressed: _isLoading ? null : () => context.pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: BrandColors.textMuted,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
