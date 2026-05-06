import 'package:flutter/material.dart';

enum EnrollmentStatus { enrolled, pending, dropped, graduated }

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String program;
  final String yearLevel;
  final String section;
  final EnrollmentStatus status;
  final DateTime enrolledDate;
  final int avatarColorIndex;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.program,
    required this.yearLevel,
    required this.section,
    required this.status,
    required this.enrolledDate,
    this.avatarColorIndex = 0,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  Student copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? program,
    String? yearLevel,
    String? section,
    EnrollmentStatus? status,
  }) {
    return Student(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      program: program ?? this.program,
      yearLevel: yearLevel ?? this.yearLevel,
      section: section ?? this.section,
      status: status ?? this.status,
      enrolledDate: enrolledDate,
      avatarColorIndex: avatarColorIndex,
    );
  }
}

class Course {
  final String code;
  final String title;
  final String instructor;
  final String schedule;
  final String room;
  final int units;
  final int enrolled;
  final int capacity;
  final String program;

  Course({
    required this.code,
    required this.title,
    required this.instructor,
    required this.schedule,
    required this.room,
    required this.units,
    required this.enrolled,
    required this.capacity,
    required this.program,
  });

  double get fillRate => enrolled / capacity;
  bool get isFull => enrolled >= capacity;
}

class Department {
  final String code;
  final String name;
  final String dean;
  final int totalStudents;
  final int totalCourses;
  final Color color;

  Department({
    required this.code,
    required this.name,
    required this.dean,
    required this.totalStudents,
    required this.totalCourses,
    required this.color,
  });
}
