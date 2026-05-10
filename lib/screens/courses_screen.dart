import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/course.dart';
import '../widgets/page_header.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _search = '';
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _courses = List.from(MockData.courses);
  }

  List<Course> get _filtered => _courses.where((c) {
    return _search.isEmpty ||
        c.title.toLowerCase().contains(_search.toLowerCase()) ||
        c.code.toLowerCase().contains(_search.toLowerCase());
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          PageHeader(
            title: 'Course Management',
            subtitle: '${_courses.length} CCI courses active',
            actions: [
              ElevatedButton.icon(
                onPressed: () => _showCourseForm(null),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add New Course'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: const InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildCourseGrid()),
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
                  color: AppTheme.primaryLight,
                ),
              ),
              const Spacer(),
              const Icon(Icons.edit_outlined, size: 18),
            ],
          ),
          Text(
            course.title,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Capacity Monitoring Visual Indicator
          LinearProgressIndicator(
            value: course.fillRate,
            backgroundColor: AppTheme.border,
            color: course.isFull ? AppTheme.danger : AppTheme.primaryLight,
          ),
          const SizedBox(height: 4),
          Text(
            '${course.currentCapacity}/${course.maxCapacity} Students',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: course.isFull ? AppTheme.danger : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseForm(Course? existing) {
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final capCtrl = TextEditingController(
      text: existing?.maxCapacity.toString() ?? '40',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Create Course' : 'Edit Course'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _formField('Course Code', codeCtrl),
            _formField('Course Title', titleCtrl),
            _formField('Max Capacity', capCtrl),
            const SizedBox(height: 12),
            // Locked Department to CCI
            _formDropdown('Department', 'CCI', ['CCI'], (v) {}),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final c = Course(
                id:
                    existing?.id ??
                    'c_${DateTime.now().millisecondsSinceEpoch}',
                code: codeCtrl.text,
                title: titleCtrl.text,
                instructorId: 'prof_1',
                schedule: 'TBA',
                room: 'TBA',
                units: 3,
                currentCapacity: 0,
                maxCapacity: int.tryParse(capCtrl.text) ?? 40,
                departmentId: 'CCI',
              );
              setState(() {
                if (existing == null)
                  _courses.add(c);
                else {
                  final i = _courses.indexWhere((x) => x.id == existing.id);
                  _courses[i] = c;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Course'),
          ),
        ],
      ),
    );
  }

  Widget _formField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppTheme.bgMain,
          // FIX: Changed BorderSide.none to InputBorder.none
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.primaryLight,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _formDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((i) => DropdownMenuItem(value: i, child: Text(i)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppTheme.bgMain,
          // FIX: Ensure consistency here as well
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
