import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../widgets/status_badge.dart'; // Keep if you use it elsewhere

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
    if (!course.hasSpace) {
      _showMsg("Course is full!", isError: true);
      return;
    }

    bool alreadyEnrolled = MockData.enrollments.any(
        (e) => e.studentId == widget.studentId && e.courseId == course.id && e.status != EnrollmentStatus.dropped);

    if (alreadyEnrolled) {
      _showMsg("You are already enrolled in this course.", isError: true);
      return;
    }

    setState(() {
      MockData.enrollments.add(Enrollment(
        id: 'e_${DateTime.now().millisecondsSinceEpoch}',
        studentId: widget.studentId, 
        courseId: course.id,
        semester: '1st Sem 2026',
        status: EnrollmentStatus.enrolled,
        dateRequested: DateTime.now(),
      ));

      final courseIdx = MockData.courses.indexWhere((c) => c.id == course.id);
      if (courseIdx != -1) {
        final c = MockData.courses[courseIdx];
        MockData.courses[courseIdx] = Course(
          id: c.id, code: c.code, title: c.title, instructorId: c.instructorId,
          schedule: c.schedule, room: c.room, units: c.units, 
          currentCapacity: c.currentCapacity + 1, 
          maxCapacity: c.maxCapacity, departmentId: c.departmentId, prerequisites: c.prerequisites,
        );
      }
    });
    _showMsg("Successfully enrolled in ${course.code}");
  }

  void _handleDrop(Enrollment enrollment) {
    setState(() {
      final idx = MockData.enrollments.indexWhere((e) => e.id == enrollment.id);
      if (idx != -1) MockData.enrollments[idx] = enrollment.copyWithStatus(EnrollmentStatus.dropped);

      final courseIdx = MockData.courses.indexWhere((c) => c.id == enrollment.courseId);
      if (courseIdx != -1) {
        final c = MockData.courses[courseIdx];
        MockData.courses[courseIdx] = Course(
          id: c.id, code: c.code, title: c.title, instructorId: c.instructorId,
          schedule: c.schedule, room: c.room, units: c.units, 
          currentCapacity: c.currentCapacity - 1, 
          maxCapacity: c.maxCapacity, departmentId: c.departmentId, prerequisites: c.prerequisites,
        );
      }
    });
    _showMsg("Course dropped successfully.");
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w500)),
      backgroundColor: isError ? AppTheme.danger : AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMain, // Assume this is a very light gray or off-white
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Clean, frameless app bar
        elevation: 0,
        title: Text(
          'ISAT-U Portal', 
          style: GoogleFonts.plusJakartaSans(
            color: AppTheme.primary, 
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          )
        ),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentHeader(),
            const SizedBox(height: 40), // Increased whitespace for breathing room
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildMyCoursesSection()),
                const SizedBox(width: 40), // Increased gutter between columns
                Expanded(flex: 3, child: _buildCatalogSection()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.primary.withOpacity(0.1),
            child: Text(
              me.initials, 
              style: GoogleFonts.plusJakartaSans(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${me.firstName}', 
                style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 4),
              Text(
                '${me.studentId}  •  ${me.program}', 
                style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(),
          _statBadge("GPA", me.gpa.toStringAsFixed(2), Icons.auto_graph_rounded),
          const SizedBox(width: 16),
          _statBadge("Total Units", "${myEnrollments.length * 3}", Icons.layers_outlined),
        ],
      ),
    );
  }

  Widget _statBadge(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgMain, // Subtle background contrast
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMyCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Schedule", 
          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
          ),
          child: myEnrollments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      "You are not enrolled in any courses.",
                      style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: myEnrollments.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  itemBuilder: (context, index) {
                    final en = myEnrollments[index];
                    final course = MockData.courses.firstWhere((c) => c.id == en.courseId);
                    return _courseListItem(course, en);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCatalogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Catalog", 
          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 16, 
            mainAxisSpacing: 16, 
            childAspectRatio: 1.4 // Adjusted for cleaner proportions
          ),
          itemCount: MockData.courses.length,
          itemBuilder: (ctx, i) => _catalogCard(MockData.courses[i]),
        ),
      ],
    );
  }

  Widget _courseListItem(Course c, Enrollment e) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(c.code, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(c.title, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis),
              ]
            ),
          ),
          Tooltip(
            message: "Drop Course",
            child: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: AppTheme.danger.withOpacity(0.7), size: 22), 
              hoverColor: AppTheme.danger.withOpacity(0.1),
              onPressed: () => _handleDrop(e)
            ),
          ),
        ],
      ),
    );
  }

  Widget _catalogCard(Course c) {
    bool isFull = !c.hasSpace;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        // Subtle hover shadow effect could be added here, but keeping it flat for strict minimalism
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Text(
                  c.code, 
                  style: GoogleFonts.plusJakartaSans(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)
                ),
              ),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 14, color: isFull ? AppTheme.danger : AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    "${c.currentCapacity}/${c.maxCapacity}", 
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: isFull ? AppTheme.danger : AppTheme.textSecondary)
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            c.title, 
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15, height: 1.3), 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: isFull ? null : () => _handleEnroll(c),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? AppTheme.bgMain : AppTheme.primary,
                foregroundColor: isFull ? AppTheme.textSecondary : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isFull ? "Class Full" : "Enroll Now", 
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold)
              ),
            ),
          )
        ],
      ),
    );
  }
}