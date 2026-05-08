import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/page_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotifications = true;
  bool _enrollmentAlerts = true;
  bool _pendingApprovals = false;
  bool _autoApprove = false;
  String _semester = '1st Semester';
  String _academicYear = '2024–2025';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Settings',
              subtitle: 'Manage system preferences and configurations',
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildAcademicSettings()),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: _buildNotificationSettings()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildEnrollmentSettings()),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildAdminProfile()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicSettings() {
    return _settingsCard(
      title: 'Academic Configuration',
      icon: Icons.school_rounded,
      iconColor: AppTheme.primaryLight,
      child: Column(
        children: [
          _settingsDropdownField('Academic Year', _academicYear, [
            '2023–2024',
            '2024–2025',
            '2025–2026',
          ], (v) => setState(() => _academicYear = v!)),
          const SizedBox(height: 14),
          _settingsDropdownField('Current Semester', _semester, [
            '1st Semester',
            '2nd Semester',
            'Summer',
          ], (v) => setState(() => _semester = v!)),
          const SizedBox(height: 14),
          _settingsTextField('School Name', 'EduEnroll University'),
          const SizedBox(height: 14),
          _settingsTextField('Max Students Per Section', '40'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Save Academic Settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return _settingsCard(
      title: 'Notifications',
      icon: Icons.notifications_rounded,
      iconColor: AppTheme.warning,
      child: Column(
        children: [
          _toggleRow(
            'Email Notifications',
            'Receive enrollment updates via email',
            _emailNotifications,
            (v) => setState(() => _emailNotifications = v),
          ),
          const Divider(color: AppTheme.border, height: 24),
          _toggleRow(
            'Enrollment Alerts',
            'Get notified when new students enroll',
            _enrollmentAlerts,
            (v) => setState(() => _enrollmentAlerts = v),
          ),
          const Divider(color: AppTheme.border, height: 24),
          _toggleRow(
            'Pending Approvals',
            'Reminders for unprocessed applications',
            _pendingApprovals,
            (v) => setState(() => _pendingApprovals = v),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentSettings() {
    return _settingsCard(
      title: 'Enrollment Policies',
      icon: Icons.policy_rounded,
      iconColor: AppTheme.success,
      child: Column(
        children: [
          _toggleRow(
            'Auto-Approve Enrollments',
            'Automatically approve new enrollment requests without manual review',
            _autoApprove,
            (v) => setState(() => _autoApprove = v),
          ),
          const Divider(color: AppTheme.border, height: 24),
          _settingsTextField('Enrollment Deadline', 'June 30, 2025'),
          const SizedBox(height: 14),
          _settingsTextField('Late Enrollment Fee (PHP)', '500'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _settingsTextField('Min Units per Semester', '15'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _settingsTextField('Max Units per Semester', '24'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Save Enrollment Policies'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProfile() {
    return _settingsCard(
      title: 'Admin Profile',
      icon: Icons.manage_accounts_rounded,
      iconColor: const Color(0xFF7C3AED),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'AD',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _settingsTextField('Full Name', 'Administrator'),
          const SizedBox(height: 12),
          _settingsTextField('Email', 'admin@school.edu'),
          const SizedBox(height: 12),
          _settingsTextField('Role', 'System Administrator'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Update Profile'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.danger,
                side: const BorderSide(color: AppTheme.danger),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Change Password',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _toggleRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.primary,
        ),
      ],
    );
  }

  Widget _settingsTextField(String label, String initial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: TextEditingController(text: initial),
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgMain,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryLight,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingsDropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgMain,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
