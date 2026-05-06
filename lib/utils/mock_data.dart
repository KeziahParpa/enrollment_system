import 'package:flutter/material.dart';
import '../models/student.dart';

class MockData {
  static final List<Student> students = [
    Student(id: '2024-0001', firstName: 'Maria', lastName: 'Santos', email: 'maria.santos@school.edu', phone: '09171234567', program: 'BS Computer Science', yearLevel: '3rd Year', section: 'CS-3A', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 10), avatarColorIndex: 0),
    Student(id: '2024-0002', firstName: 'Juan', lastName: 'dela Cruz', email: 'juan.delacruz@school.edu', phone: '09182345678', program: 'BS Information Technology', yearLevel: '2nd Year', section: 'IT-2B', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 11), avatarColorIndex: 1),
    Student(id: '2024-0003', firstName: 'Ana', lastName: 'Reyes', email: 'ana.reyes@school.edu', phone: '09193456789', program: 'BS Computer Science', yearLevel: '1st Year', section: 'CS-1A', status: EnrollmentStatus.pending, enrolledDate: DateTime(2024, 6, 15), avatarColorIndex: 2),
    Student(id: '2024-0004', firstName: 'Carlos', lastName: 'Mendoza', email: 'carlos.mendoza@school.edu', phone: '09204567890', program: 'BS Business Administration', yearLevel: '4th Year', section: 'BA-4A', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 8), avatarColorIndex: 3),
    Student(id: '2024-0005', firstName: 'Liza', lastName: 'Garcia', email: 'liza.garcia@school.edu', phone: '09215678901', program: 'BS Nursing', yearLevel: '2nd Year', section: 'NUR-2A', status: EnrollmentStatus.dropped, enrolledDate: DateTime(2024, 6, 9), avatarColorIndex: 4),
    Student(id: '2024-0006', firstName: 'Ramon', lastName: 'Torres', email: 'ramon.torres@school.edu', phone: '09226789012', program: 'BS Information Technology', yearLevel: '3rd Year', section: 'IT-3A', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 12), avatarColorIndex: 5),
    Student(id: '2024-0007', firstName: 'Patricia', lastName: 'Lim', email: 'patricia.lim@school.edu', phone: '09237890123', program: 'BS Nursing', yearLevel: '4th Year', section: 'NUR-4A', status: EnrollmentStatus.graduated, enrolledDate: DateTime(2020, 6, 10), avatarColorIndex: 0),
    Student(id: '2024-0008', firstName: 'Marco', lastName: 'Villanueva', email: 'marco.villanueva@school.edu', phone: '09248901234', program: 'BS Computer Science', yearLevel: '2nd Year', section: 'CS-2B', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 13), avatarColorIndex: 1),
    Student(id: '2024-0009', firstName: 'Sophia', lastName: 'Aquino', email: 'sophia.aquino@school.edu', phone: '09259012345', program: 'BS Business Administration', yearLevel: '1st Year', section: 'BA-1A', status: EnrollmentStatus.pending, enrolledDate: DateTime(2024, 6, 16), avatarColorIndex: 2),
    Student(id: '2024-0010', firstName: 'Daniel', lastName: 'Ramos', email: 'daniel.ramos@school.edu', phone: '09260123456', program: 'BS Information Technology', yearLevel: '4th Year', section: 'IT-4A', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 7), avatarColorIndex: 3),
    Student(id: '2024-0011', firstName: 'Isabel', lastName: 'Cruz', email: 'isabel.cruz@school.edu', phone: '09271234567', program: 'BS Computer Science', yearLevel: '3rd Year', section: 'CS-3B', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 11), avatarColorIndex: 4),
    Student(id: '2024-0012', firstName: 'Miguel', lastName: 'Fernandez', email: 'miguel.fernandez@school.edu', phone: '09282345678', program: 'BS Nursing', yearLevel: '1st Year', section: 'NUR-1A', status: EnrollmentStatus.enrolled, enrolledDate: DateTime(2024, 6, 14), avatarColorIndex: 5),
  ];

  static final List<Course> courses = [
    Course(code: 'CS101', title: 'Introduction to Programming', instructor: 'Dr. Elena Bautista', schedule: 'MWF 7:30–9:00 AM', room: 'Lab 201', units: 3, enrolled: 38, capacity: 40, program: 'BS Computer Science'),
    Course(code: 'CS201', title: 'Data Structures & Algorithms', instructor: 'Prof. Ricardo Soriano', schedule: 'TTH 10:30 AM–12:00 PM', room: 'Lab 203', units: 3, enrolled: 35, capacity: 40, program: 'BS Computer Science'),
    Course(code: 'CS301', title: 'Operating Systems', instructor: 'Dr. Marita Dizon', schedule: 'MWF 1:00–2:30 PM', room: 'Room 305', units: 3, enrolled: 28, capacity: 35, program: 'BS Computer Science'),
    Course(code: 'IT101', title: 'Web Development Fundamentals', instructor: 'Prof. Jerome Pascual', schedule: 'TTH 7:30–9:00 AM', room: 'Lab 101', units: 3, enrolled: 40, capacity: 40, program: 'BS Information Technology'),
    Course(code: 'IT201', title: 'Database Management', instructor: 'Dr. Carmela Uy', schedule: 'MWF 9:00–10:30 AM', room: 'Lab 202', units: 3, enrolled: 33, capacity: 40, program: 'BS Information Technology'),
    Course(code: 'IT301', title: 'Network Administration', instructor: 'Prof. Alvin Navarro', schedule: 'TTH 1:00–2:30 PM', room: 'Lab 104', units: 3, enrolled: 22, capacity: 35, program: 'BS Information Technology'),
    Course(code: 'BA101', title: 'Principles of Management', instructor: 'Dr. Grace Tan', schedule: 'MWF 10:30 AM–12:00 PM', room: 'Room 201', units: 3, enrolled: 45, capacity: 50, program: 'BS Business Administration'),
    Course(code: 'NUR101', title: 'Fundamentals of Nursing', instructor: 'Prof. Rosario Ocampo', schedule: 'TTH 9:00–10:30 AM', room: 'Sim Lab 1', units: 4, enrolled: 30, capacity: 30, program: 'BS Nursing'),
  ];

  static final List<Department> departments = [
    Department(code: 'CCS', name: 'College of Computer Studies', dean: 'Dr. Roberto Chan', totalStudents: 420, totalCourses: 24, color: const Color(0xFF2563AB)),
    Department(code: 'CBA', name: 'College of Business Administration', dean: 'Dr. Theresa Ang', totalStudents: 385, totalCourses: 18, color: const Color(0xFF7C3AED)),
    Department(code: 'CON', name: 'College of Nursing', dean: 'Dr. Felicidad Roque', totalStudents: 290, totalCourses: 20, color: const Color(0xFFDB2777)),
    Department(code: 'CEAS', name: 'College of Education', dean: 'Dr. Benjamin Lacson', totalStudents: 310, totalCourses: 16, color: const Color(0xFFD97706)),
  ];

  static const List<Color> avatarColors = [
    Color(0xFF2563AB),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFF0891B2),
  ];

  static Map<String, int> get enrollmentByProgram => {
    'BS Computer Science': 185,
    'BS Information Technology': 145,
    'BS Business Administration': 210,
    'BS Nursing': 165,
    'BS Education': 120,
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
