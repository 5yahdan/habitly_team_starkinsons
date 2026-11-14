import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';

/// One task.
class Task {
  final String title;
  final String priority; // 'Low', 'Medium' or 'High'
  final DateTime due;

  const Task({required this.title, required this.priority, required this.due});
}

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, this.username = ''});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  final List<Task> _tasks = []; // starts empty

  static const _cardColor = Color(0xFFE9DCC6);
  static const _tileColor = Color(0xFFFAF4EA);

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

  /// The form that slides up when you tap +
  void _openAddTask() {
    final titleController = TextEditingController();
    String priority = 'Medium';
    DateTime due = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: HabitlyColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New task',
                    style: GoogleFonts.fraunces(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: HabitlyColors.ink,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Title',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Priority',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Low', label: Text('Low')),
                      ButtonSegment(value: 'Medium', label: Text('Medium')),
                      ButtonSegment(value: 'High', label: Text('High')),
                    ],
                    selected: {priority},
                    onSelectionChanged: (s) =>
                        setSheetState(() => priority = s.first),
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: HabitlyColors.terracotta,
                      selectedForegroundColor: Colors.white,
                      side: const BorderSide(color: HabitlyColors.outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Due',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: sheetContext,
                        initialDate: due,
                        firstDate: DateTime(now.year, now.month, now.day),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) setSheetState(() => due = picked);
                    },
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(_dueLabel(due)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: HabitlyColors.ink,
                      side: const BorderSide(color: HabitlyColors.outline),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) return; // needs a title
                        setState(
                          () => _tasks.add(
                            Task(title: title, priority: priority, due: due),
                          ),
                        );
                        Navigator.pop(sheetContext);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: HabitlyColors.terracotta,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Save task'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username.isEmpty
                        ? _greeting
                        : '$_greeting, ${widget.username}',
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
              onPressed: _openAddTask,
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

        if (almostDue.isNotEmpty) ...[
          _sectionTitle('Almost due'),
          _cardRow(almostDue, _dueCard),
          const SizedBox(height: 24),
        ],
        if (highest.isNotEmpty) ...[
          _sectionTitle('Highest priority'),
          _cardRow(highest, _priorityCard),
          const SizedBox(height: 24),
        ],
        if (_tasks.isNotEmpty) ...[
          _sectionTitle('Work in progress'),
          for (final task in _tasks) _progressTile(task),
        ],
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
          _smallLabel(task.priority),
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
                  '${task.priority} · ${_dueLabel(task.due)}',
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
