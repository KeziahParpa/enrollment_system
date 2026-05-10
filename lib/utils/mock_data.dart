import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../models/department.dart';

class MockData {
  // 1. UPDATED STUDENTS LIST (Mapped to new programs)
  static final List<Student> students = [
    Student(
      id: 'uid_1',
      studentId: '2024-0001',
      firstName: 'Maria',
      lastName: 'Santos',
      email: 'maria.santos@students.isatu.edu',
      phone: '09171234567',
      program: 'BS Computer Science',
      yearLevel: '3rd Year',
      gpa: 1.5,
    ),
    Student(
      id: 'uid_2',
      studentId: '2024-0002',
      firstName: 'Juan',
      lastName: 'dela Cruz',
      email: 'juan.delacruz@students.isatu.edu',
      phone: '09182345678',
      program: 'BS Computer Science',
      yearLevel: '2nd Year',
      gpa: 2.1,
    ),
    Student(
      id: 'uid_3',
      studentId: '2024-0003',
      firstName: 'Ana',
      lastName: 'Reyes',
      email: 'ana.reyes@students.isatu.edu',
      phone: '09193456789',
      program: 'BS Computer Science',
      yearLevel: '1st Year',
      gpa: 1.75,
    ),
    Student(
      id: 'uid_4',
      studentId: '2024-0004',
      firstName: 'Carlos',
      lastName: 'Mendoza',
      email: 'carlos.mendoza@students.isatu.edu',
      phone: '09204567890',
      program: 'BS Computer Science',
      yearLevel: '4th Year',
      gpa: 1.25,
    ),
    Student(
      id: 'uid_5',
      studentId: '2024-0005',
      firstName: 'Liza',
      lastName: 'Garcia',
      email: 'liza.garcia@students.isatu.edu',
      phone: '09215678901',
      program: 'BS Computer Science',
      yearLevel: '2nd Year',
      gpa: 2.5,
    ),
    Student(
      id: 'uid_6',
      studentId: '2024-0006',
      firstName: 'Ramon',
      lastName: 'Torres',
      email: 'ramon.torres@students.isatu.edu',
      phone: '09226789012',
      program: 'BS Computer Science',
      yearLevel: '3rd Year',
      gpa: 1.8,
    ),
  ];

  // 2. UPDATED COURSES LIST (Mapped to new Department IDs)
  static final List<Course> courses = [
    Course(
      id: 'c_1',
      code: 'CS101',
      title: 'Introduction to Programming',
      instructorId: 'prof_1',
      schedule: 'MWF 7:30–9:00 AM',
      room: 'Lab 201',
      units: 3,
      currentCapacity: 38,
      maxCapacity: 40,
      departmentId: 'CCI',
      prerequisites: [],
    ),
    Course(
      id: 'c_2',
      code: 'CS201',
      title: 'Data Structures & Algorithms',
      instructorId: 'prof_2',
      schedule: 'TTH 10:30 AM–12:00 PM',
      room: 'Lab 203',
      units: 3,
      currentCapacity: 35,
      maxCapacity: 40,
      departmentId: 'CCI',
      prerequisites: ['CS101'],
    ),
    Course(
      id: 'c_3',
      code: 'CE101',
      title: 'Statics of Rigid Bodies',
      instructorId: 'prof_3',
      schedule: 'MWF 1:00–2:30 PM',
      room: 'Room 305',
      units: 3,
      currentCapacity: 28,
      maxCapacity: 35,
      departmentId: 'CCI',
      prerequisites: [],
    ),
    Course(
      id: 'c_4',
      code: 'IT101',
      title: 'Web Development Fundamentals',
      instructorId: 'prof_4',
      schedule: 'TTH 7:30–9:00 AM',
      room: 'Lab 101',
      units: 3,
      currentCapacity: 40,
      maxCapacity: 40,
      departmentId: 'CCI',
      prerequisites: [],
    ),
    Course(
      id: 'c_5',
      code: 'BIO101',
      title: 'General Biology',
      instructorId: 'prof_5',
      schedule: 'TTH 9:00–10:30 AM',
      room: 'Lab 4',
      units: 4,
      currentCapacity: 30,
      maxCapacity: 30,
      departmentId: 'CCI',
      prerequisites: [],
    ),
    Course(
      id: 'c_6',
      code: 'EDUC101',
      title: 'The Child and Adolescent Learners',
      instructorId: 'prof_6',
      schedule: 'MWF 9:00–10:30 AM',
      room: 'Room 102',
      units: 3,
      currentCapacity: 45,
      maxCapacity: 50,
      departmentId: 'CCI',
      prerequisites: [],
    ),
    Course(
      id: 'c_7',
      code: 'AUTO101',
      title: 'Automotive Electrical Systems',
      instructorId: 'prof_7',
      schedule: 'Sat 8:00–12:00 PM',
      room: 'Shop A',
      units: 3,
      currentCapacity: 20,
      maxCapacity: 25,
      departmentId: 'CCI',
      prerequisites: [],
    ),
  ];

  // 3. ENROLLMENTS LIST
  static final List<Enrollment> enrollments = [
    Enrollment(
      id: 'e_1',
      studentId: 'uid_1',
      courseId: 'c_2',
      semester: '1st Sem 2024-2025',
      status: EnrollmentStatus.enrolled,
      dateRequested: DateTime(2024, 6, 10),
    ),
    Enrollment(
      id: 'e_2',
      studentId: 'uid_3',
      courseId: 'c_3',
      semester: '1st Sem 2024-2025',
      status: EnrollmentStatus.pending,
      dateRequested: DateTime(2024, 6, 15),
    ),
    Enrollment(
      id: 'e_3',
      studentId: 'uid_5',
      courseId: 'c_5',
      semester: '1st Sem 2024-2025',
      status: EnrollmentStatus.dropped,
      dateRequested: DateTime(2024, 6, 9),
    ),
    Enrollment(
      id: 'e_4',
      studentId: 'uid_6',
      courseId: 'c_6',
      semester: '1st Sem 2024-2025',
      status: EnrollmentStatus.pending,
      dateRequested: DateTime(2024, 6, 16),
    ),
  ];

  // 4. THE CORRECTED DEPARTMENTS LIST
  static final List<Department> departments = [
    Department(
      code: 'CAS',
      name: 'College of Arts and Sciences',
      dean: 'Dr. Maria Santos',
      totalStudents: 350,
      totalCourses: 20,
      color: const Color(0xFF2563AB),
    ),
    Department(
      code: 'CEA',
      name: 'College of Engineering and Architecture',
      dean: 'Engr. Roberto Chan',
      totalStudents: 480,
      totalCourses: 28,
      color: const Color(0xFFD97706),
    ),
    Department(
      code: 'CIT',
      name: 'College of Industrial Technology',
      dean: 'Dr. Benjamin Lacson',
      totalStudents: 290,
      totalCourses: 15,
      color: const Color(0xFF0891B2),
    ),
    Department(
      code: 'CCI',
      name: 'College of Computing and Informatics',
      dean: 'Dr. Elena Bautista',
      totalStudents: 420,
      totalCourses: 24,
      color: const Color(0xFF7C3AED),
    ),
    Department(
      code: 'COE',
      name: 'College of Education',
      dean: 'Dr. Theresa Ang',
      totalStudents: 310,
      totalCourses: 16,
      color: const Color(0xFF059669),
    ),
  ];

  // --- UI CONSTANTS & ANALYTICS ---

  static const List<Color> avatarColors = [
    Color(0xFF2563AB),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFF0891B2),
  ];

  // Updated to match the new colleges
  static Map<String, int> get enrollmentByProgram => {
    'CAS': 350,
    'CEA': 480,
    'CIT': 290,
    'CCI': 420,
    'COE': 310,
  };

  static List<Map<String, dynamic>> get monthlyEnrollment => [
    {'month': 'Jan', 'count': 42},
    {'month': 'Feb', 'count': 38},
    {'month': 'Mar', 'count': 55},
    {'month': 'Apr', 'count': 67},
    {'month': 'May', 'count': 48},
    {'month': 'Jun', 'count': 130},
    {'month': 'Jul', 'count': 145},
    {'month': 'Aug', 'count': 98},
    {'month': 'Sep', 'count': 62},
    {'month': 'Oct', 'count': 45},
    {'month': 'Nov', 'count': 38},
    {'month': 'Dec', 'count': 22},
  ];
}
