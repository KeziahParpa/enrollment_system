import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../models/department.dart'; 

class MockData {
  // 1. MOCK AUTHENTICATION DATABASE
  static final Map<String, String> userCredentials = {
    'admin@isatu.edu': 'admin123',
    'maria.santos@students.isatu.edu': 'password123',
    'juan.delacruz@students.isatu.edu': 'password123',
    'ana.reyes@students.isatu.edu': 'password123',
    'carlos.mendoza@students.isatu.edu': 'password123',
    'liza.garcia@students.isatu.edu': 'password123',
    'ramon.torres@students.isatu.edu': 'password123',
  };

  // 2. CCI STUDENTS LIST
  static final List<Student> students = [
    Student(id: 'uid_1', studentId: '2024-0001', firstName: 'Maria', lastName: 'Santos', email: 'maria.santos@students.isatu.edu', phone: '09171234567', program: 'BS Computer Science', yearLevel: '3rd Year', gpa: 1.5),
    Student(id: 'uid_2', studentId: '2024-0002', firstName: 'Juan', lastName: 'dela Cruz', email: 'juan.delacruz@students.isatu.edu', phone: '09182345678', program: 'BS Information Technology', yearLevel: '2nd Year', gpa: 2.1),
    Student(id: 'uid_3', studentId: '2024-0003', firstName: 'Ana', lastName: 'Reyes', email: 'ana.reyes@students.isatu.edu', phone: '09193456789', program: 'BS Information Systems', yearLevel: '1st Year', gpa: 1.75),
    Student(id: 'uid_4', studentId: '2024-0004', firstName: 'Carlos', lastName: 'Mendoza', email: 'carlos.mendoza@students.isatu.edu', phone: '09204567890', program: 'BS Computer Science', yearLevel: '4th Year', gpa: 1.25),
    Student(id: 'uid_5', studentId: '2024-0005', firstName: 'Liza', lastName: 'Garcia', email: 'liza.garcia@students.isatu.edu', phone: '09215678901', program: 'BS Information Technology', yearLevel: '2nd Year', gpa: 2.5),
    Student(id: 'uid_6', studentId: '2024-0006', firstName: 'Ramon', lastName: 'Torres', email: 'ramon.torres@students.isatu.edu', phone: '09226789012', program: 'BS Information Systems', yearLevel: '3rd Year', gpa: 1.8),
  ];

  // 3. COMPLETE CCI COURSE CATALOG (CS from images, IT/IS generated)
  static final List<Course> courses = [
    // --- COMPUTER SCIENCE (From Syllabus Image) ---
    Course(id: 'cs_1', code: 'ICT 102', title: 'Introduction to Computing', instructorId: 'prof_1', schedule: 'MWF 7:30–9:00 AM', room: 'Lab 1', units: 3, currentCapacity: 38, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_2', code: 'CS 1', title: 'Programming Logic Formulation', instructorId: 'prof_2', schedule: 'TTH 9:00–10:30 AM', room: 'Lab 2', units: 3, currentCapacity: 40, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_3', code: 'ICT 103', title: 'Fundamentals of Programming', instructorId: 'prof_2', schedule: 'MWF 1:00–2:30 PM', room: 'Lab 2', units: 3, currentCapacity: 35, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['CS 1']),
    Course(id: 'cs_4', code: 'ICT 105', title: 'Discrete Structure 1', instructorId: 'prof_3', schedule: 'TTH 1:00–2:30 PM', room: 'Room 305', units: 3, currentCapacity: 28, maxCapacity: 35, departmentId: 'CCI', prerequisites: ['CS 1']),
    Course(id: 'cs_5', code: 'ICT 104', title: 'Intermediate Programming', instructorId: 'prof_1', schedule: 'MWF 9:00–10:30 AM', room: 'Lab 3', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 103']),
    Course(id: 'cs_6', code: 'ICT 107', title: 'Data Structures and Algorithms', instructorId: 'prof_4', schedule: 'TTH 3:00–4:30 PM', room: 'Lab 1', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 103']),
    
    // CS Tracks (From Tracks Image)
    Course(id: 'cs_track_1', code: 'CS 101', title: 'Data Science Tools and R', instructorId: 'prof_5', schedule: 'Sat 8:00–11:00 AM', room: 'Lab 4', units: 3, currentCapacity: 15, maxCapacity: 25, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_track_2', code: 'ANIM 101', title: 'Fundamentals of Animation', instructorId: 'prof_6', schedule: 'Sat 1:00–4:00 PM', room: 'Mac Lab', units: 3, currentCapacity: 22, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['ICT 102']),

    // --- INFORMATION TECHNOLOGY (Generated Progression) ---
    Course(id: 'it_1', code: 'IT 101', title: 'IT Fundamentals', instructorId: 'prof_7', schedule: 'MWF 10:30–12:00 PM', room: 'Room 101', units: 3, currentCapacity: 30, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'it_2', code: 'IT 102', title: 'Networking 1 (Routing & Switching)', instructorId: 'prof_8', schedule: 'TTH 7:30–9:00 AM', room: 'Cisco Lab', units: 3, currentCapacity: 18, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['IT 101']),
    Course(id: 'it_3', code: 'IT 201', title: 'Web Systems and Technologies', instructorId: 'prof_9', schedule: 'MWF 3:00–4:30 PM', room: 'Lab 5', units: 3, currentCapacity: 35, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['IT 101']),
    Course(id: 'it_4', code: 'IT 301', title: 'Systems Administration', instructorId: 'prof_8', schedule: 'TTH 10:30–12:00 PM', room: 'Cisco Lab', units: 3, currentCapacity: 15, maxCapacity: 20, departmentId: 'CCI', prerequisites: ['IT 102']),
    Course(id: 'it_5', code: 'IT 401', title: 'Information Assurance and Security', instructorId: 'prof_7', schedule: 'Sat 9:00–12:00 PM', room: 'Lab 2', units: 3, currentCapacity: 20, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['IT 301']),

    // --- INFORMATION SYSTEMS (Generated Progression) ---
    Course(id: 'is_1', code: 'IS 101', title: 'Fundamentals of Info Systems', instructorId: 'prof_10', schedule: 'TTH 1:00–2:30 PM', room: 'Room 202', units: 3, currentCapacity: 38, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'is_2', code: 'IS 102', title: 'Organizational Behavior in IT', instructorId: 'prof_11', schedule: 'MWF 1:00–2:30 PM', room: 'Room 203', units: 3, currentCapacity: 30, maxCapacity: 35, departmentId: 'CCI', prerequisites: []),
    Course(id: 'is_3', code: 'IS 201', title: 'Database Management Systems', instructorId: 'prof_10', schedule: 'TTH 3:00–4:30 PM', room: 'Lab 4', units: 3, currentCapacity: 28, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 101']),
    Course(id: 'is_4', code: 'IS 301', title: 'Enterprise Architecture', instructorId: 'prof_12', schedule: 'MWF 4:30–6:00 PM', room: 'Room 204', units: 3, currentCapacity: 10, maxCapacity: 20, departmentId: 'CCI', prerequisites: ['IS 201']),
    Course(id: 'is_5', code: 'IS 401', title: 'IS Strategy, Management, & Acq', instructorId: 'prof_12', schedule: 'Sat 1:00–4:00 PM', room: 'Room 205', units: 3, currentCapacity: 18, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['IS 301']),
  ];

  // 4. ACTIVE ENROLLMENTS
  static final List<Enrollment> enrollments = [
    Enrollment(id: 'e_1', studentId: 'uid_1', courseId: 'cs_5', semester: '1st Sem 2024-2025', status: EnrollmentStatus.enrolled, dateRequested: DateTime.now().subtract(const Duration(days: 10))),
    Enrollment(id: 'e_2', studentId: 'uid_1', courseId: 'cs_6', semester: '1st Sem 2024-2025', status: EnrollmentStatus.enrolled, dateRequested: DateTime.now().subtract(const Duration(days: 9))),
    Enrollment(id: 'e_3', studentId: 'uid_2', courseId: 'it_2', semester: '1st Sem 2024-2025', status: EnrollmentStatus.enrolled, dateRequested: DateTime.now().subtract(const Duration(days: 5))),
    Enrollment(id: 'e_4', studentId: 'uid_3', courseId: 'is_1', semester: '1st Sem 2024-2025', status: EnrollmentStatus.pending, dateRequested: DateTime.now().subtract(const Duration(days: 1))),
    
    // COMPLETED PREREQUISITES FOR TESTING
    // Giving uid_1 (Maria) completed status for early CS courses so she can enroll in higher ones!
    Enrollment(id: 'e_history_1', studentId: 'uid_1', courseId: 'cs_1', semester: '1st Sem 2023-2024', status: EnrollmentStatus.completed, dateRequested: DateTime(2023, 6, 1)),
    Enrollment(id: 'e_history_2', studentId: 'uid_1', courseId: 'cs_2', semester: '1st Sem 2023-2024', status: EnrollmentStatus.completed, dateRequested: DateTime(2023, 6, 1)),
    Enrollment(id: 'e_history_3', studentId: 'uid_1', courseId: 'cs_3', semester: '2nd Sem 2023-2024', status: EnrollmentStatus.completed, dateRequested: DateTime(2023, 11, 1)),
  ];

  // 5. NARROWED DEPARTMENTS LIST
  static final List<Department> departments = [
    Department(
      code: 'CCI', 
      name: 'College of Computing and Informatics', 
      dean: 'Dr. Elena Bautista', 
      totalStudents: 1200, 
      totalCourses: 45, 
      color: const Color(0xFF7C3AED)
    ),
  ];

  // --- UI CONSTANTS & ANALYTICS ---

  static const List<Color> avatarColors = [
    Color(0xFF2563AB), Color(0xFF7C3AED), Color(0xFFDB2777),
    Color(0xFF059669), Color(0xFFD97706), Color(0xFF0891B2),
  ];

  // Updated to show the distribution of programs within CCI
  static Map<String, int> get enrollmentByProgram => {
    'BS Computer Science': 450,
    'BS Information Technology': 520,
    'BS Information Systems': 230,
  };

  static List<Map<String, dynamic>> get monthlyEnrollment => [
    {'month': 'Jan', 'count': 42}, {'month': 'Feb', 'count': 38},
    {'month': 'Mar', 'count': 55}, {'month': 'Apr', 'count': 67},
    {'month': 'May', 'count': 48}, {'month': 'Jun', 'count': 130},
    {'month': 'Jul', 'count': 145}, {'month': 'Aug', 'count': 98},
    {'month': 'Sep', 'count': 62}, {'month': 'Oct', 'count': 45},
    {'month': 'Nov', 'count': 38}, {'month': 'Dec', 'count': 22},
  ];
}