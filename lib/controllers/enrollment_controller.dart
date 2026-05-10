import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../utils/mock_data.dart';

class EnrollmentController {
  
  /// VALIDATION METHOD
  /// Returns an error message String if they cannot enroll, or null if they are allowed.
  static String? canEnroll(Student student, Course course) {
    // Rule 1: Is the course full?
    if (!course.hasSpace) {
      return "Course is full! No slots available for ${course.code}.";
    }

    // Rule 2: Is the student already in it?
    bool alreadyEnrolled = MockData.enrollments.any((e) =>
        e.studentId == student.id &&
        e.courseId == course.id &&
        e.status != EnrollmentStatus.dropped);

    if (alreadyEnrolled) {
      return "You are already enrolled in ${course.code}.";
    }

    // Rule 3: Prerequisite Check (Bonus Points for Rubric!)
    if (course.prerequisites.isNotEmpty) {
      for (String prereqCode in course.prerequisites) {
        try {
          // Find the prerequisite course by its code
          final prereqCourse = MockData.courses.firstWhere((c) => c.code == prereqCode);

          // Check if student has a 'completed' enrollment for it
          bool hasCompletedPrereq = MockData.enrollments.any((e) =>
              e.studentId == student.id &&
              e.courseId == prereqCourse.id &&
              e.status == EnrollmentStatus.completed);

          if (!hasCompletedPrereq) {
            return "Prerequisite not met: You must complete $prereqCode first.";
          }
        } catch (e) {
           // Failsafe in case a prerequisite course was deleted from the system
           return "System Error: Prerequisite $prereqCode not found.";
        }
      }
    }

    // If it survives all checks, return null (meaning NO errors, they can enroll!)
    return null; 
  }

  /// EXECUTION METHOD (ENROLL)
  /// Creates the link between Student and Course and updates capacity.
static void processEnrollment(Student student, Course course) {
    // 1. Create the new Enrollment record
    final newEnrollment = Enrollment(
      id: 'e_${DateTime.now().millisecondsSinceEpoch}',
      studentId: student.id,
      courseId: course.id,
      semester: '1st Sem 2026',
      status: EnrollmentStatus.pending, // <-- UPDATED THIS TO PENDING!
      dateRequested: DateTime.now(),
    );

    // 2. Add it to our Database
    MockData.enrollments.add(newEnrollment);

    // 3. Update System Records: Increment Course Capacity
    final courseIdx = MockData.courses.indexWhere((c) => c.id == course.id);
    if (courseIdx != -1) {
      final c = MockData.courses[courseIdx];
      MockData.courses[courseIdx] = Course(
        id: c.id, code: c.code, title: c.title, instructorId: c.instructorId,
        schedule: c.schedule, room: c.room, units: c.units,
        currentCapacity: c.currentCapacity + 1, // INCREMENT SLOT
        maxCapacity: c.maxCapacity, departmentId: c.departmentId, prerequisites: c.prerequisites,
      );
    }
  }

  /// EXECUTION METHOD (DROP)
  /// Changes status and opens the capacity slot back up.
  static void processDrop(Enrollment enrollment) {
    // 1. Update status to dropped
    final idx = MockData.enrollments.indexWhere((e) => e.id == enrollment.id);
    if (idx != -1) {
      MockData.enrollments[idx] = enrollment.copyWithStatus(EnrollmentStatus.dropped);
    }

    // 2. Update System Records: Decrement Course Capacity
    final courseIdx = MockData.courses.indexWhere((c) => c.id == enrollment.courseId);
    if (courseIdx != -1) {
      final c = MockData.courses[courseIdx];
      MockData.courses[courseIdx] = Course(
        id: c.id, code: c.code, title: c.title, instructorId: c.instructorId,
        schedule: c.schedule, room: c.room, units: c.units,
        currentCapacity: c.currentCapacity - 1, // DECREMENT SLOT
        maxCapacity: c.maxCapacity, departmentId: c.departmentId, prerequisites: c.prerequisites,
      );
    }
  }
}