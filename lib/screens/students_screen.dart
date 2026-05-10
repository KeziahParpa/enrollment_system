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
  String? _filterProgram;
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _students = List.from(MockData.students);
  }

  List<Student> get _filtered {
    return _students.where((s) {
      final matchSearch =
          _search.isEmpty ||
          s.fullName.toLowerCase().contains(_search.toLowerCase()) ||
          s.studentId.contains(_search) || // Uses the visible studentId now
          s.email.toLowerCase().contains(_search.toLowerCase());
      final matchProgram =
          _filterProgram == null || s.program == _filterProgram;
      return matchSearch && matchProgram; // Removed status filter
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Students',
            subtitle: '${_students.length} total students enrolled',
            actions: [
              ElevatedButton.icon(
                onPressed: () => _showAddStudentDialog(context),
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
    final programs = MockData.students.map((s) => s.program).toSet().toList();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search students by name, ID, or email…',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 18,
                color: AppTheme.textSecondary,
              ),
              filled: true,
              fillColor: AppTheme.bgCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.primaryLight,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _buildDropdown<String?>(
          value: _filterProgram,
          hint: 'All Programs',
          items: [null, ...programs],
          label: (v) => v == null ? 'All Programs' : v.replaceFirst('BS ', ''),
          onChanged: (v) => setState(() => _filterProgram = v),
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
          hint: Text(
            hint,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    label(item),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
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
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No students found',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppTheme.border),
                    itemBuilder: (ctx, i) => _buildStudentRow(ctx, filtered[i]),
                  ),
          ),
          _buildTableFooter(filtered.length),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.bgMain,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            flex: 3,
            child: Text(
              'STUDENT',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'PROGRAM',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'YEAR',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'GPA', // Replaced Status with GPA
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildStudentRow(BuildContext context, Student student) {
    return InkWell(
      onTap: () => _showStudentDetail(context, student),
      hoverColor: AppTheme.bgMain,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            AvatarWidget(
              initials: student.initials,
              colorIndex: student.studentId.hashCode % 6, // Dynamically generate color based on ID
              size: 38,
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${student.studentId} · ${student.email}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                student.program.replaceFirst('BS ', ''),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                student.yearLevel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                student.gpa > 0 ? student.gpa.toStringAsFixed(2) : 'N/A',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () => _showEditStudentDialog(context, student),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AppTheme.danger,
                    ),
                    onPressed: () => _showDeleteConfirm(context, student),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableFooter(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          Text(
            'Showing $count of ${_students.length} students',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showStudentDetail(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarWidget(
                    initials: student.initials,
                    colorIndex: student.studentId.hashCode % 6,
                    size: 56,
                    fontSize: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          student.studentId,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 16),
              _detailRow(Icons.email_rounded, 'Email', student.email),
              _detailRow(Icons.phone_rounded, 'Phone', student.phone),
              _detailRow(Icons.school_rounded, 'Program', student.program),
              _detailRow(Icons.layers_rounded, 'Year Level', student.yearLevel),
              _detailRow(Icons.grade_rounded, 'GPA', student.gpa > 0 ? student.gpa.toStringAsFixed(2) : 'No Data Yet'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Close',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showEditStudentDialog(context, student);
                    },
                    child: const Text('Edit Student'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.bgMain,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    _showStudentForm(context, null);
  }

  void _showEditStudentDialog(BuildContext context, Student student) {
    _showStudentForm(context, student);
  }

  void _showStudentForm(BuildContext context, Student? existing) {
    final firstCtrl = TextEditingController(text: existing?.firstName ?? '');
    final lastCtrl = TextEditingController(text: existing?.lastName ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final gpaCtrl = TextEditingController(text: existing?.gpa.toString() ?? '0.0'); // Added GPA field
    String selectedProgram =
        existing?.program ?? MockData.students.first.program;
    String selectedYear = existing?.yearLevel ?? '1st Year';

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existing == null ? 'Add New Student' : 'Edit Student',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
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
                    Expanded(flex: 2, child: _formField('Email Address', emailCtrl)),
                    const SizedBox(width: 12),
                    Expanded(flex: 1, child: _formField('Current GPA', gpaCtrl, isNumber: true)),
                  ],
                ),
                const SizedBox(height: 12),
                _formField('Phone Number', phoneCtrl),
                const SizedBox(height: 12),
                _formDropdown<String>(
                  label: 'Program',
                  value: selectedProgram,
                  items: MockData.students
                      .map((s) => s.program)
                      .toSet()
                      .toList(),
                  onChanged: (v) => setDialogState(() => selectedProgram = v!),
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
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Creating a fresh Student object to save
                        final newStudent = Student(
                          id: existing?.id ?? 'uid_${DateTime.now().millisecondsSinceEpoch}',
                          studentId: existing?.studentId ?? '2024-${(_students.length + 1).toString().padLeft(4, '0')}',
                          firstName: firstCtrl.text,
                          lastName: lastCtrl.text,
                          email: emailCtrl.text,
                          phone: phoneCtrl.text,
                          program: selectedProgram,
                          yearLevel: selectedYear,
                          gpa: double.tryParse(gpaCtrl.text) ?? 0.0,
                        );

                        setState(() {
                          if (existing == null) {
                            _students.add(newStudent);
                          } else {
                            final idx = _students.indexWhere((s) => s.id == existing.id);
                            if (idx >= 0) {
                              _students[idx] = newStudent;
                            }
                          }
                        });
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
    );
  }

  Widget _formField(String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.bgMain,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryLight,
                width: 2,
              ),
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
    String Function(T)? itemLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgMain,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        itemLabel != null ? itemLabel(item) : item.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirm(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Student',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to remove ${student.fullName} from the system? This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _students.removeWhere((s) => s.id == student.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}