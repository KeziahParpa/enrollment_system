import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../models/student.dart';
import '../widgets/page_header.dart';

class ActionQueuesScreen extends StatefulWidget {
  const ActionQueuesScreen({super.key});

  @override
  State<ActionQueuesScreen> createState() => _ActionQueuesScreenState();
}

class _ActionQueuesScreenState extends State<ActionQueuesScreen> {
  // Logic: Connect to State
  // We filter the MockData directly to simulate real-time updates
  List<Student> get _pendingEnrollments => MockData.students
      .where((s) => s.status == EnrollmentStatus.pending)
      .toList();

  List<Student> get _pendingDrops => MockData.students
      .where((s) => s.status == EnrollmentStatus.dropped)
      .toList();

  void _handleApproval(Student student) {
    setState(() {
      // Find the index in the original MockData list
      final index = MockData.students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        // Update the status to 'enrolled'
        MockData.students[index] = MockData.students[index].copyWith(
          status: EnrollmentStatus.enrolled,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Approved enrollment for ${student.fullName}')),
    );
  }

  void _handleRejection(Student student) {
    setState(() {
      MockData.students.removeWhere((s) => s.id == student.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rejected request for ${student.fullName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const PageHeader(
            title: 'Action Queues',
            subtitle: 'Review and approve enrollment or drop requests',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildQueueCard(
                    'Pending Enrollments',
                    _pendingEnrollments,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQueueCard('Drop Requests', _pendingDrops),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard(String title, List<Student> list) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Divider(height: 32),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('All caught up!'))
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _buildRequestItem(list[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem(Student student) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgMain,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${student.id} • ${student.program}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons: Connect to State
          IconButton(
            icon: const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
            ),
            onPressed: () => _handleApproval(student),
            tooltip: 'Approve',
          ),
          IconButton(
            icon: const Icon(Icons.cancel_rounded, color: AppTheme.danger),
            onPressed: () => _handleRejection(student),
            tooltip: 'Reject',
          ),
        ],
      ),
    );
  }
}
