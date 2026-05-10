import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../widgets/status_badge.dart';

class StudentDashboard extends StatefulWidget {
  final String studentId; // Dynamically accepts the logged-in user

  const StudentDashboard({super.key, required this.studentId});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  
  // Dynamically get the student using the ID passed from the login screen
  Student get me => MockData.students.firstWhere((s) => s.id == widget.studentId);

  // Dynamically filter enrollments for this specific student
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
        studentId: widget.studentId, // Links to this exact student
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
      content: Text(msg),
      backgroundColor: isError ? AppTheme.danger : AppTheme.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMain,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('ISAT-U Portal', style: GoogleFonts.plusJakartaSans(color: AppTheme.primary, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentHeader(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildMyCoursesSection()),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: _buildCatalogSection()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primary,
          child: Text(me.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${me.firstName}!', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800)),
            Text('${me.studentId} • ${me.program}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          ],
        ),
        const Spacer(),
        _statBadge("GPA", me.gpa.toStringAsFixed(2), Icons.grade),
        const SizedBox(width: 12),
        _statBadge("Total Units", "${myEnrollments.length * 3}", Icons.book),
      ],
    );
  }

  Widget _statBadge(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
              Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMyCoursesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const Divider(height: 32),
          if (myEnrollments.isEmpty) const Center(child: Text("Not enrolled in any courses yet."))
          else ...myEnrollments.map((en) {
            final course = MockData.courses.firstWhere((c) => c.id == en.courseId);
            return _courseListItem(course, en);
          }),
        ],
      ),
    );
  }

  Widget _buildCatalogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Available Course Catalog", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.6),
          itemCount: MockData.courses.length,
          itemBuilder: (ctx, i) => _catalogCard(MockData.courses[i]),
        ),
      ],
    );
  }

  Widget _courseListItem(Course c, Enrollment e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.bgMain, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(c.title, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary), overflow: TextOverflow.ellipsis),
            ]),
          ),
          IconButton(icon: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 20), onPressed: () => _handleDrop(e)),
        ],
      ),
    );
  }

  Widget _catalogCard(Course c) {
    bool isFull = !c.hasSpace;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c.code, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800)),
              Text("${c.currentCapacity}/${c.maxCapacity}", style: TextStyle(fontSize: 11, color: isFull ? AppTheme.danger : AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: isFull ? null : () => _handleEnroll(c),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: EdgeInsets.zero),
              child: Text(isFull ? "Full" : "Enroll Now", style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}