import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../widgets/page_header.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _search = '';
  String? _filterProgram;
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _courses = List.from(MockData.courses); // Initialize local state
  }

  List<Course> get _filtered => _courses.where((c) {
    final matchSearch =
        _search.isEmpty ||
        c.title.toLowerCase().contains(_search.toLowerCase()) ||
        c.code.toLowerCase().contains(_search.toLowerCase());
    final matchProgram = _filterProgram == null || c.program == _filterProgram;
    return matchSearch && matchProgram;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Course Management',
            subtitle: '${_courses.length} courses in the database',
            actions: [
              ElevatedButton.icon(
                onPressed: () => _showCourseForm(null),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add New Course'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(child: _buildCourseGrid()),
        ],
      ),
    );
  }

  void _showCourseForm(Course? existing) {
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final instructorCtrl = TextEditingController(
      text: existing?.instructor ?? '',
    );
    final capCtrl = TextEditingController(
      text: existing?.capacity.toString() ?? '40',
    );
    String selectedProgram = existing?.program ?? 'BS Computer Science';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(existing == null ? 'Create Course' : 'Edit Course'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formField('Course Code', codeCtrl),
                const SizedBox(height: 12),
                _formField('Course Title', titleCtrl),
                const SizedBox(height: 12),
                _formField('Instructor Name', instructorCtrl),
                const SizedBox(height: 12),
                _formField('Max Capacity', capCtrl, isNumber: true),
                const SizedBox(height: 12),
                _formDropdown(
                  'Program',
                  selectedProgram,
                  [
                    'BS Computer Science',
                    'BS Information Technology',
                    'BS Nursing',
                  ],
                  (v) => setDialogState(() => selectedProgram = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newCourse = Course(
                  code: codeCtrl.text,
                  title: titleCtrl.text,
                  instructor: instructorCtrl.text,
                  schedule: existing?.schedule ?? 'TBA',
                  room: existing?.room ?? 'TBA',
                  units: existing?.units ?? 3,
                  enrolled: existing?.enrolled ?? 0,
                  capacity: int.tryParse(capCtrl.text) ?? 40,
                  program: selectedProgram,
                );

                setState(() {
                  if (existing == null) {
                    _courses.add(newCourse);
                  } else {
                    final index = _courses.indexWhere(
                      (c) => c.code == existing.code,
                    );
                    if (index != -1) _courses[index] = newCourse;
                  }
                });
                Navigator.pop(ctx);
              },
              child: const Text('Save Course'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(Course course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Course'),
        content: Text('Are you sure you want to delete ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              setState(
                () => _courses.removeWhere((c) => c.code == course.code),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseGrid() {
    final filtered = _filtered;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.4,
      ),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) => _buildCourseCard(filtered[i]),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                course.code,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showCourseForm(course),
                icon: const Icon(Icons.edit_outlined, size: 18),
              ),
              IconButton(
                onPressed: () => _showDeleteConfirm(course),
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppTheme.danger,
                ),
              ),
            ],
          ),
          Text(
            course.title,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Instructor: ${course.instructor}',
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: course.fillRate,
            backgroundColor: AppTheme.border,
            color: AppTheme.primaryLight,
          ),
          const SizedBox(height: 4),
          Text(
            '${course.enrolled}/${course.capacity} Students',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _formField(
    String label,
    TextEditingController ctrl, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppTheme.bgMain,
      ),
    );
  }

  Widget _formDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((i) => DropdownMenuItem(value: i, child: Text(i)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildFilters() {
    final programs = MockData.courses.map((c) => c.program).toSet().toList();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search courses by code or title...',
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String?>(
          value: _filterProgram,
          hint: const Text('All Programs'),
          items: [null, ...programs]
              .map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(p ?? 'All Programs'),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _filterProgram = v),
        ),
      ],
    );
  }
}
