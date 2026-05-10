import 'package:flutter/material.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../widgets/page_header.dart';
import '../theme/app_theme.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _search = '';
  String? _filterProgram;
  String? _filterYear;
  String? _filterSection;

  // Global Section Map logic linking Programs to their available Sections
  final Map<String, List<String>> _sectionMapping = {
    'BS Computer Science': ['CS-A', 'CS-B'],
    'BS Information Technology': ['IT-A', 'IT-B', 'IT-C', 'IT-D'],
    'BS Information Systems': ['IS-A'],
  };

  @override
  Widget build(BuildContext context) {
    // Applying active filters to the list
    final filtered = MockData.students.where((s) {
      final matchSearch = s.fullName.toLowerCase().contains(_search.toLowerCase());
      final matchProgram = _filterProgram == null || s.program == _filterProgram;
      final matchYear = _filterYear == null || s.yearLevel == _filterYear;
      return matchSearch && matchProgram && matchYear;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          PageHeader(
            title: 'Students',
            subtitle: 'CCI Enrollment Records',
            actions: [
              ElevatedButton.icon(
                onPressed: () => _showStudentForm(context, null),
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
          flex: 2,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search by name...',
              prefixIcon: const Icon(Icons.search, size: 18),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: _dropdownFilter(
            'All Programs',
            _filterProgram,
            _sectionMapping.keys.toList(),
            (v) {
              setState(() {
                _filterProgram = v;
                _filterSection = null; // Reset section filter if program changes
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _dropdownFilter(
            'All Years',
            _filterYear,
            ['1st Year', '2nd Year', '3rd Year', '4th Year'],
            (v) => setState(() => _filterYear = v),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _dropdownFilter(
            'All Sections',
            _filterSection,
            // Only show relevant sections if a program is selected, otherwise show all
            _filterProgram != null 
              ? _sectionMapping[_filterProgram]! 
              : _sectionMapping.values.expand((x) => x).toList(),
            (v) => setState(() => _filterSection = v),
          ),
        ),
      ],
    );
  }

  Widget _dropdownFilter(String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: value,
          hint: Text(hint, style: const TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis)),
          items: [null, ...items].map((i) => DropdownMenuItem(value: i, child: Text(i ?? hint, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showStudentForm(BuildContext context, Student? existing) {
    final firstCtrl = TextEditingController(text: existing?.firstName ?? '');
    final lastCtrl = TextEditingController(text: existing?.lastName ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final passCtrl = TextEditingController();
    
    // Initial Form State
    String selectedProgram = existing?.program ?? 'BS Computer Science';
    String selectedYear = existing?.yearLevel ?? '1st Year';
    String selectedSection = _sectionMapping[selectedProgram]!.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add New Student' : 'Edit Student', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            controller: passCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password', filled: true, border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // DYNAMIC PROGRAM DROPDOWN
                  _formDropdown(
                    'Program',
                    selectedProgram,
                    _sectionMapping.keys.toList(),
                    (v) {
                      setDialogState(() {
                        selectedProgram = v!;
                        selectedSection = _sectionMapping[selectedProgram]!.first; // Instantly switches to the correct section list
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _formDropdown(
                          'Year Level',
                          selectedYear,
                          ['1st Year', '2nd Year', '3rd Year', '4th Year'],
                          (v) => setDialogState(() => selectedYear = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // DYNAMIC SECTION DROPDOWN
                      Expanded(
                        child: _formDropdown(
                          'Section',
                          selectedSection,
                          _sectionMapping[selectedProgram]!, // Grabs the correct list based on the program
                          (v) => setDialogState(() => selectedSection = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final newEmail = emailCtrl.text.trim().toLowerCase();
                final newPassword = passCtrl.text;

                final s = Student(
                  id: 'uid_${DateTime.now().millisecondsSinceEpoch}',
                  studentId: '2024-${MockData.students.length + 1}',
                  firstName: firstCtrl.text.trim(),
                  lastName: lastCtrl.text.trim(),
                  email: newEmail,
                  phone: '00000000000',
                  program: selectedProgram,
                  yearLevel: selectedYear,
                  gpa: 0.0,
                );

                setState(() {
                  MockData.students.add(s);
                  if (newPassword.isNotEmpty) {
                    MockData.userCredentials[newEmail] = newPassword;
                  } else {
                    MockData.userCredentials[newEmail] = 'password123'; // Default fallback
                  }
                });

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${s.firstName} added to $selectedSection!'), backgroundColor: AppTheme.success),
                );
              },
              child: const Text('Register Student'),
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
      decoration: InputDecoration(labelText: label, filled: true, border: InputBorder.none),
    ),
  );

  Widget _formDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(color: AppTheme.bgMain, borderRadius: BorderRadius.circular(8)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );

  Widget _buildStudentList(List<Student> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No students found.', style: TextStyle(color: AppTheme.textSecondary)));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (ctx, i) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(side: const BorderSide(color: AppTheme.border), borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(backgroundColor: AppTheme.primaryLight, child: Text(list[i].initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          title: Text(list[i].fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Text('${list[i].program} • ${list[i].yearLevel} • ${list[i].email}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}