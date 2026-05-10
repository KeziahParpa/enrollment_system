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
  String? _filterYear; // Changed from Program to Year Level
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _students = List.from(MockData.students);
  }

  List<Student> get _filtered => _students.where((s) {
    final matchSearch =
        _search.isEmpty ||
        s.fullName.toLowerCase().contains(_search.toLowerCase()) ||
        s.studentId.contains(_search);
    final matchYear = _filterYear == null || s.yearLevel == _filterYear;
    return matchSearch && matchYear;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          PageHeader(
            title: 'Students',
            subtitle: '${_students.length} CS students enrolled',
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
          Expanded(child: _buildStudentTable()),
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
            decoration: const InputDecoration(
              hintText: 'Search by name or ID...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Dropdown changed to Year Levels
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
    String selectedYear = existing?.yearLevel ?? '1st Year';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Student' : 'Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _formField('First Name', firstCtrl),
              const SizedBox(height: 12),
              _formField('Last Name', lastCtrl),
              const SizedBox(height: 12),
              // Fixed program choice
              _formDropdown(
                label: 'Program',
                value: 'BS Computer Science',
                items: ['BS Computer Science'],
                onChanged: (v) {},
              ),
              const SizedBox(height: 12),
              _formDropdown(
                label: 'Year Level',
                value: selectedYear,
                items: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
                onChanged: (v) => setDialogState(() => selectedYear = v!),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final s = Student(
                  id:
                      existing?.id ??
                      'uid_${DateTime.now().millisecondsSinceEpoch}',
                  studentId: existing?.studentId ?? '2024-0000',
                  firstName: firstCtrl.text,
                  lastName: lastCtrl.text,
                  email:
                      '${firstCtrl.text.toLowerCase()}.${lastCtrl.text.toLowerCase()}@students.isatu.edu.ph',
                  phone: '',
                  program: 'BS Computer Science',
                  yearLevel: selectedYear,
                );
                setState(() {
                  if (existing == null)
                    _students.add(s);
                  else {
                    final i = _students.indexWhere((x) => x.id == existing.id);
                    _students[i] = s;
                  }
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save Student'),
            ),
          ],
        ),
      ),
    );
  }

  // ... _buildDropdown, _buildStudentTable, _formField remain consistent with original students_screen.dart ...
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
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(label(i))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _formDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgMain,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _formField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgMain,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTable() {
    final filtered = _filtered;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListView.separated(
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) => ListTile(
          leading: AvatarWidget(initials: filtered[i].initials, colorIndex: i),
          title: Text(filtered[i].fullName),
          subtitle: Text(filtered[i].yearLevel),
        ),
      ),
    );
  }
}
