import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/mock_data.dart';
import '../models/course.dart';
import '../widgets/page_header.dart';
import '../theme/app_theme.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _searchQuery = '';
  String? _filterProgram;

  void _showDeleteConfirmation(Course c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Course?'),
        content: Text('Are you sure you want to delete ${c.code}? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              setState(() {
                MockData.courses.removeWhere((course) => course.id == c.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Course deleted successfully.'), backgroundColor: AppTheme.success),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredCourses = MockData.courses.where((c) {
      final matchesSearch = c.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            c.code.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesProgram = true;
      if (_filterProgram == 'Computer Science') matchesProgram = c.code.startsWith('CS') || c.code.startsWith('ICT') || c.code.startsWith('ANIM');
      if (_filterProgram == 'Information Technology') matchesProgram = c.code.startsWith('IT');
      if (_filterProgram == 'Information Systems') matchesProgram = c.code.startsWith('IS');

      return matchesSearch && matchesProgram;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: 'Course Management',
            subtitle: 'Manage curriculum, schedules, and capacity',
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Course form coming soon!')),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add New Course'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // SEARCH & FILTER BAR
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search course code or title...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), 
                      borderSide: const BorderSide(color: AppTheme.border)
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    border: Border.all(color: AppTheme.border), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      isExpanded: true,
                      value: _filterProgram,
                      hint: const Text('All Programs', style: TextStyle(fontSize: 14)),
                      items: [null, 'Computer Science', 'Information Technology', 'Information Systems']
                          .map((p) => DropdownMenuItem(value: p, child: Text(p ?? 'All Programs', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))))
                          .toList(),
                      onChanged: (v) => setState(() => _filterProgram = v),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // HORIZONTAL LIST OF COURSES (Matching the Student UI)
          Expanded(
            child: filteredCourses.isEmpty
              ? const Center(child: Text("No courses found.", style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)))
              : ListView.builder(
                  itemCount: filteredCourses.length,
                  itemBuilder: (ctx, i) => _courseRow(filteredCourses[i]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _courseRow(Course c) {
    bool isFull = !c.hasSpace;
    bool hasPrereqs = c.prerequisites.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // 1. Course Code Block
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Text(
                c.code, 
                style: const TextStyle(color: AppTheme.primaryLight, fontWeight: FontWeight.w900, fontSize: 13)
              )
            ),
          ),
          const SizedBox(width: 24),
          
          // 2. Title & Details
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text('${c.schedule}  •  Room: ${c.room}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
                if (hasPrereqs) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.account_tree_rounded, size: 12, color: AppTheme.warning),
                      const SizedBox(width: 6),
                      Text("Requires: ${c.prerequisites.join(', ')}", style: const TextStyle(fontSize: 11, color: AppTheme.warning, fontWeight: FontWeight.w800)),
                    ],
                  )
                ],
              ],
            ),
          ),
          
          // 3. Stats (Units & Capacity)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${c.units} Units", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  "${c.currentCapacity}/${c.maxCapacity} Enrolled", 
                  style: TextStyle(
                    fontSize: 12, 
                    color: isFull ? AppTheme.danger : AppTheme.success, 
                    fontWeight: FontWeight.w700
                  )
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          
          // 4. Admin Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: AppTheme.primaryLight, size: 24),
                tooltip: 'Edit Course',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Editing ${c.code}... (Form coming soon)')),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: AppTheme.danger, size: 24),
                tooltip: 'Delete Course',
                onPressed: () => _showDeleteConfirmation(c),
              ),
            ],
          ),
        ],
      ),
    );
  }
}