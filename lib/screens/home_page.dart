import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';

/// One task.
class Task {
  final String title;
  final String description;
  final String timeToComplete;
  final String reminder;
  final DateTime due;
  final String priority;
  final List<String> tags;

  const Task({
    required this.title,
    required this.description,
    required this.timeToComplete,
    required this.reminder,
    required this.due,
    required this.priority,
    required this.tags,
  });
}

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, this.username = 'there'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  static const _cardColor = Color(0xFFE9DCC6);
  static const _tileColor = Color(0xFFFAF4EA);

  // The tasks shown on Home (sample tasks to start with)
  final List<Task> _tasks = [
    Task(
      title: 'Repot the monstera',
      description: '',
      timeToComplete: '30 min',
      reminder: '1 hour before',
      due: DateTime.now().add(const Duration(days: 1)),
      priority: 'High',
      tags: ['Home'],
    ),
    Task(
      title: 'Call mom for her birthday',
      description: '',
      timeToComplete: '30 min',
      reminder: '1 hour before',
      due: DateTime.now().add(const Duration(days: 1)),
      priority: 'Medium',
      tags: ['Personal'],
    ),
    Task(
      title: 'Finish client logo concepts',
      description: '',
      timeToComplete: '2 hours',
      reminder: '1 day before',
      due: DateTime.now().add(const Duration(days: 2)),
      priority: 'High',
      tags: ['Work'],
    ),
    Task(
      title: 'Submit quarterly tax docs',
      description: '',
      timeToComplete: '1 hour',
      reminder: '1 day before',
      due: DateTime.now().add(const Duration(days: 3)),
      priority: 'Medium',
      tags: ['Admin'],
    ),
  ];

  void _openNewTask() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('New task is coming soon')));
  }

  int _daysLeft(DateTime due) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(due.year, due.month, due.day).difference(today).inDays;
  }

  String _dueLabel(DateTime due) {
    final days = _daysLeft(due);
    if (days < 0) return 'Overdue';
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return 'In $days days';
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String get _today {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _tabIndex == 0
            ? _buildHome()
            : const Center(
                child: Text(
                  'Coming soon',
                  style: TextStyle(fontSize: 16, color: HabitlyColors.muted),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: HabitlyColors.background,
        selectedItemColor: HabitlyColors.terracotta,
        unselectedItemColor: HabitlyColors.muted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Widget'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    final almostDue = _tasks.where((t) => _daysLeft(t.due) <= 1).toList()
      ..sort((a, b) => a.due.compareTo(b.due));
    final highest = _tasks.where((t) => t.priority == 'High').toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // Greeting, date and + button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting, ${widget.username}',
                    style: GoogleFonts.fraunces(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: HabitlyColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _today,
                    style: const TextStyle(
                      fontSize: 13,
                      color: HabitlyColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: _openNewTask,
              icon: const Icon(Icons.add),
              tooltip: 'New task',
              style: IconButton.styleFrom(
                backgroundColor: HabitlyColors.terracotta,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Almost due
        if (almostDue.isNotEmpty) ...[
          _sectionTitle('Almost due'),
          _cardRow(almostDue, _dueCard),
          const SizedBox(height: 24),
        ],

        // Highest priority
        if (highest.isNotEmpty) ...[
          _sectionTitle('Highest priority'),
          _cardRow(highest, _priorityCard),
          const SizedBox(height: 24),
        ],

        // Work in progress
        _sectionTitle('Work in progress'),
        for (final task in _tasks) _progressTile(task),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.fraunces(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: HabitlyColors.ink,
        ),
      ),
    );
  }

  /// Two cards side by side. With only one task, the card keeps half the width.
  Widget _cardRow(List<Task> tasks, Widget Function(Task) buildCard) {
    return Row(
      children: [
        for (int i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: i < tasks.length ? buildCard(tasks[i]) : const SizedBox(),
          ),
        ],
      ],
    );
  }

  Widget _smallLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 0.8,
        color: HabitlyColors.muted,
      ),
    );
  }

  Widget _cardTitle(String text) {
    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.fraunces(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: HabitlyColors.ink,
      ),
    );
  }

  Widget _dueCard(Task task) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallLabel(_dueLabel(task.due)),
          const SizedBox(height: 8),
          Expanded(child: _cardTitle(task.title)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _tileColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.priority,
              style: const TextStyle(fontSize: 12, color: HabitlyColors.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityCard(Task task) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _smallLabel(task.tags.isEmpty ? 'No tag' : task.tags.first),
          const SizedBox(height: 8),
          Expanded(child: _cardTitle(task.title)),
          Text(
            _dueLabel(task.due),
            style: const TextStyle(fontSize: 12, color: HabitlyColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _progressTile(Task task) {
    final subtitle = task.tags.isEmpty
        ? _dueLabel(task.due)
        : '${task.tags.first} · ${_dueLabel(task.due)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: HabitlyColors.terracotta,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: HabitlyColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: HabitlyColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
