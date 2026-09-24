import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _activeTabIndex = 0; // 0: Profile, 1: General, 2: Security, 3: Notifications, 4: Appearance, 5: Billing, 6: Integrations, 7: Advanced

  // Profile Controllers
  final TextEditingController _fullNameController = TextEditingController(text: 'Ravi Kumar');
  final TextEditingController _businessNameController = TextEditingController(text: 'CLIKS Business');
  final TextEditingController _emailController = TextEditingController(text: 'ravinew2004@gmail.com');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  final TextEditingController _gstinController = TextEditingController(text: '');
  final TextEditingController _websiteController = TextEditingController(text: '');
  final TextEditingController _companyAddressController = TextEditingController(text: '');
  final TextEditingController _cityController = TextEditingController(text: '');
  final TextEditingController _stateController = TextEditingController(text: '');
  final TextEditingController _countryController = TextEditingController(text: 'India');
  final TextEditingController _postalCodeController = TextEditingController(text: '');
  final TextEditingController _businessCategoryController = TextEditingController(text: '');
  final TextEditingController _businessTypeController = TextEditingController(text: '');

  // General State
  final TextEditingController _appNameController = TextEditingController(text: 'CLIKS Business');
  String _defaultCurrency = 'INR — Indian Rupee';
  String _timezone = 'Asia/Kolkata (IST)';
  String _language = 'English (US)';
  String _dateFormat = 'DD/MM/YYYY';
  String _numberFormat = '1,00,000.00';

  // Security State
  final TextEditingController _currentPasswordController = TextEditingController(text: 'password123');
  final TextEditingController _newPasswordController = TextEditingController(text: 'password123');
  final TextEditingController _confirmPasswordController = TextEditingController(text: 'password123');
  String _sessionTimeout = '30 minutes';
  bool _enable2FA = true;

  // Notifications State
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _weeklyReports = true;
  bool _emailDigest = false;

  // Appearance State
  bool _darkMode = false;
  bool _compactMode = false;
  String _fontSize = 'Medium';

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _gstinController.dispose();
    _websiteController.dispose();
    _companyAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _businessCategoryController.dispose();
    _businessTypeController.dispose();
    _appNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Settings saved successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF0F5132),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final paddingVal = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header (Title + Subtitle + Save Changes Button)
            _buildPageHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // Horizontal Tab Navigation Bar
            _buildSubTabBar(isMobile).animate().fadeIn(duration: 450.ms, delay: 50.ms),
            const SizedBox(height: 24),

            // Active Tab View Content
            _buildActiveTabView(isMobile).animate().fadeIn(duration: 500.ms, delay: 100.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page Header
  // ---------------------------------------------------------------------------
  Widget _buildPageHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage your application preferences and system configuration.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _saveSettings,
          icon: const Icon(LucideIcons.save, size: 16),
          label: const Text('Save Changes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5132),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Sub Tab Navigation Bar
  // ---------------------------------------------------------------------------
  Widget _buildSubTabBar(bool isMobile) {
    final tabs = [
      {'icon': LucideIcons.user, 'label': 'Profile'},
      {'icon': LucideIcons.sliders, 'label': 'General'},
      {'icon': LucideIcons.shieldCheck, 'label': 'Security'},
      {'icon': LucideIcons.bell, 'label': 'Notifications'},
      {'icon': LucideIcons.palette, 'label': 'Appearance'},
      {'icon': LucideIcons.creditCard, 'label': 'Billing'},
      {'icon': LucideIcons.zap, 'label': 'Integrations'},
      {'icon': LucideIcons.code, 'label': 'Advanced'},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _activeTabIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: InkWell(
                onTap: () => setState(() => _activeTabIndex = index),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                    border: isSelected ? Border.all(color: Colors.grey.shade200) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        tabs[index]['icon'] as IconData,
                        size: 15,
                        color: isSelected ? const Color(0xFF0F5132) : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tabs[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? const Color(0xFF0F5132) : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Active Tab Router
  // ---------------------------------------------------------------------------
  Widget _buildActiveTabView(bool isMobile) {
    switch (_activeTabIndex) {
      case 0:
        return _buildProfileTab(isMobile);
      case 1:
        return _buildGeneralTab(isMobile);
      case 2:
        return _buildSecurityTab(isMobile);
      case 3:
        return _buildNotificationsTab(isMobile);
      case 4:
        return _buildAppearanceTab(isMobile);
      case 5:
        return _buildBillingTab(isMobile);
      case 6:
        return _buildIntegrationsTab(isMobile);
      case 7:
        return _buildAdvancedTab(isMobile);
      default:
        return _buildProfileTab(isMobile);
    }
  }

  // ---------------------------------------------------------------------------
  // 1. Profile Tab (Screenshot 5)
  // ---------------------------------------------------------------------------
  Widget _buildProfileTab(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Card: Upload Profile Image
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular Dashed Upload Box
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  color: const Color(0xFFFAFAFB),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.upload, size: 20, color: Colors.grey),
                    SizedBox(height: 4),
                    Text('Upload', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
                    Text('Profile Image', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Profile Image',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JPG, PNG or GIF · Max 2MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Bottom Card: Profile Information
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final fieldWidth = constraints.maxWidth > 950
                      ? (constraints.maxWidth - 48) / 4
                      : constraints.maxWidth > 550
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildSettingsField(width: fieldWidth, label: 'FULL NAME', controller: _fullNameController, hint: 'Full Name'),
                      _buildSettingsField(width: fieldWidth, label: 'BUSINESS NAME', controller: _businessNameController, hint: 'Business Name'),
                      _buildSettingsField(width: fieldWidth, label: 'EMAIL ADDRESS', controller: _emailController, hint: 'Email Address'),
                      _buildSettingsField(width: fieldWidth, label: 'PHONE NUMBER', controller: _phoneController, hint: 'Phone Number'),
                      _buildSettingsField(width: fieldWidth, label: 'GST NUMBER', controller: _gstinController, hint: 'GST Number'),
                      _buildSettingsField(width: fieldWidth, label: 'WEBSITE', controller: _websiteController, hint: 'Website'),
                      _buildSettingsField(width: fieldWidth, label: 'COMPANY ADDRESS', controller: _companyAddressController, hint: 'Company Address'),
                      _buildSettingsField(width: fieldWidth, label: 'CITY', controller: _cityController, hint: 'City'),
                      _buildSettingsField(width: fieldWidth, label: 'STATE', controller: _stateController, hint: 'State'),
                      _buildSettingsField(width: fieldWidth, label: 'COUNTRY', controller: _countryController, hint: 'Country'),
                      _buildSettingsField(width: fieldWidth, label: 'POSTAL CODE', controller: _postalCodeController, hint: 'Postal Code'),
                      _buildSettingsField(width: fieldWidth, label: 'BUSINESS CATEGORY', controller: _businessCategoryController, hint: 'Business Category'),
                      _buildSettingsField(width: fieldWidth, label: 'BUSINESS TYPE', controller: _businessTypeController, hint: 'Business Type'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. General Tab (Screenshot 1)
  // ---------------------------------------------------------------------------
  Widget _buildGeneralTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Application Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = constraints.maxWidth > 950
                  ? (constraints.maxWidth - 48) / 4
                  : constraints.maxWidth > 550
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildSettingsField(width: fieldWidth, label: 'APPLICATION NAME', controller: _appNameController, hint: 'CLIKS Business'),
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'DEFAULT CURRENCY',
                    value: _defaultCurrency,
                    items: const ['INR — Indian Rupee', 'USD — US Dollar', 'EUR — Euro'],
                    onChanged: (val) => setState(() => _defaultCurrency = val!),
                  ),
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'TIMEZONE',
                    value: _timezone,
                    items: const ['Asia/Kolkata (IST)', 'UTC', 'America/New_York'],
                    onChanged: (val) => setState(() => _timezone = val!),
                  ),
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'LANGUAGE',
                    value: _language,
                    items: const ['English (US)', 'Hindi', 'Spanish'],
                    onChanged: (val) => setState(() => _language = val!),
                  ),
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'DATE FORMAT',
                    value: _dateFormat,
                    items: const ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'],
                    onChanged: (val) => setState(() => _dateFormat = val!),
                  ),
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'NUMBER FORMAT',
                    value: _numberFormat,
                    items: const ['1,00,000.00', '100,000.00'],
                    onChanged: (val) => setState(() => _numberFormat = val!),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Security Tab (Screenshot 2)
  // ---------------------------------------------------------------------------
  Widget _buildSecurityTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = constraints.maxWidth > 950
                  ? (constraints.maxWidth - 48) / 4
                  : constraints.maxWidth > 550
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildSettingsField(width: fieldWidth, label: 'CURRENT PASSWORD', controller: _currentPasswordController, hint: '••••••••', obscureText: true),
                  _buildSettingsField(width: fieldWidth, label: 'NEW PASSWORD', controller: _newPasswordController, hint: '••••••••', obscureText: true),
                  _buildSettingsField(width: fieldWidth, label: 'CONFIRM PASSWORD', controller: _confirmPasswordController, hint: '••••••••', obscureText: true),
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'SESSION TIMEOUT (MINUTES)',
                    value: _sessionTimeout,
                    items: const ['15 minutes', '30 minutes', '60 minutes'],
                    onChanged: (val) => setState(() => _sessionTimeout = val!),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 16),

          // 2FA Toggle Switch Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable Two-Factor Authentication',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Require a verification code on each login.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _enable2FA,
                activeThumbColor: const Color(0xFF0F5132),
                onChanged: (val) => setState(() => _enable2FA = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Notifications Tab (Screenshot 3)
  // ---------------------------------------------------------------------------
  Widget _buildNotificationsTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          _buildNotificationToggleRow(
            title: 'Email Notifications',
            subtitle: 'Receive important updates via email.',
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          _buildNotificationToggleRow(
            title: 'Push Notifications',
            subtitle: 'Receive real-time alerts in the browser.',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          _buildNotificationToggleRow(
            title: 'SMS Notifications',
            subtitle: 'Receive critical alerts via SMS.',
            value: _smsNotifications,
            onChanged: (val) => setState(() => _smsNotifications = val),
          ),
          _buildNotificationToggleRow(
            title: 'Weekly Reports',
            subtitle: 'Receive a weekly summary of your activity.',
            value: _weeklyReports,
            onChanged: (val) => setState(() => _weeklyReports = val),
          ),
          _buildNotificationToggleRow(
            title: 'Email Digest',
            subtitle: 'Receive a daily digest of key metrics.',
            value: _emailDigest,
            onChanged: (val) => setState(() => _emailDigest = val),
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Appearance Tab (Screenshot 4)
  // ---------------------------------------------------------------------------
  Widget _buildAppearanceTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appearance & Theme',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          _buildNotificationToggleRow(
            title: 'Dark Mode',
            subtitle: 'Switch the application to a dark theme.',
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          _buildNotificationToggleRow(
            title: 'Compact Mode',
            subtitle: 'Reduce padding for a denser layout.',
            value: _compactMode,
            onChanged: (val) => setState(() => _compactMode = val),
          ),

          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  // Accent Color Picker Box
                  SizedBox(
                    width: fieldWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACCENT COLOR',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B5B3A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '#1B5B3A',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Font Size Dropdown
                  _buildSettingsDropdown(
                    width: fieldWidth,
                    label: 'FONT SIZE',
                    value: _fontSize,
                    items: const ['Small', 'Medium', 'Large'],
                    onChanged: (val) => setState(() => _fontSize = val!),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Billing Tab (Screenshot)
  // ---------------------------------------------------------------------------
  Widget _buildBillingTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billing & Subscription',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = constraints.maxWidth > 800
                  ? (constraints.maxWidth - 32) / 3
                  : isMobile
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildBillingDisplayBox(width: boxWidth, label: 'CURRENT PLAN', value: 'FIN-PRO Standard'),
                  _buildBillingDisplayBox(width: boxWidth, label: 'RENEWAL DATE', value: '01 May, 2027'),
                  _buildBillingDisplayBox(width: boxWidth, label: 'SUBSCRIPTION STATUS', value: 'Active'),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5132),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Upgrade Plan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingDisplayBox({required double width, required String label, required String value}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Integrations Tab (Screenshot)
  // ---------------------------------------------------------------------------
  Widget _buildIntegrationsTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connected Integrations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          // Google
          _buildIntegrationRow(
            title: 'Google',
            subtitle: 'Sync with Google Workspace',
            isConnected: true,
          ),
          const SizedBox(height: 12),

          // Microsoft
          _buildIntegrationRow(
            title: 'Microsoft',
            subtitle: 'Sync with Microsoft 365',
            isConnected: false,
          ),
          const SizedBox(height: 12),

          // Slack
          _buildIntegrationRow(
            title: 'Slack',
            subtitle: 'Send notifications to Slack',
            isConnected: false,
          ),
          const SizedBox(height: 12),

          // WhatsApp
          _buildIntegrationRow(
            title: 'WhatsApp',
            subtitle: 'Send alerts via WhatsApp',
            isConnected: false,
          ),

          const SizedBox(height: 28),

          // API Key Box
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API KEY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        'sk-••••••••••••••••••••••••••••••••',
                        style: TextStyle(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('API Key copied to clipboard!'),
                          backgroundColor: const Color(0xFF0F5132),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkText,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Copy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationRow({required String title, required String subtitle, required bool isConnected}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.check, size: 14, color: Color(0xFF059669)),
                  SizedBox(width: 4),
                  Text('Connected', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                ],
              ),
            )
          else
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkText,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Connect', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. Advanced Tab (Screenshot)
  // ---------------------------------------------------------------------------
  Widget _buildAdvancedTab(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advanced Configuration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),

          // Developer Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer Mode',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Enable detailed error logs and debug tools.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: false,
                activeThumbColor: const Color(0xFF0F5132),
                onChanged: (val) {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 4 Action Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 950
                  ? (constraints.maxWidth - 48) / 4
                  : constraints.maxWidth > 550
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildAdvancedActionCard(
                    width: cardWidth,
                    title: 'Backup Settings',
                    subtitle: 'Download a backup of your configuration.',
                    icon: LucideIcons.download,
                  ),
                  _buildAdvancedActionCard(
                    width: cardWidth,
                    title: 'Restore Data',
                    subtitle: 'Restore from a previous backup file.',
                    icon: LucideIcons.cloudUpload,
                  ),
                  _buildAdvancedActionCard(
                    width: cardWidth,
                    title: 'Export Settings',
                    subtitle: 'Export settings as a JSON file.',
                    icon: LucideIcons.download,
                  ),
                  _buildAdvancedActionCard(
                    width: cardWidth,
                    title: 'Import Settings',
                    subtitle: 'Import settings from a JSON file.',
                    icon: LucideIcons.cloudUpload,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedActionCard({
    required double width,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.darkText),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Widgets
  // ---------------------------------------------------------------------------
  Widget _buildSettingsField({
    required double width,
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 13, color: AppColors.darkText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF0F5132), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsDropdown({
    required double width,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(LucideIcons.chevronDown, size: 14),
                style: const TextStyle(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w500),
                onChanged: onChanged,
                items: items.map((i) {
                  return DropdownMenuItem<String>(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                activeThumbColor: const Color(0xFF0F5132),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey.shade100),
      ],
    );
  }
}
