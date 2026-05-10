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
  
  Student get me => MockData.students.firstWhere((s) => s.id == widget.studentId);

  List<Enrollment> get myEnrollments => MockData.enrollments
      .where((e) => e.studentId == widget.studentId && e.status != EnrollmentStatus.dropped)
      .toList();

  void _handleEnroll(Course course) {
    String? validationError = EnrollmentController.canEnroll(me, course);

    if (validationError != null) {
      _showMsg(validationError, isError: true);
      return;
    }

    setState(() {
      EnrollmentController.processEnrollment(me, course);
    });
    
    _showMsg("Successfully enrolled in ${course.code}");
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
    ));
  }

  void _handleLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMain,
      // USING THE EXACT SAME STRUCTURAL ROW AS MAIN_SCREEN!
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStudentHeader(),
                        const SizedBox(height: 32),
                        _buildCatalogSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ADMIN-STYLE FIXED SIDEBAR ---
  Widget _buildSidebar() {
    return Container(
      width: 260, // Slightly wider to comfortably fit course details
      color: AppTheme.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MY SCHEDULE',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.sidebarText.withOpacity(0.5),
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '${myEnrollments.length * 3} Units',
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // The Scrollable Schedule List inside the Sidebar!
          Expanded(
            child: myEnrollments.isEmpty
                ? Center(
                    child: Text(
                      "No courses added yet.",
                      style: TextStyle(color: AppTheme.sidebarText.withOpacity(0.5), fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: myEnrollments.length,
                    itemBuilder: (ctx, i) {
                      final en = myEnrollments[i];
                      final course = MockData.courses.firstWhere((c) => c.id == en.courseId);
                      return _sidebarCourseItem(course, en);
                    },
                  ),
          ),
          
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          _buildSidebarUser(), // Admin-style user profile and logout
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryLight, AppTheme.accent],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'ISATU Student Portal',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarCourseItem(Course c, Enrollment e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Dark-mode friendly card
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c.code, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 14)),
          const SizedBox(height: 4),
          Text(c.title, style: const TextStyle(fontSize: 12, color: AppTheme.sidebarText), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 12, color: AppTheme.sidebarText),
              const SizedBox(width: 4),
              Expanded(child: Text(c.schedule, style: TextStyle(fontSize: 10, color: AppTheme.sidebarText.withOpacity(0.7)), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: TextButton(
              onPressed: () => _handleDrop(e),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.danger.withOpacity(0.15),
                foregroundColor: AppTheme.danger,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
              ),
              child: const Text("Drop Course", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryLight, AppTheme.accent],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  me.initials,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${me.firstName} ${me.lastName}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    me.email,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppTheme.sidebarText.withOpacity(0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.logout_rounded,
                size: 16,
                color: AppTheme.sidebarText.withOpacity(0.4),
              ),
              onPressed: _handleLogout,
              tooltip: 'Logout',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          Text(
            'Course Registration',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // --- MAIN CONTENT AREA ---
  Widget _buildStudentHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${me.firstName}!', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            Text('${me.studentId} • ${me.program}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          ],
        ),
        const Spacer(),
        _statBadge("Current GPA", me.gpa.toStringAsFixed(2), Icons.grade_rounded),
      ],
    );
  }

  Widget _statBadge(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.primaryLight.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
              Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCatalogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Available Course Catalog", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            Text("Showing ${MockData.courses.length} Courses", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 20, 
            mainAxisSpacing: 20, 
            childAspectRatio: 1.4
          ),
          itemCount: MockData.courses.length,
          itemBuilder: (ctx, i) => _catalogCard(MockData.courses[i]),
        ),
      ],
    );
  }

  Widget _catalogCard(Course c) {
    bool isFull = !c.hasSpace;
    bool hasPrereqs = c.prerequisites.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: AppTheme.border)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(c.code, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              Text(
                "${c.currentCapacity}/${c.maxCapacity} Slots", 
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isFull ? AppTheme.danger : AppTheme.textSecondary)
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(c.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
          
          if (hasPrereqs) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.lock_outline, size: 12, color: AppTheme.warning),
                const SizedBox(width: 4),
                Text("Requires: ${c.prerequisites.join(', ')}", style: const TextStyle(fontSize: 11, color: AppTheme.warning, fontWeight: FontWeight.bold)),
              ],
            )
          ],

          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: isFull ? null : () => _handleEnroll(c),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(isFull ? "Class Full" : "Enroll Now", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}