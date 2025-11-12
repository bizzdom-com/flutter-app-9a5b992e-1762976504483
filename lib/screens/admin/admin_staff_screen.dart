import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/admin_provider.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../../theme/brand_colors.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadStaff();
    });
  }

  void _showAddStaffDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddEditStaffDialog(),
    );
  }

  void _showEditStaffDialog(UserModel staff) {
    showDialog(
      context: context,
      builder: (context) => AddEditStaffDialog(staff: staff),
    );
  }

  void _confirmDeleteStaff(UserModel staff) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: AppTheme.neuromorphicDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: BrandColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: BrandColors.error.withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.warning_amber,
                    color: BrandColors.error,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Delete Staff Member?',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  'Are you sure you want to delete "${staff.name}"?\n\nThis will permanently remove them from the system and cannot be undone.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: BrandColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: AppTheme.neuromorphicDecoration(),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BrandColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [BrandColors.error, BrandColors.errorDeep],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: BrandColors.error.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final adminProvider = Provider.of<AdminProvider>(
                                context,
                                listen: false);
                            final success =
                                await adminProvider.deleteStaffMember(staff.id);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Staff member removed and converted to customer'
                                        : adminProvider.error ??
                                            'Failed to remove staff member',
                                    style:
                                        GoogleFonts.inter(color: Colors.white),
                                  ),
                                  backgroundColor: success
                                      ? BrandColors.success
                                      : BrandColors.error,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'DELETE',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.neutralBase,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BrandColors.neutralBase,
              BrandColors.backgroundAlt,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: AppTheme.neuromorphicDecoration(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: BrandColors.secondary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MANAGE STAFF',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add and manage team members',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: BrandColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content Area
              Expanded(
                child: Consumer<AdminProvider>(
                  builder: (context, adminProvider, child) {
                    if (adminProvider.isLoading &&
                        adminProvider.staff.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              BrandColors.secondary),
                        ),
                      );
                    }

                    if (adminProvider.error != null &&
                        adminProvider.staff.isEmpty) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(24),
                          padding: const EdgeInsets.all(32),
                          decoration: AppTheme.neuromorphicDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: BrandColors.error.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: BrandColors.error.withOpacity(0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.error_outline,
                                  size: 40,
                                  color: BrandColors.error,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Failed to Load Staff',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                adminProvider.error!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: BrandColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      BrandColors.secondary,
                                      BrandColors.secondaryDark
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: BrandColors.secondary
                                          .withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () => adminProvider.loadStaff(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'RETRY',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final staff = adminProvider.staff;

                    if (staff.isEmpty) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(24),
                          padding: const EdgeInsets.all(32),
                          decoration: AppTheme.neuromorphicDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: BrandColors.secondary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        BrandColors.secondary.withOpacity(0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.people_outline,
                                  size: 40,
                                  color: BrandColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No Staff Members Yet',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Add staff members to help manage your business and loyalty program',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: BrandColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      BrandColors.secondary,
                                      BrandColors.secondaryDark
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: BrandColors.secondary
                                          .withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _showAddStaffDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: Text(
                                    'ADD FIRST STAFF MEMBER',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => adminProvider.loadStaff(),
                      color: BrandColors.secondary,
                      backgroundColor: BrandColors.neutralVariantBase,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        itemCount: staff.length,
                        itemBuilder: (context, index) {
                          final staffMember = staff[index];
                          return _ModernStaffCard(
                            staff: staffMember,
                            onEdit: () => _showEditStaffDialog(staffMember),
                            onDelete: () => _confirmDeleteStaff(staffMember),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [BrandColors.secondary, BrandColors.secondaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BrandColors.secondary.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddStaffDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _ModernStaffCard extends StatelessWidget {
  final UserModel staff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ModernStaffCard({
    required this.staff,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isManager = staff.isManager;
    final roleColor = isManager ? BrandColors.secondary : BrandColors.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.neuromorphicDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Staff Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isManager
                      ? [BrandColors.secondary, BrandColors.secondaryDark]
                      : [BrandColors.accent, BrandColors.accentDeep],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: roleColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                isManager ? Icons.supervisor_account : Icons.badge,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Staff Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.name ?? 'Unnamed Staff',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    staff.email,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: BrandColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: roleColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isManager ? Icons.star : Icons.person,
                          size: 12,
                          color: roleColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          staff.role.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: roleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: BrandColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: BrandColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: BrandColors.warning,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: BrandColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: BrandColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: BrandColors.error,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddEditStaffDialog extends StatefulWidget {
  final UserModel? staff;

  const AddEditStaffDialog({super.key, this.staff});

  bool get isEditing => staff != null;

  @override
  State<AddEditStaffDialog> createState() => _AddEditStaffDialogState();
}

class _AddEditStaffDialogState extends State<AddEditStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  String _selectedRole = 'staff';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _emailController = TextEditingController(text: widget.staff?.email ?? '');
    _selectedRole = widget.staff?.role ?? 'staff';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveStaff() async {
    if (!_formKey.currentState!.validate()) return;

    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    bool success;
    if (widget.isEditing) {
      success = await adminProvider.updateStaffMember(
        userId: widget.staff!.id,
        name: name,
        email: email,
        role: _selectedRole,
        locationId: 1, // Default location for now
      );
    } else {
      success = await adminProvider.createStaffMember(
        name: name,
        email: email,
        role: _selectedRole,
        locationId: 1, // Default location for now
      );
    }

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Staff member updated successfully'
                  : 'Staff member added successfully! If this email was already registered, the user has been promoted to staff.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: BrandColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              adminProvider.error ?? 'Failed to save staff member',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: BrandColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: AppTheme.neuromorphicDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dialog Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: BrandColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: BrandColors.secondary.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.people,
                        color: BrandColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.isEditing
                            ? 'Edit Staff Member'
                            : 'Add New Staff Member',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: BrandColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name
                      Container(
                        decoration: AppTheme.neuromorphicDecoration(),
                        child: TextFormField(
                          controller: _nameController,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: GoogleFonts.inter(
                              color: BrandColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: BrandColors.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter staff member name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Address
                      Container(
                        decoration: AppTheme.neuromorphicDecoration(),
                        child: TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.inter(
                            color: widget.isEditing
                                ? BrandColors.textSecondary
                                : Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: GoogleFonts.inter(
                              color: BrandColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: BrandColors.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !widget.isEditing,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter email address';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value!)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Role Dropdown
                      Container(
                        decoration: AppTheme.neuromorphicDecoration(),
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Select Role',
                            hintStyle: GoogleFonts.inter(
                              color: BrandColors.textSecondary,
                            ),
                            prefixIcon: Icon(
                              _selectedRole == 'manager'
                                  ? Icons.supervisor_account
                                  : Icons.badge,
                              color: _selectedRole == 'manager'
                                  ? BrandColors.secondary
                                  : BrandColors.accent,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          dropdownColor: BrandColors.neutralVariantBase,
                          items: [
                            DropdownMenuItem(
                              value: 'staff',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.badge,
                                    size: 18,
                                    color: BrandColors.accent,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Staff Member',
                                    style:
                                        GoogleFonts.inter(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'manager',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.supervisor_account,
                                    size: 18,
                                    color: BrandColors.secondary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Manager',
                                    style:
                                        GoogleFonts.inter(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedRole = value);
                            }
                          },
                        ),
                      ),

                      // Note for new staff
                      if (!widget.isEditing) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: BrandColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: BrandColors.accent.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: BrandColors.accent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Staff Member Creation:',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: BrandColors.accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• If account exists: User will be promoted to staff',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: BrandColors.accent,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '• If new email: User must register to activate account',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: BrandColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: AppTheme.neuromorphicDecoration(),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BrandColors.textSecondary,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<AdminProvider>(
                        builder: (context, adminProvider, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  BrandColors.secondary,
                                  BrandColors.secondaryDark
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: BrandColors.secondary.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  adminProvider.isLoading ? null : _saveStaff,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: adminProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      widget.isEditing ? 'UPDATE' : 'CREATE',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
