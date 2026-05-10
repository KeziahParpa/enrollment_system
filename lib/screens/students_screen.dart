import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/page_header.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _search = '';
  String? _filterYear;
  List<Student> _students = List.from(MockData.students);

  final Map<String, List<String>> _sectionsMap = {
    'Computer Science': ['CS-A', 'CS-B'],
    'Information Technology': ['IT-A', 'IT-B', 'IT-C', 'IT-D'],
    'Information Systems': ['IS-A', 'IS-B'],
  };

  @override
  Widget build(BuildContext context) {
    final filtered = _students.where((s) {
      final matchSearch =
          s.fullName.toLowerCase().contains(_search.toLowerCase()) ||
          s.studentId.contains(_search);
      final matchYear = _filterYear == null || s.yearLevel == _filterYear;
      return matchSearch && matchYear;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          PageHeader(
            title: 'Students',
            subtitle: '${_students.length} students in database',
            actions: [
              ElevatedButton.icon(
                onPressed: () => _showStudentForm(context, null),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Student'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(child: _buildStudentTable(filtered)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: const InputDecoration(
              hintText: 'Search by name or ID...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _buildDropdown<String?>(
          value: _filterYear,
          hint: 'Year Levels',
          items: [null, '1st Year', '2nd Year', '3rd Year', '4th Year'],
          label: (v) => v ?? 'All Year Levels',
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
    String selectedProgram = 'Computer Science';
    String selectedSection = _sectionsMap[selectedProgram]!.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existing == null ? 'Add New Student' : 'Edit Student',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _formField('First Name', firstCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _formField('Last Name', lastCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _formField('Email Address', emailCtrl)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _formField(
                          'Password',
                          passCtrl,
                          isPassword: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Cascading Program and Section Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: _formDropdown<String>(
                          label: 'Program',
                          value: selectedProgram,
                          items: _sectionsMap.keys.toList(),
                          onChanged: (v) {
                            setDialogState(() {
                              selectedProgram = v!;
                              // Automatically update section list based on program choice
                              selectedSection =
                                  _sectionsMap[selectedProgram]!.first;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _formDropdown<String>(
                          label: 'Section',
                          value: selectedSection,
                          items: _sectionsMap[selectedProgram]!,
                          onChanged: (v) =>
                              setDialogState(() => selectedSection = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _formDropdown<String>(
                    label: 'Year Level',
                    value: selectedYear,
                    items: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
                    onChanged: (v) => setDialogState(() => selectedYear = v!),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final newStudent = Student(
                            id: 'uid_${DateTime.now().millisecondsSinceEpoch}',
                            studentId: '2024-${_students.length + 1}',
                            firstName: firstCtrl.text,
                            lastName: lastCtrl.text,
                            email: emailCtrl.text,
                            phone: '',
                            program: '$selectedProgram ($selectedSection)',
                            yearLevel: selectedYear,
                          );
                          setState(() => _students.add(newStudent));
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          existing == null ? 'Add Student' : 'Save Changes',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _formField(
    String label,
    TextEditingController ctrl, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgMain,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _formDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgMain,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items
                  .map(
                    (i) => DropdownMenuItem<T>(
                      value: i,
                      child: Text(i.toString()),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required String hint,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint),
          items: items
              .map((i) => DropdownMenuItem<T>(value: i, child: Text(label(i))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStudentTable(List<Student> list) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) => ListTile(
          leading: AvatarWidget(initials: list[i].initials, colorIndex: i),
          title: Text(
            list[i].fullName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('${list[i].studentId} • ${list[i].program}'),
          trailing: Text(
            list[i].yearLevel,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }
}
