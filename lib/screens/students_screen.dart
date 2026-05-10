// lib/screens/students_screen.dart
import 'package:flutter/material.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../widgets/page_header.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _search = '';
  String? _filterYear;

  @override
  Widget build(BuildContext context) {
    // FIX 1: We filter directly from MockData.students instead of a local copy!
    // This ensures your list is always looking at the global, updated database.
    final filtered = MockData.students.where((s) {
      final matchSearch = s.fullName.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchYear = _filterYear == null || s.yearLevel == _filterYear;
      return matchSearch && matchYear;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          PageHeader(
            title: 'Students',
            subtitle: 'Computer Science Department',
            actions: [
              ElevatedButton.icon(
                onPressed: () =>
                    _showStudentForm(context, null), 
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Student'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(child: _buildStudentList(filtered)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: const InputDecoration(hintText: 'Search students...'),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String?>(
          value: _filterYear,
          hint: const Text('Year Levels'),
          items: [null, '1st Year', '2nd Year', '3rd Year', '4th Year']
              .map(
                (y) =>
                    DropdownMenuItem(value: y, child: Text(y ?? 'All Years')),
              )
              .toList(),
          onChanged: (v) => setState(() => _filterYear = v),
        ),
      ],
    );
  }

  void _showStudentForm(BuildContext context, Student? existing) {
    final firstCtrl = TextEditingController(text: existing?.firstName ?? '');
    final lastCtrl = TextEditingController(text: existing?.lastName ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final passCtrl = TextEditingController();
    String selectedYear = existing?.yearLevel ?? '1st Year';
    String selectedSection = 'CS-A';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add New Student' : 'Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formField('First Name', firstCtrl),
                _formField('Last Name', lastCtrl),
                Row(
                  children: [
                    Expanded(child: _formField('Email', emailCtrl)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _formDropdown(
                        'Section',
                        selectedSection,
                        ['CS-A', 'CS-B'],
                        (v) => setDialogState(() => selectedSection = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _formDropdown(
                        'Year Level',
                        selectedYear,
                        ['1st Year', '2nd Year', '3rd Year', '4th Year'],
                        (v) => setDialogState(() => selectedYear = v!),
                      ),
                    ),
                  ],
                ),
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'BS Computer Science',
                    hintText: 'BS Computer Science',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Prepare the email and password strings
                final newEmail = emailCtrl.text.trim().toLowerCase();
                final newPassword = passCtrl.text;

                final s = Student(
                  id: 'uid_${DateTime.now().millisecondsSinceEpoch}',
                  studentId: '2024-${MockData.students.length + 1}', // Auto-generates the next ID
                  firstName: firstCtrl.text.trim(),
                  lastName: lastCtrl.text.trim(),
                  email: newEmail,
                  phone: '00000000000', // Default empty phone to avoid null errors
                  program: 'BS Computer Science',
                  yearLevel: selectedYear,
                  gpa: 0.0, // Brand new student starts with 0.0 GPA
                );

                setState(() {
                  // FIX 2: Save the student to the GLOBAL MockData list
                  MockData.students.add(s);
                  
                  // FIX 3: Save the email and password to the Auth Database!
                  if (newPassword.isNotEmpty) {
                    MockData.userCredentials[newEmail] = newPassword;
                  }
                });

                Navigator.pop(ctx);
                
                // Show a quick success message so the admin knows it worked
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${s.firstName} added! They can now log in.')),
                );
              },
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField(String label, TextEditingController ctrl) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: InputBorder.none,
      ),
    ),
  );

  Widget _formDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      DropdownButton<String>(
        value: value,
        items: items
            .map((i) => DropdownMenuItem(value: i, child: Text(i)))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );

  Widget _buildStudentList(List<Student> list) => ListView.builder(
    itemCount: list.length,
    itemBuilder: (ctx, i) => ListTile(
      title: Text(list[i].fullName),
      subtitle: Text('${list[i].yearLevel} • ${list[i].email}'), // Added email so you can see it easily
    ),
  );
}