import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../controllers/enrollment_controller.dart';
import 'login_screen.dart';

class StudentDashboard extends StatefulWidget {
  final String studentId;

  const StudentDashboard({super.key, required this.studentId});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0; 
  String? _curriculumYearFilter; 
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Student get me => MockData.students.firstWhere((s) => s.id == widget.studentId);

  List<Enrollment> get myEnrollments => MockData.enrollments
      .where((e) => e.studentId == widget.studentId && e.status != EnrollmentStatus.dropped)
      .toList();

  // --- LOGIC: HELPER TO MAP COURSE TO YEAR LEVEL ---
  String _getCourseYear(String code) {
    final firstYear = ['ICT 102', 'CS 1', 'ICT 103', 'ICT 105', 'ICT 106', 'IT 101', 'IS 101', 'IS 102'];
    final secondYear = ['ICT 104', 'ICT 107', 'ICT 113', 'ICT 110', 'ICT 111', 'ICT 112', 'ICT 114', 'IT 201', 'IS 201'];
    final thirdYear = ['ICT 108', 'ICT 115', 'ICT 109', 'ICT 117', 'ICT 118', 'CS 101', 'ANIM 101', 'IT 301', 'IS 301'];
    final fourthYear = ['ICT 123', 'ICT 136', 'ICT 124', 'ICT 125', 'IT 401', 'IS 401'];

    if (firstYear.contains(code)) return '1st Year';
    if (secondYear.contains(code)) return '2nd Year';
    if (thirdYear.contains(code)) return '3rd Year';
    if (fourthYear.contains(code)) return '4th Year';

    return '1st Year'; 
  }

  // --- LOGIC: ENROLLMENT ---
  void _handleEnroll(Course course) {
    String? validationError = EnrollmentController.canEnroll(me, course);

    if (validationError != null) {
      _showMsg(validationError, isError: true);
      return;
    }

    setState(() {
      EnrollmentController.processEnrollment(me, course);
    });
    
    _showMsg("Enrollment requested! Waiting for admin approval.");
  }

  // --- LOGIC: DROP CONFIRMATION ---
  void _confirmDrop(Enrollment e, Course c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Drop Course?'),
        content: Text('Are you sure you want to drop ${c.code} - ${c.title}? This will remove it from your current schedule.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              Navigator.pop(ctx);
              _handleDrop(e);
            },
            child: const Text('Confirm Drop'),
          ),
        ],
      ),
    );
  }

  void _handleDrop(Enrollment enrollment) {
    setState(() {
      EnrollmentController.processDrop(enrollment);
    });
    _showMsg("Course dropped successfully.");
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppTheme.danger : AppTheme.success,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
    ));
  }

  void _handleLogout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMain,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final titles = ['Dashboard Overview', 'My Academic Schedule', 'CCI Curriculum', 'My Profile'];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: AppTheme.bgCard, border: Border(bottom: BorderSide(color: AppTheme.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titles[_selectedIndex], style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          Text('AY 2024-2025 • First Semester', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0: return _buildDashboardTab();
      case 1: return _buildScheduleTab();
      case 2: return _buildCurriculumTab();
      case 3: return _buildProfileTab();
      default: return _buildDashboardTab();
    }
  }

  // ==========================================
  // TAB 1: DASHBOARD (Horizontal List UI)
  // ==========================================
  Widget _buildDashboardTab() {
    final filteredCourses = MockData.courses.where((c) {
      return c.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
             c.code.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentHeader(),
          const SizedBox(height: 40),
          
          // SEARCH & TITLE BAR
          Row(
            children: [
              const Text("Available Course Catalog", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              const Spacer(),
              SizedBox(
                width: 350,
                height: 45,
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search course code or title...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // HORIZONTAL LIST OF COURSES
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredCourses.length,
            itemBuilder: (ctx, i) => _courseRow(filteredCourses[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${me.firstName}!', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text('${me.studentId} • ${me.program}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        _statBadge("GPA", me.gpa.toStringAsFixed(2), Icons.star_rounded),
        const SizedBox(width: 16),
        _statBadge("Total Units", "${myEnrollments.length * 3}", Icons.auto_stories_rounded),
      ],
    );
  }

  Widget _statBadge(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppTheme.primaryLight),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
              Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _courseRow(Course c) {
    bool isFull = !c.hasSpace;
    bool hasPrereqs = c.prerequisites.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(c.code, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900, fontSize: 13))),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                if (hasPrereqs)
                  Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 12, color: AppTheme.warning),
                      const SizedBox(width: 4),
                      Text("Prerequisites: ${c.prerequisites.join(', ')}", style: const TextStyle(fontSize: 11, color: AppTheme.warning, fontWeight: FontWeight.w700)),
                    ],
                  )
                else
                  const Text("Open Enrollment", style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${c.units} Units", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text("${c.currentCapacity}/${c.maxCapacity} Slots Filled", style: TextStyle(fontSize: 11, color: isFull ? AppTheme.danger : AppTheme.textSecondary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 40),
          SizedBox(
            width: 130,
            height: 42,
            child: ElevatedButton(
              onPressed: isFull ? null : () => _handleEnroll(c),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? Colors.grey[200] : AppTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isFull ? "Full" : "Enroll Now", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: MY SCHEDULE
  // ==========================================
  Widget _buildScheduleTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Current Schedule", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text("Courses listed here are active or pending approval from the registrar.", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 32),
          Expanded(
            child: myEnrollments.isEmpty
                ? const Center(child: Text("Your schedule is currently empty.", style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)))
                : ListView.builder(
                    itemCount: myEnrollments.length,
                    itemBuilder: (ctx, i) {
                      final en = myEnrollments[i];
                      final course = MockData.courses.firstWhere((c) => c.id == en.courseId);
                      return _scheduleListItem(course, en);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleListItem(Course c, Enrollment e) {
    bool isPending = e.status == EnrollmentStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: AppTheme.primaryLight.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.bookmark_added_rounded, color: AppTheme.primaryLight, size: 28),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.code, style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary, fontSize: 14)),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: isPending ? AppTheme.warning.withOpacity(0.12) : AppTheme.success.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        isPending ? 'PENDING APPROVAL' : 'ENROLLED',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isPending ? AppTheme.warning : AppTheme.success, letterSpacing: 0.5),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(c.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled_rounded, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text('${c.schedule}  •  Room ${c.room}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          OutlinedButton.icon(
            onPressed: () => _confirmDrop(e, c),
            icon: const Icon(Icons.delete_sweep_rounded, size: 18),
            label: const Text("Drop Course"),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.danger,
              side: const BorderSide(color: AppTheme.danger, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: CURRICULUM (With mapping fix!)
  // ==========================================
  Widget _buildCurriculumTab() {
    String prefix = '';
    if (me.program.contains('Computer Science')) prefix = 'CS';
    if (me.program.contains('Information Technology')) prefix = 'IT';
    if (me.program.contains('Information Systems')) prefix = 'IS';

    final programCourses = MockData.courses.where((c) {
      bool matchesProgram = c.code.startsWith(prefix) || c.code.startsWith('ICT') || c.code.startsWith('ANIM');
      bool matchesYear = _curriculumYearFilter == null || _curriculumYearFilter == 'All Years' || 
                         _getCourseYear(c.code) == _curriculumYearFilter; 
      return matchesProgram && matchesYear;
    }).toList();

    programCourses.sort((a, b) => _getCourseYear(a.code).compareTo(_getCourseYear(b.code)));

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CCI Curriculum Checklist", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text("Tracking requirements for ${me.program}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.border), borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _curriculumYearFilter ?? 'All Years',
                    items: ['All Years', '1st Year', '2nd Year', '3rd Year', '4th Year']
                        .map((y) => DropdownMenuItem(value: y, child: Text(y, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))))
                        .toList(),
                    onChanged: (v) => setState(() => _curriculumYearFilter = v),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: programCourses.length,
              itemBuilder: (ctx, i) => _curriculumListItem(programCourses[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _curriculumListItem(Course c) {
    bool hasPrereqs = c.prerequisites.isNotEmpty;
    bool isCompleted = MockData.enrollments.any((e) => e.studentId == me.id && e.courseId == c.id && e.status == EnrollmentStatus.completed);
    String yr = _getCourseYear(c.code);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isCompleted ? AppTheme.success.withOpacity(0.4) : AppTheme.border)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        leading: Icon(isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isCompleted ? AppTheme.success : AppTheme.textSecondary.withOpacity(0.3), size: 28),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.primaryLight.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
              child: Text(yr, style: const TextStyle(fontSize: 10, color: AppTheme.primaryLight, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 12),
            Text(c.code, style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary, fontSize: 13)),
            const SizedBox(width: 12),
            Expanded(child: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
          ],
        ),
        subtitle: hasPrereqs 
          ? Padding(padding: const EdgeInsets.only(top: 4), child: Text("Requires: ${c.prerequisites.join(', ')}", style: const TextStyle(color: AppTheme.warning, fontSize: 11, fontWeight: FontWeight.w800)))
          : null,
        trailing: Text("${c.units} Units", style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.textSecondary, fontSize: 13)),
      ),
    );
  }

  // ==========================================
  // TAB 4: PROFILE
  // ==========================================
  Widget _buildProfileTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Settings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(color: AppTheme.primaryLight.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(child: Text(me.initials, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.primary))),
                    ),
                    const SizedBox(height: 20),
                    const Text("Active Student", style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Academic Identity", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                      const Divider(height: 32),
                      _profileInfoRow("Full Name", me.fullName),
                      _profileInfoRow("Student ID", me.studentId),
                      _profileInfoRow("Email", me.email),
                      _profileInfoRow("Degree Program", me.program),
                      _profileInfoRow("Classification", me.yearLevel),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _profileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }

  // --- SIDEBAR ---
  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: AppTheme.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('STUDENT ACCESS', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.sidebarText.withOpacity(0.3), letterSpacing: 1.5)),
          ),
          const SizedBox(height: 12),
          _buildNavItem(icon: Icons.grid_view_rounded, label: 'Dashboard', index: 0),
          _buildNavItem(icon: Icons.calendar_today_rounded, label: 'My Schedule', index: 1),
          _buildNavItem(icon: Icons.assignment_rounded, label: 'Curriculum', index: 2),
          _buildNavItem(icon: Icons.person_pin_rounded, label: 'Profile', index: 3),
          const Spacer(),
          _buildSidebarUser(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isActive = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: isActive ? AppTheme.primaryLight.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isActive ? Colors.white : AppTheme.sidebarText.withOpacity(0.5)),
              const SizedBox(width: 14),
              Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: isActive ? FontWeight.w800 : FontWeight.w600, color: isActive ? Colors.white : AppTheme.sidebarText.withOpacity(0.6))),
              if (index == 1 && myEnrollments.isNotEmpty) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.warning, borderRadius: BorderRadius.circular(6)),
                  child: Text('${myEnrollments.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primaryLight, AppTheme.accent]), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Text('ISATU Student Portal', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSidebarUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(me.initials, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${me.firstName} ${me.lastName}', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis),
                  Text(me.email, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.sidebarText.withOpacity(0.4)), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.power_settings_new_rounded, size: 20, color: AppTheme.sidebarText.withOpacity(0.4)),
              onPressed: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }
}