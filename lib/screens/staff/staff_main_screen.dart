import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/staff_provider.dart';
import 'staff_scanner_screen.dart';
import 'staff_history_screen.dart';
import '../../theme/brand_colors.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const StaffHomeScreen(),
      const StaffHistoryScreen(),
    ];

    return Scaffold(
      backgroundColor: BrandColors.neutralBase,
      appBar: AppBar(
        title: Text(
          'Staff Portal',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: BrandColors.neutralVariantBase,
        elevation: 0,
        iconTheme: IconThemeData(color: BrandColors.textPrimary),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: BrandColors.info.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.logout, color: BrandColors.info),
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: BrandColors.neutralVariantBase,
          border: Border(
            top: BorderSide(color: BrandColors.border, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: BrandColors.info.withOpacity(0.2),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.qr_code_scanner,
                color: _currentIndex == 0
                    ? BrandColors.info
                    : BrandColors.textMuted,
              ),
              label: 'Scanner',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.history,
                color: _currentIndex == 1
                    ? BrandColors.info
                    : BrandColors.textMuted,
              ),
              label: 'History',
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, StaffProvider>(
      builder: (context, authProvider, staffProvider, child) {
        final user = authProvider.user;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: BrandColors.neutralVariantBase,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BrandColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.info.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [BrandColors.info, BrandColors.infoDeep],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: BrandColors.info.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.badge,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome ${user?.name ?? 'Staff'}!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: BrandColors.info.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: BrandColors.info.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        user?.role.toUpperCase() ?? 'STAFF',
                        style: GoogleFonts.inter(
                          color: BrandColors.info,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.qr_code_scanner,
                      title: 'Scan Customer',
                      subtitle: 'Award Points',
                      gradient: LinearGradient(
                        colors: [BrandColors.info, BrandColors.infoDeep],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StaffScannerScreen(
                              scanType: ScanType.customer,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.redeem,
                      title: 'Scan Coupon',
                      subtitle: 'Redeem Reward',
                      gradient: LinearGradient(
                        colors: [
                          BrandColors.successBright,
                          BrandColors.success
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StaffScannerScreen(
                              scanType: ScanType.coupon,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (staffProvider.scannedCustomer != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: BrandColors.neutralVariantBase,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: BrandColors.info.withOpacity(0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: BrandColors.info.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: BrandColors.info.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: BrandColors.info,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Last Scanned Customer',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        staffProvider.scannedCustomer!.name ?? 'Customer',
                        style: GoogleFonts.inter(
                          color: BrandColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Balance: ${staffProvider.customerBalance?.pointsBalance ?? 0} points',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: BrandColors.info,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (staffProvider.scannedCoupon != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: BrandColors.neutralVariantBase,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: BrandColors.successBright.withOpacity(0.3),
                        width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: BrandColors.successBright.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  BrandColors.successBright.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.redeem,
                              color: BrandColors.successBright,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Last Scanned Coupon',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        staffProvider.scannedCoupon!.reward?.name ?? 'Reward',
                        style: GoogleFonts.inter(
                          color: BrandColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: staffProvider.scannedCoupon!.isActive
                              ? BrandColors.successBright.withOpacity(0.15)
                              : BrandColors.error.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: staffProvider.scannedCoupon!.isActive
                                ? BrandColors.successBright.withOpacity(0.3)
                                : BrandColors.error.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Status: ${staffProvider.scannedCoupon!.status.toUpperCase()}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: staffProvider.scannedCoupon!.isActive
                                ? BrandColors.successBright
                                : BrandColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
