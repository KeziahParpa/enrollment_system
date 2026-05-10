import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/course.dart'; // Updated import
import '../widgets/page_header.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _search = '';
  String? _filterDepartment; // Changed from Program to Department
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _courses = List.from(MockData.courses);
  }

  List<Course> get _filtered => _courses.where((c) {
    final matchSearch =
        _search.isEmpty ||
        c.title.toLowerCase().contains(_search.toLowerCase()) ||
        c.code.toLowerCase().contains(_search.toLowerCase());
    // Match against the new departmentId field
    final matchDept = _filterDepartment == null || c.departmentId == _filterDepartment;
    return matchSearch && matchDept;
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
      text: existing?.instructorId ?? '', // Changed to instructorId
    );
    final capCtrl = TextEditingController(
      text: existing?.maxCapacity.toString() ?? '40', // Changed to maxCapacity
    );
    String selectedDept = existing?.departmentId ?? 'CCS'; // Changed to departmentId

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
                _formField('Instructor ID', instructorCtrl),
                const SizedBox(height: 12),
                _formField('Max Capacity', capCtrl, isNumber: true),
                const SizedBox(height: 12),
                _formDropdown(
                  'Department',
                  selectedDept,
                  ['CCS', 'CBA', 'CON', 'CEAS'], // Department codes
                  (v) => setDialogState(() => selectedDept = v!),
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
                // Creating the new course using the updated model parameters
                final newCourse = Course(
                  id: existing?.id ?? 'c_${DateTime.now().millisecondsSinceEpoch}', // Dummy ID generator
                  code: codeCtrl.text,
                  title: titleCtrl.text,
                  instructorId: instructorCtrl.text,
                  schedule: existing?.schedule ?? 'TBA',
                  room: existing?.room ?? 'TBA',
                  units: existing?.units ?? 3,
                  currentCapacity: existing?.currentCapacity ?? 0,
                  maxCapacity: int.tryParse(capCtrl.text) ?? 40,
                  departmentId: selectedDept,
                  prerequisites: existing?.prerequisites ?? [],
                );

                setState(() {
                  if (existing == null) {
                    _courses.add(newCourse);
                  } else {
                    final index = _courses.indexWhere((c) => c.id == existing.id);
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
                () => _courses.removeWhere((c) => c.id == course.id), // Delete by ID
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
            'Instructor ID: ${course.instructorId}', // Using instructorId
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
            '${course.currentCapacity}/${course.maxCapacity} Students', // Updated capacities
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
    final departments = MockData.courses.map((c) => c.departmentId).toSet().toList();
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
          value: _filterDepartment,
          hint: const Text('All Departments'),
          items: [null, ...departments]
              .map(
                (d) => DropdownMenuItem(
                  value: d,
                  child: Text(d ?? 'All Departments'),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _filterDepartment = v),
        ),
      ],
    );
  }
}