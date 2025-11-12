import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../providers/rewards_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/reward_model.dart';
import '../../theme/brand_colors.dart';

class CustomerRewardsScreen extends StatefulWidget {
  const CustomerRewardsScreen({super.key});

  @override
  State<CustomerRewardsScreen> createState() => _CustomerRewardsScreenState();
}

class _CustomerRewardsScreenState extends State<CustomerRewardsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RewardsProvider>(context, listen: false).loadRewards();
    });
  }

  Future<void> _redeemReward(RewardModel reward) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final rewardsProvider =
        Provider.of<RewardsProvider>(context, listen: false);

    final user = authProvider.user;
    final balance = authProvider.customerBalance;

    if (user == null || balance == null) return;

    if (balance.pointsBalance < reward.costPoints) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Insufficient points! You need ${reward.costPoints} points but only have ${balance.pointsBalance}.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BrandColors.neutralVariantBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: BrandColors.border, width: 1),
        ),
        title: Text(
          'Confirm Redemption',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: BrandColors.textPrimary,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BrandColors.neutralBase,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BrandColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Redeem "${reward.name}"?',
                    style: GoogleFonts.inter(
                      color: BrandColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Cost', '${reward.costPoints} points'),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      'Your balance', '${balance.pointsBalance} points'),
                  const SizedBox(height: 4),
                  _buildInfoRow('Remaining after',
                      '${balance.pointsBalance - reward.costPoints} points'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: BrandColors.textMuted,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [BrandColors.pink, BrandColors.pinkDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Redeem',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: BrandColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await rewardsProvider.redeemReward(
        userId: user.id,
        rewardId: reward.id,
        costPoints: reward.costPoints,
      );

      if (mounted) {
        if (success) {
          await authProvider.refreshBalance();
          if (mounted) {
            _showSuccessAnimation(reward.name);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(rewardsProvider.error ?? 'Failed to redeem reward'),
              backgroundColor: BrandColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }

  void _showSuccessAnimation(String rewardName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: BrandColors.neutralVariantBase,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BrandColors.border, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie animation placeholder - you can add actual lottie file
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BrandColors.successBright, BrandColors.success],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.successBright.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: BrandColors.textPrimary,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Reward Redeemed!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: BrandColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Successfully redeemed "$rewardName"!',
                style: GoogleFonts.inter(
                  color: BrandColors.textMuted,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BrandColors.info, BrandColors.infoDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: BrandColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            color: BrandColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: BrandColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.neutralBase,
      appBar: AppBar(
        title: Text(
          'Rewards',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: BrandColors.textPrimary,
            fontSize: 22,
          ),
        ),
        backgroundColor: BrandColors.neutralVariantBase,
        elevation: 0,
        iconTheme: IconThemeData(color: BrandColors.info),
      ),
      body: Consumer2<RewardsProvider, AuthProvider>(
        builder: (context, rewardsProvider, authProvider, child) {
          if (rewardsProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(BrandColors.info),
              ),
            );
          }

          if (rewardsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrandColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: BrandColors.error.withOpacity(0.3), width: 2),
                    ),
                    child:
                        Icon(Icons.error, size: 48, color: BrandColors.error),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Failed to load rewards',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: BrandColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rewardsProvider.error!,
                    style: GoogleFonts.inter(
                      color: BrandColors.textMuted,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [BrandColors.info, BrandColors.infoDeep],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () => rewardsProvider.loadRewards(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: BrandColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final rewards = rewardsProvider.rewards;
          final balance = authProvider.customerBalance?.pointsBalance ?? 0;

          if (rewards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BrandColors.neutralVariantBase,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: BrandColors.border, width: 2),
                    ),
                    child: const Icon(
                      Icons.card_giftcard,
                      size: 48,
                      color: BrandColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Rewards Available',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: BrandColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for exciting rewards!',
                    style: GoogleFonts.inter(
                      color: BrandColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            backgroundColor: BrandColors.neutralVariantBase,
            color: BrandColors.info,
            onRefresh: () => rewardsProvider.loadRewards(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        BrandColors.neutralVariantBase,
                        BrandColors.surfaceOverlay
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [BrandColors.info, BrandColors.infoDeep],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: BrandColors.info.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: BrandColors.textPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Points',
                            style: GoogleFonts.inter(
                              color: BrandColors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            balance.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: BrandColors.info,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Available Rewards',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: BrandColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ...rewards.map((reward) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RewardCard(
                        reward: reward,
                        userPoints: balance,
                        onRedeem: () => _redeemReward(reward),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final int userPoints;
  final VoidCallback onRedeem;

  const RewardCard({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = userPoints >= reward.costPoints;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BrandColors.neutralVariantBase,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canAfford
              ? BrandColors.pink.withOpacity(0.3)
              : BrandColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: canAfford
                ? BrandColors.pink.withOpacity(0.1)
                : Colors.transparent,
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BrandColors.pink, BrandColors.pinkDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.pink.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  size: 32,
                  color: BrandColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: BrandColors.textPrimary,
                      ),
                    ),
                    if (reward.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        reward.description!,
                        style: GoogleFonts.inter(
                          color: BrandColors.textMuted,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: BrandColors.warningGlow.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: BrandColors.warningGlow.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.stars,
                      size: 16,
                      color: BrandColors.warningGlow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${reward.costPoints} points',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: BrandColors.warningGlow,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (canAfford)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [BrandColors.pink, BrandColors.pinkDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: BrandColors.pink.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: -2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onRedeem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Redeem',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: BrandColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: BrandColors.border,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: BrandColors.mutedSlate,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Need ${reward.costPoints - userPoints} more',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: BrandColors.mutedSlate,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
