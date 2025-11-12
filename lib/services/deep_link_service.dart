import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/brand_colors.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void initialize(BuildContext context) {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) => _handleDeepLink(context, uri),
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  void _handleDeepLink(BuildContext context, Uri uri) {
    debugPrint('Received deep link: $uri');

    // Handle different auth-related deep links
    if (uri.path == '/auth/login') {
      // Navigate to login screen
      context.push('/login');
    } else if (uri.path == '/auth/confirmed') {
      // Show email confirmation success message
      _showEmailConfirmedDialog(context);
    }
  }

  void _showPasswordResetMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BrandColors.neutralVariantBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: BrandColors.successBright,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Password Reset Complete',
                style: GoogleFonts.poppins(
                  color: BrandColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Your password has been successfully updated on the website. You can now sign in with your new password.',
            style: GoogleFonts.inter(
              color: BrandColors.textMuted,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/login');
              },
              style: TextButton.styleFrom(
                backgroundColor: BrandColors.info,
                foregroundColor: BrandColors.textPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Go to Login',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEmailConfirmedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BrandColors.neutralVariantBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: BrandColors.successBright,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Email Confirmed!',
                style: GoogleFonts.poppins(
                  color: BrandColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Your email has been successfully verified. You can now access all features of the app.',
            style: GoogleFonts.inter(
              color: BrandColors.textMuted,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: BrandColors.info,
                foregroundColor: BrandColors.textPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Got it',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: BrandColors.neutralVariantBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: BrandColors.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Error',
                style: GoogleFonts.poppins(
                  color: BrandColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.inter(
              color: BrandColors.textMuted,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: BrandColors.error,
                foregroundColor: BrandColors.textPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
