import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/user_role_model.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole = UserRole.student;

  final _usernameController = TextEditingController(text: 'STU001');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole newRole) {
    setState(() {
      _selectedRole = newRole;
      _errorMessage = null;
      _passwordController.text = '123456';
      switch (newRole) {
        case UserRole.student:
          _usernameController.text = 'STU001';
          break;
        case UserRole.teacher:
          _usernameController.text = 'TCH001';
          break;
        case UserRole.admin:
          _usernameController.text = 'ADM001';
          break;
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await MockSchoolRepository().loginWithRole(
      _usernameController.text,
      _passwordController.text,
      _selectedRole,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      switch (_selectedRole) {
        case UserRole.student:
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
          break;
        case UserRole.teacher:
          Navigator.pushReplacementNamed(context, AppRoutes.teacherMain);
          break;
        case UserRole.admin:
          Navigator.pushReplacementNamed(context, AppRoutes.adminMain);
          break;
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid ID or password. (Demo: Use quick buttons below with password 123456)';
      });
    }
  }

  void _fillDemoCredentials(String id, String name) {
    setState(() {
      _usernameController.text = id;
      _passwordController.text = '123456';
      _errorMessage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected demo profile: $name ($id)'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.help_outline_rounded, color: AppColors.accentBlue),
            SizedBox(width: 8),
            Text('Forgot Password?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please contact the school administrative office or student helpdesk to reset your security credentials.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Desk: +91 11 2614 8890',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  Text('Email: admin@worthrm.edu.in',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String idLabel;
    String idHint;
    IconData idIcon;

    switch (_selectedRole) {
      case UserRole.student:
        idLabel = 'Student ID / Username';
        idHint = 'e.g. STU001';
        idIcon = Icons.badge_outlined;
        break;
      case UserRole.teacher:
        idLabel = 'Faculty / Employee ID';
        idHint = 'e.g. TCH001';
        idIcon = Icons.co_present_outlined;
        break;
      case UserRole.admin:
        idLabel = 'Administrator ID';
        idHint = 'e.g. ADM001';
        idIcon = Icons.admin_panel_settings_outlined;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // School Crest Top Icon
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryNavy.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.accentGold,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // School Name
                  Text(
                    'WORTH RM SOLDIER PUBLIC SCHOOL',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                  // Welcome Heading
                  Text(
                    'School Portal Login',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select your account role and sign in below',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Segmented Role Switcher
                  _buildRoleSelector(),
                  const SizedBox(height: 24),

                  // Error Banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: AppColors.error, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // User ID field
                  CustomTextField(
                    label: idLabel,
                    hint: idHint,
                    controller: _usernameController,
                    prefixIcon: idIcon,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.accentBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  CustomButton(
                    text: _getLoginButtonText(),
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                    icon: Icons.login_rounded,
                  ),
                  const SizedBox(height: 24),

                  // Quick Demo Switcher Section
                  _buildQuickDemoSection(),
                  const SizedBox(height: 20),

                  // Help Footer
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.support_agent_rounded,
                            size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          'Need help? Contact School IT Desk',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getLoginButtonText() {
    switch (_selectedRole) {
      case UserRole.student:
        return 'Sign In as Student';
      case UserRole.teacher:
        return 'Sign In as Faculty';
      case UserRole.admin:
        return 'Sign In as School Admin';
    }
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceSubtle),
      ),
      child: Row(
        children: [
          _buildRoleTab('Student', Icons.school_rounded, UserRole.student),
          _buildRoleTab('Teacher', Icons.co_present_rounded, UserRole.teacher),
          _buildRoleTab('Admin', Icons.admin_panel_settings_rounded, UserRole.admin),
        ],
      ),
    );
  }

  Widget _buildRoleTab(String label, IconData icon, UserRole role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onRoleChanged(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryNavy.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickDemoSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.accentGold),
              const SizedBox(width: 6),
              Text(
                '1-Tap Demo Credentials (${_selectedRole.name.toUpperCase()})',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buildRoleDemoChips(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleDemoChips() {
    switch (_selectedRole) {
      case UserRole.student:
        return [
          _buildDemoChip('STU001', 'Rahul (10-A)'),
          _buildDemoChip('STU002', 'Ananya (10-A)'),
          _buildDemoChip('STU003', 'Arjun (10-A)'),
          _buildDemoChip('STU004', 'Pooja (10-B)'),
        ];
      case UserRole.teacher:
        return [
          _buildDemoChip('TCH001', 'Dr. Ramanujam (Physics)'),
          _buildDemoChip('TCH002', 'Mrs. Mukherjee (Maths)'),
          _buildDemoChip('TCH003', 'Mrs. Thomas (English)'),
          _buildDemoChip('TCH004', 'Mr. Gupta (CS/AI)'),
        ];
      case UserRole.admin:
        return [
          _buildDemoChip('ADM001', 'Col. V. P. Malhotra (Principal / Admin)'),
        ];
    }
  }

  Widget _buildDemoChip(String id, String label) {
    final isSelected = _usernameController.text == id;
    return GestureDetector(
      onTap: () => _fillDemoCredentials(id, label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryNavy.withOpacity(0.1)
              : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryNavy : AppColors.surfaceSubtle,
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.primaryNavy : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
