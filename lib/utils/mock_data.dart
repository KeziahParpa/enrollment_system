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
  };

  // 2. CCI STUDENTS LIST
  static final List<Student> students = [
    Student(id: 'uid_1', studentId: '2024-0001', firstName: 'Maria', lastName: 'Santos', email: 'maria.santos@students.isatu.edu', phone: '09171234567', program: 'BS Computer Science', yearLevel: '3rd Year', gpa: 1.5),
    Student(id: 'uid_2', studentId: '2024-0002', firstName: 'Juan', lastName: 'dela Cruz', email: 'juan.delacruz@students.isatu.edu', phone: '09182345678', program: 'BS Information Technology', yearLevel: '2nd Year', gpa: 2.1),
    Student(id: 'uid_3', studentId: '2024-0003', firstName: 'Ana', lastName: 'Reyes', email: 'ana.reyes@students.isatu.edu', phone: '09193456789', program: 'BS Information Systems', yearLevel: '1st Year', gpa: 1.75),
  ];

  // 3. COMPLETE CCI COURSE CATALOG
  static final List<Course> courses = [
    // =========================================================================
    // BS COMPUTER SCIENCE (Transcribed exactly from uploaded images)
    // =========================================================================
    // --- CS 1st Year ---
    Course(id: 'cs_102', code: 'ICT 102', title: 'Introduction to Computing', instructorId: 'prof_1', schedule: 'MWF 7:30–9:00 AM', room: 'Lab 1', units: 3, currentCapacity: 38, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_1', code: 'CS 1', title: 'Programming Logic Formulation', instructorId: 'prof_2', schedule: 'TTH 9:00–10:30 AM', room: 'Lab 2', units: 3, currentCapacity: 40, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'ge_1', code: 'GE 4 MATH', title: 'Mathematics in the Modern World', instructorId: 'prof_ge', schedule: 'MWF 9:00-10:00 AM', room: 'Rm 101', units: 3, currentCapacity: 35, maxCapacity: 40, departmentId: 'CAS', prerequisites: []),
    Course(id: 'ge_2', code: 'GE 5 ENG', title: 'Purposive Communication', instructorId: 'prof_ge', schedule: 'TTH 10:30-12:00 PM', room: 'Rm 102', units: 3, currentCapacity: 30, maxCapacity: 40, departmentId: 'CAS', prerequisites: []),
    Course(id: 'pe_1', code: 'PE 1', title: 'Movement Competency Training', instructorId: 'prof_pe', schedule: 'Sat 7:00-9:00 AM', room: 'Gym', units: 2, currentCapacity: 40, maxCapacity: 40, departmentId: 'CAS', prerequisites: []),
    Course(id: 'cs_103', code: 'ICT 103', title: 'Fundamentals of Programming', instructorId: 'prof_2', schedule: 'MWF 1:00–2:30 PM', room: 'Lab 2', units: 3, currentCapacity: 35, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['CS 1']),
    Course(id: 'cs_105', code: 'ICT 105', title: 'Discrete Structure 1', instructorId: 'prof_3', schedule: 'TTH 1:00–2:30 PM', room: 'Rm 305', units: 3, currentCapacity: 28, maxCapacity: 35, departmentId: 'CCI', prerequisites: ['CS 1']),
    Course(id: 'cs_106', code: 'ICT 106', title: 'System Fundamentals', instructorId: 'prof_1', schedule: 'MWF 3:00-4:30 PM', room: 'Lab 3', units: 3, currentCapacity: 30, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['ICT 102']),
    
    // --- CS 2nd Year ---
    Course(id: 'cs_104', code: 'ICT 104', title: 'Intermediate Programming', instructorId: 'prof_1', schedule: 'MWF 9:00–10:30 AM', room: 'Lab 3', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 103']),
    Course(id: 'cs_107', code: 'ICT 107', title: 'Data Structures and Algorithms', instructorId: 'prof_4', schedule: 'TTH 3:00–4:30 PM', room: 'Lab 1', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 103']),
    Course(id: 'cs_113', code: 'ICT 113', title: 'Networks and Communications', instructorId: 'prof_5', schedule: 'MWF 10:30-12:00 PM', room: 'Cisco Lab', units: 3, currentCapacity: 22, maxCapacity: 30, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_m12', code: 'MATH 12', title: 'Introduction to Calculus', instructorId: 'prof_m', schedule: 'TTH 9:00-10:30 AM', room: 'Rm 201', units: 3, currentCapacity: 28, maxCapacity: 35, departmentId: 'CAS', prerequisites: ['ICT 105']),
    Course(id: 'cs_110', code: 'ICT 110', title: 'Applications Dev & Emerging Tech', instructorId: 'prof_6', schedule: 'MWF 1:00-2:30 PM', room: 'Lab 4', units: 3, currentCapacity: 15, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 104']),
    Course(id: 'cs_111', code: 'ICT 111', title: 'Object Oriented Programming', instructorId: 'prof_4', schedule: 'TTH 10:30-12:00 PM', room: 'Lab 2', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 104']),
    Course(id: 'cs_112', code: 'ICT 112', title: 'Operating Systems', instructorId: 'prof_5', schedule: 'MWF 3:00-4:30 PM', room: 'Lab 1', units: 3, currentCapacity: 18, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 107']),
    Course(id: 'cs_114', code: 'ICT 114', title: 'Software Engineering 1', instructorId: 'prof_7', schedule: 'TTH 1:00-2:30 PM', room: 'Rm 301', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 104']),
    Course(id: 'cs_122', code: 'ICT 122', title: 'Algorithms and Complexity', instructorId: 'prof_3', schedule: 'MWF 4:30-6:00 PM', room: 'Rm 302', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 107']),

    // --- CS 3rd Year ---
    Course(id: 'cs_108', code: 'ICT 108', title: 'Information Assurance and Security', instructorId: 'prof_8', schedule: 'TTH 7:30-9:00 AM', room: 'Lab 5', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 104']),
    Course(id: 'cs_115', code: 'ICT 115', title: 'Programming Languages', instructorId: 'prof_4', schedule: 'MWF 9:00-10:30 AM', room: 'Lab 2', units: 3, currentCapacity: 22, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 107']),
    Course(id: 'cs_109', code: 'ICT 109', title: 'Information Management', instructorId: 'prof_9', schedule: 'TTH 10:30-12:00 PM', room: 'Lab 3', units: 3, currentCapacity: 15, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 107']),
    Course(id: 'cs_117', code: 'ICT 117', title: 'Discrete Structure 2', instructorId: 'prof_3', schedule: 'MWF 1:00-2:30 PM', room: 'Rm 304', units: 3, currentCapacity: 18, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 105']),
    Course(id: 'cs_118', code: 'ICT 118', title: 'Architecture and Organization', instructorId: 'prof_5', schedule: 'TTH 1:00-2:30 PM', room: 'Rm 305', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 102']),
    Course(id: 'cs_116', code: 'ICT 116', title: 'Human Computer Interaction', instructorId: 'prof_10', schedule: 'MWF 3:00-4:30 PM', room: 'Mac Lab', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_119', code: 'ICT 119', title: 'Parallel and Distributed Computing', instructorId: 'prof_11', schedule: 'TTH 3:00-4:30 PM', room: 'Lab 5', units: 3, currentCapacity: 15, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 118']),
    Course(id: 'cs_120', code: 'ICT 120', title: 'Intelligent Systems', instructorId: 'prof_12', schedule: 'MWF 4:30-6:00 PM', room: 'Lab 4', units: 3, currentCapacity: 22, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 107']),
    Course(id: 'cs_121', code: 'ICT 121', title: 'Software Engineering 2', instructorId: 'prof_7', schedule: 'Sat 8:00-11:00 AM', room: 'Lab 2', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 114']),
    Course(id: 'cs_t1', code: 'CS 7', title: 'Computer Science Thesis 1', instructorId: 'prof_13', schedule: 'Sat 1:00-4:00 PM', room: 'Rm 401', units: 3, currentCapacity: 28, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 114', 'ICT 122']),

    // --- CS 4th Year ---
    Course(id: 'cs_123', code: 'ICT 123', title: 'Web Information Systems', instructorId: 'prof_14', schedule: 'TTH 9:00-10:30 AM', room: 'Lab 3', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 103']),
    Course(id: 'cs_136', code: 'ICT 136', title: 'Social Issues and Prof Practice 1', instructorId: 'prof_15', schedule: 'MWF 10:30-12:00 PM', room: 'Rm 402', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 102']),
    Course(id: 'cs_t2', code: 'CS 8', title: 'Computer Science Thesis 2', instructorId: 'prof_13', schedule: 'TTH 10:30-12:00 PM', room: 'Rm 401', units: 3, currentCapacity: 28, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['CS 7']),
    Course(id: 'cs_124', code: 'ICT 124', title: 'Automata Theory and Formal Lang', instructorId: 'prof_3', schedule: 'MWF 1:00-2:30 PM', room: 'Rm 403', units: 3, currentCapacity: 15, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['ICT 117']),
    Course(id: 'cs_125', code: 'ICT 125', title: 'Student Internship Program (300hrs)', instructorId: 'prof_16', schedule: 'TBA', room: 'Off-Campus', units: 3, currentCapacity: 40, maxCapacity: 100, departmentId: 'CCI', prerequisites: ['CS 8']), // simplified prereq

    // --- CS Tracks (Data Science & Animation) ---
    Course(id: 'cs_ds1', code: 'CS 101', title: 'Data Science Tools and R Prog', instructorId: 'prof_ds', schedule: 'Sat 8:00-11:00 AM', room: 'Lab 4', units: 3, currentCapacity: 15, maxCapacity: 25, departmentId: 'CCI', prerequisites: []),
    Course(id: 'cs_ds2', code: 'CS 102', title: 'Data Preparation', instructorId: 'prof_ds', schedule: 'Sat 1:00-4:00 PM', room: 'Lab 4', units: 3, currentCapacity: 10, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['CS 101']),
    Course(id: 'cs_an1', code: 'ANIM 101', title: 'Fundamentals of Animation', instructorId: 'prof_an', schedule: 'TTH 4:30-6:00 PM', room: 'Mac Lab', units: 3, currentCapacity: 20, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['ICT 102']),
    Course(id: 'cs_an2', code: 'ANIM 102', title: 'Fundamentals of Digital 2D', instructorId: 'prof_an', schedule: 'MWF 4:30-6:00 PM', room: 'Mac Lab', units: 3, currentCapacity: 18, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['ANIM 101']),


    // =========================================================================
    // BS INFORMATION TECHNOLOGY (Generated Complete Curriculum)
    // =========================================================================
    Course(id: 'it_101', code: 'IT 101', title: 'IT Fundamentals', instructorId: 'prof_it1', schedule: 'MWF 7:30–9:00 AM', room: 'Rm 101', units: 3, currentCapacity: 35, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'it_102', code: 'IT 102', title: 'Computer Programming 1', instructorId: 'prof_it2', schedule: 'TTH 9:00–10:30 AM', room: 'Lab 5', units: 3, currentCapacity: 38, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'it_103', code: 'IT 103', title: 'Computer Programming 2', instructorId: 'prof_it2', schedule: 'MWF 10:30–12:00 PM', room: 'Lab 5', units: 3, currentCapacity: 30, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['IT 102']),
    Course(id: 'it_104', code: 'IT 104', title: 'Data Structures for IT', instructorId: 'prof_it3', schedule: 'TTH 1:00–2:30 PM', room: 'Lab 6', units: 3, currentCapacity: 25, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['IT 103']),
    Course(id: 'it_201', code: 'IT 201', title: 'Networking 1 (Routing & Switching)', instructorId: 'prof_it4', schedule: 'MWF 1:00–2:30 PM', room: 'Cisco Lab', units: 3, currentCapacity: 22, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 101']),
    Course(id: 'it_202', code: 'IT 202', title: 'Networking 2 (Adv Routing)', instructorId: 'prof_it4', schedule: 'TTH 3:00–4:30 PM', room: 'Cisco Lab', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 201']),
    Course(id: 'it_203', code: 'IT 203', title: 'Web Systems and Technologies 1', instructorId: 'prof_it5', schedule: 'MWF 3:00–4:30 PM', room: 'Lab 7', units: 3, currentCapacity: 30, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['IT 103']),
    Course(id: 'it_204', code: 'IT 204', title: 'Information Management', instructorId: 'prof_it6', schedule: 'TTH 7:30–9:00 AM', room: 'Lab 8', units: 3, currentCapacity: 28, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['IT 104']),
    Course(id: 'it_301', code: 'IT 301', title: 'Systems Integration and Architecture', instructorId: 'prof_it7', schedule: 'MWF 9:00–10:30 AM', room: 'Rm 501', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 203', 'IT 204']),
    Course(id: 'it_302', code: 'IT 302', title: 'Systems Administration and Maintenance', instructorId: 'prof_it4', schedule: 'TTH 10:30–12:00 PM', room: 'Cisco Lab', units: 3, currentCapacity: 18, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 202']),
    Course(id: 'it_303', code: 'IT 303', title: 'IT Elective 1 (Cloud Computing)', instructorId: 'prof_it8', schedule: 'Sat 8:00–11:00 AM', room: 'Lab 6', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 302']),
    Course(id: 'it_304', code: 'IT 304', title: 'Capstone Project and Research 1', instructorId: 'prof_it9', schedule: 'MWF 1:00–2:30 PM', room: 'Rm 502', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 301']),
    Course(id: 'it_401', code: 'IT 401', title: 'Information Assurance and Security', instructorId: 'prof_it10', schedule: 'TTH 1:00–2:30 PM', room: 'Lab 7', units: 3, currentCapacity: 22, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 302']),
    Course(id: 'it_402', code: 'IT 402', title: 'Capstone Project and Research 2', instructorId: 'prof_it9', schedule: 'MWF 3:00–4:30 PM', room: 'Rm 502', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IT 304']),
    Course(id: 'it_403', code: 'IT 403', title: 'Practicum (486 hrs)', instructorId: 'prof_it11', schedule: 'TBA', room: 'Off-Campus', units: 6, currentCapacity: 50, maxCapacity: 100, departmentId: 'CCI', prerequisites: ['IT 402']),


    // =========================================================================
    // BS INFORMATION SYSTEMS (Generated Complete Curriculum)
    // =========================================================================
    Course(id: 'is_101', code: 'IS 101', title: 'Fundamentals of Information Systems', instructorId: 'prof_is1', schedule: 'TTH 7:30–9:00 AM', room: 'Rm 601', units: 3, currentCapacity: 38, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'is_102', code: 'IS 102', title: 'Organizational Behavior in IT', instructorId: 'prof_is2', schedule: 'MWF 9:00–10:30 AM', room: 'Rm 602', units: 3, currentCapacity: 35, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'is_103', code: 'IS 103', title: 'IS Programming 1', instructorId: 'prof_is3', schedule: 'TTH 10:30–12:00 PM', room: 'Lab 9', units: 3, currentCapacity: 30, maxCapacity: 40, departmentId: 'CCI', prerequisites: []),
    Course(id: 'is_104', code: 'IS 104', title: 'IS Programming 2', instructorId: 'prof_is3', schedule: 'MWF 1:00–2:30 PM', room: 'Lab 9', units: 3, currentCapacity: 28, maxCapacity: 40, departmentId: 'CCI', prerequisites: ['IS 103']),
    Course(id: 'is_201', code: 'IS 201', title: 'Database Management Systems', instructorId: 'prof_is4', schedule: 'TTH 1:00–2:30 PM', room: 'Lab 10', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 101', 'IS 104']),
    Course(id: 'is_202', code: 'IS 202', title: 'Systems Analysis and Design', instructorId: 'prof_is5', schedule: 'MWF 3:00–4:30 PM', room: 'Rm 603', units: 3, currentCapacity: 28, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 101']),
    Course(id: 'is_203', code: 'IS 203', title: 'Business Processes and ERP', instructorId: 'prof_is6', schedule: 'TTH 3:00–4:30 PM', room: 'Rm 604', units: 3, currentCapacity: 22, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 202']),
    Course(id: 'is_301', code: 'IS 301', title: 'Enterprise Architecture', instructorId: 'prof_is7', schedule: 'MWF 7:30–9:00 AM', room: 'Rm 605', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 202']),
    Course(id: 'is_302', code: 'IS 302', title: 'IS Project Management', instructorId: 'prof_is8', schedule: 'TTH 9:00–10:30 AM', room: 'Rm 606', units: 3, currentCapacity: 25, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 202']),
    Course(id: 'is_303', code: 'IS 303', title: 'Data Analytics for Business', instructorId: 'prof_is9', schedule: 'Sat 8:00–11:00 AM', room: 'Lab 10', units: 3, currentCapacity: 18, maxCapacity: 25, departmentId: 'CCI', prerequisites: ['IS 201']),
    Course(id: 'is_304', code: 'IS 304', title: 'IS Capstone Project 1', instructorId: 'prof_is10', schedule: 'MWF 10:30–12:00 PM', room: 'Rm 607', units: 3, currentCapacity: 24, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 302']),
    Course(id: 'is_401', code: 'IS 401', title: 'IS Strategy, Management, & Acq', instructorId: 'prof_is11', schedule: 'TTH 10:30–12:00 PM', room: 'Rm 608', units: 3, currentCapacity: 20, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 301']),
    Course(id: 'is_402', code: 'IS 402', title: 'IS Capstone Project 2', instructorId: 'prof_is10', schedule: 'MWF 1:00–2:30 PM', room: 'Rm 607', units: 3, currentCapacity: 24, maxCapacity: 30, departmentId: 'CCI', prerequisites: ['IS 304']),
    Course(id: 'is_403', code: 'IS 403', title: 'IS Internship', instructorId: 'prof_is12', schedule: 'TBA', room: 'Off-Campus', units: 6, currentCapacity: 35, maxCapacity: 50, departmentId: 'CCI', prerequisites: ['IS 402']),
  ];

  // 4. ACTIVE ENROLLMENTS
  static final List<Enrollment> enrollments = [
    // Pre-enrolled classes for the dashboard demo
    Enrollment(id: 'e_1', studentId: 'uid_1', courseId: 'cs_108', semester: '1st Sem 2024-2025', status: EnrollmentStatus.enrolled, dateRequested: DateTime.now().subtract(const Duration(days: 10))),
    Enrollment(id: 'e_2', studentId: 'uid_1', courseId: 'cs_115', semester: '1st Sem 2024-2025', status: EnrollmentStatus.enrolled, dateRequested: DateTime.now().subtract(const Duration(days: 9))),
    Enrollment(id: 'e_3', studentId: 'uid_2', courseId: 'it_201', semester: '1st Sem 2024-2025', status: EnrollmentStatus.enrolled, dateRequested: DateTime.now().subtract(const Duration(days: 5))),
    Enrollment(id: 'e_4', studentId: 'uid_3', courseId: 'is_101', semester: '1st Sem 2024-2025', status: EnrollmentStatus.pending, dateRequested: DateTime.now().subtract(const Duration(days: 1))),
    
    // Maria's History (So she can enroll in 3rd year CS subjects)
    Enrollment(id: 'eh_1', studentId: 'uid_1', courseId: 'cs_102', semester: '1st Sem 2022', status: EnrollmentStatus.completed, dateRequested: DateTime(2022, 6, 1)),
    Enrollment(id: 'eh_2', studentId: 'uid_1', courseId: 'cs_1', semester: '1st Sem 2022', status: EnrollmentStatus.completed, dateRequested: DateTime(2022, 6, 1)),
    Enrollment(id: 'eh_3', studentId: 'uid_1', courseId: 'cs_103', semester: '2nd Sem 2022', status: EnrollmentStatus.completed, dateRequested: DateTime(2022, 11, 1)),
    Enrollment(id: 'eh_4', studentId: 'uid_1', courseId: 'cs_105', semester: '2nd Sem 2022', status: EnrollmentStatus.completed, dateRequested: DateTime(2022, 11, 1)),
    Enrollment(id: 'eh_5', studentId: 'uid_1', courseId: 'cs_104', semester: '1st Sem 2023', status: EnrollmentStatus.completed, dateRequested: DateTime(2023, 6, 1)),
    Enrollment(id: 'eh_6', studentId: 'uid_1', courseId: 'cs_107', semester: '1st Sem 2023', status: EnrollmentStatus.completed, dateRequested: DateTime(2023, 6, 1)),
  ];

  static final List<Department> departments = [
    Department(code: 'CCI', name: 'College of Computing and Informatics', dean: 'Dr. Elena Bautista', totalStudents: 1200, totalCourses: 45, color: const Color(0xFF7C3AED)),
  ];

  static const List<Color> avatarColors = [Color(0xFF2563AB), Color(0xFF7C3AED), Color(0xFFDB2777), Color(0xFF059669), Color(0xFFD97706), Color(0xFF0891B2)];

  // --- ANALYTICS & REPORTS DATA (Added back for reports_screen.dart) ---
  
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