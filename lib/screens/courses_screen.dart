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
    _courses = List.from(MockData.courses);
  }

  List<Course> get _filtered => _courses.where((c) {
        final matchSearch = _search.isEmpty ||
            c.title.toLowerCase().contains(_search.toLowerCase()) ||
            c.code.toLowerCase().contains(_search.toLowerCase()) ||
            c.instructor.toLowerCase().contains(_search.toLowerCase());
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
            title: 'Courses',
            subtitle: '${_courses.length} courses offered this semester',
            actions: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Course'),
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

  Widget _buildFilters() {
    final programs = _courses.map((c) => c.program).toSet().toList();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search courses by title, code, or instructor…',
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary),
              prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppTheme.textSecondary),
              filled: true,
              fillColor: AppTheme.bgCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primaryLight, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: _filterProgram,
              hint: Text('All Programs', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary)),
              items: [null, ...programs].map((p) => DropdownMenuItem<String?>(
                    value: p,
                    child: Text(p == null ? 'All Programs' : p.replaceFirst('BS ', ''),
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textPrimary)),
                  )).toList(),
              onChanged: (v) => setState(() => _filterProgram = v),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseGrid() {
    final filtered = _filtered;
    if (filtered.isEmpty) {
      return const Center(child: Text('No courses found'));
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.5,
      ),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) => _buildCourseCard(ctx, filtered[i]),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    final fillPct = (course.fillRate * 100).toInt();
    final fillColor = course.isFull
        ? AppTheme.danger
        : fillPct > 80
            ? AppTheme.warning
            : AppTheme.success;

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  course.code,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${course.units} units',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            course.title,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person_rounded, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  course.instructor,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  course.schedule,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.room_rounded, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                course.room,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${course.enrolled}/${course.capacity} enrolled',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                        ),
                        Text(
                          '$fillPct%',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: fillColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: course.fillRate,
                        minHeight: 6,
                        backgroundColor: AppTheme.border,
                        valueColor: AlwaysStoppedAnimation<Color>(fillColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (course.isFull) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('FULL', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.danger, letterSpacing: 0.5)),
            ),
          ],
        ],
      ),
    );
  }
}
