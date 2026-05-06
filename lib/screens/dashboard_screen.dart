import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/avatar_widget.dart';
import '../models/student.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recentStudents = MockData.students.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildStatCards(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildEnrollmentChart()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildProgramDistribution()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildRecentStudents(recentStudents)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildPendingActions()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Welcome back, Admin · AY 2024–2025, 1st Semester',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.download_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                'Export Report',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: const [
        StatCard(
          title: 'Total Students',
          value: '1,405',
          subtitle: 'Across all programs',
          icon: Icons.school_rounded,
          iconColor: AppTheme.primaryLight,
          iconBg: Color(0xFFEFF6FF),
          trend: '+12%',
          trendUp: true,
        ),
        StatCard(
          title: 'Enrolled',
          value: '1,248',
          subtitle: 'Active this semester',
          icon: Icons.check_circle_rounded,
          iconColor: AppTheme.success,
          iconBg: Color(0xFFECFDF5),
          trend: '+8%',
          trendUp: true,
        ),
        StatCard(
          title: 'Pending',
          value: '89',
          subtitle: 'Awaiting approval',
          icon: Icons.pending_rounded,
          iconColor: AppTheme.warning,
          iconBg: Color(0xFFFFFBEB),
          trend: '-3%',
          trendUp: false,
        ),
        StatCard(
          title: 'Courses Offered',
          value: '78',
          subtitle: 'This semester',
          icon: Icons.menu_book_rounded,
          iconColor: Color(0xFF7C3AED),
          iconBg: Color(0xFFF5F3FF),
          trend: '+2',
          trendUp: true,
        ),
      ],
    );
  }

  Widget _buildEnrollmentChart() {
    final data = MockData.monthlyEnrollment;
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
          Text('Monthly Enrollment Trend',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('Academic Year 2024–2025',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 200,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppTheme.primary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${data[group.x.toInt()]['month']}\n${rod.toY.toInt()}',
                        GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              data[idx]['month'] as String,
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.textSecondary),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppTheme.border,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((e) {
                  final isHighlighted = e.value['count'] as int > 100;
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: (e.value['count'] as int).toDouble(),
                        color: isHighlighted ? AppTheme.primary : AppTheme.primaryLight.withOpacity(0.5),
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramDistribution() {
    final programs = MockData.enrollmentByProgram;
    final total = programs.values.fold(0, (a, b) => a + b);
    final colors = [
      AppTheme.primaryLight,
      const Color(0xFF7C3AED),
      const Color(0xFFDB2777),
      AppTheme.success,
      AppTheme.warning,
    ];

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
          Text('Enrollment by Program',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('Current semester breakdown',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sections: programs.entries.map((e) {
                  final idx = programs.keys.toList().indexOf(e.key);
                  final pct = e.value / total * 100;
                  return PieChartSectionData(
                    value: e.value.toDouble(),
                    color: colors[idx % colors.length],
                    radius: 55,
                    title: '${pct.toStringAsFixed(0)}%',
                    titleStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...programs.entries.map((e) {
            final idx = programs.keys.toList().indexOf(e.key);
            final pct = e.value / total * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors[idx % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e.key.replaceFirst('BS ', ''),
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentStudents(List<Student> students) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Enrollments',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              Text('View All',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryLight)),
            ],
          ),
          const SizedBox(height: 16),
          ...students.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    AvatarWidget(initials: s.initials, colorIndex: s.avatarColorIndex),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.fullName,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                          Text('${s.id} · ${s.program.replaceFirst('BS ', '')}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                    StatusBadge(status: s.status),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPendingActions() {
    final actions = [
      {'icon': Icons.person_add_rounded, 'color': AppTheme.primaryLight, 'bg': const Color(0xFFEFF6FF), 'title': 'New Enrollment Requests', 'count': '12 pending'},
      {'icon': Icons.edit_document, 'color': AppTheme.warning, 'bg': const Color(0xFFFFFBEB), 'title': 'Schedule Adjustments', 'count': '5 pending'},
      {'icon': Icons.receipt_long_rounded, 'color': const Color(0xFF7C3AED), 'bg': const Color(0xFFF5F3FF), 'title': 'Grade Submissions', 'count': '8 due today'},
      {'icon': Icons.cancel_rounded, 'color': AppTheme.danger, 'bg': const Color(0xFFFEF2F2), 'title': 'Drop Requests', 'count': '3 pending'},
    ];

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
          Text('Pending Actions',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('Requires your attention',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          ...actions.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: a['bg'] as Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                          Text(a['count'] as String,
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textSecondary),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
