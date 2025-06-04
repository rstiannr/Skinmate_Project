import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database_helper.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  TrackerScreenState createState() => TrackerScreenState();
}

class TrackerScreenState extends State<TrackerScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<String, List<Map<String, dynamic>>> routines = {
    'morning': [],
    'evening': [],
  };

  int? userId;

  @override
  void initState() {
    super.initState();
    userId = 1;
    _selectedDay = DateTime.now();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    if (userId == null || _selectedDay == null) return;
    final db = DatabaseHelper();

    final morningRoutines = await db.getRoutinesByUserIdAndSchedule(
      userId!,
      'morning',
    );
    final eveningRoutines = await db.getRoutinesByUserIdAndSchedule(
      userId!,
      'evening',
    );
    final products = await db.getProductsByUserId(userId!);

    final selectedDateStr = _selectedDay!.toIso8601String().substring(0, 10);
    final morningHistory = await db.getRoutineHistoryByUserIdAndScheduleAndDate(
      userId!,
      'morning',
      selectedDateStr,
    );
    final eveningHistory = await db.getRoutineHistoryByUserIdAndScheduleAndDate(
      userId!,
      'evening',
      selectedDateStr,
    );

    List<Map<String, dynamic>> mapRoutine(
      List<Map<String, dynamic>> routinesList,
      List<Map<String, dynamic>> historyList,
    ) {
      return routinesList.map((routine) {
        final product = products.firstWhere(
          (p) => p['product_id'] == routine['product_id'],
          orElse: () => {},
        );
        final isChecked = historyList.any(
          (h) => h['routines_id'] == routine['routines_id'],
        );
        return {
          'brand': product['type'] ?? '',
          'product': product['name'] ?? '',
          'category': product['type'] ?? '',
          'used': isChecked,
          'image': product['picture'] ?? '',
          'routines_id': routine['routines_id'],
        };
      }).toList();
    }

    setState(() {
      routines['morning'] = mapRoutine(morningRoutines, morningHistory);
      routines['evening'] = mapRoutine(eveningRoutines, eveningHistory);
    });
  }

  Future<void> toggleUsed(String routine, int index) async {
    if (userId == null || _selectedDay == null) return;
    final db = DatabaseHelper();
    final routineItem = routines[routine]![index];
    final routinesId = routineItem['routines_id'];
    final isChecked = !(routineItem['used'] as bool);
    final selectedDateStr = _selectedDay!.toIso8601String().substring(0, 10);

    if (isChecked) {
      await db.insertRoutineHistory({
        'users_id': userId, // Changed from 'users_id' to 'users_id'
        'routines_id': routinesId,
        'done_date': selectedDateStr,
      });
    } else {
      await db.deleteRoutineHistoryByRoutineIdAndDate(
        routinesId,
        selectedDateStr,
      );
    }

    setState(() {
      routines[routine]![index]['used'] = isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          'Tracker',
          style: TextStyle(color: Colors.pinkAccent),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.pinkAccent),
            onPressed: () {},
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.pinkAccent),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ToggleButtons(
            borderRadius: BorderRadius.circular(8),
            borderColor: Colors.pinkAccent,
            selectedBorderColor: Colors.pinkAccent,
            fillColor: Colors.pinkAccent.withAlpha((0.1 * 255).toInt()),
            isSelected: [false, true, false],
            onPressed: (index) {},
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('History'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Diary',
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Analytics'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _loadRoutines();
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.pinkAccent.withAlpha((0.2 * 255).toInt()),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.pinkAccent,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Routines',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Colors.pinkAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Container for Morning Routine
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withAlpha(
                          (0.07 * 255).toInt(),
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          'Morning',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                      _buildRoutineSection('Morning Routine', 'morning'),
                    ],
                  ),
                ),
                // Container for Evening Routine
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          'Evening',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                      _buildRoutineSection('Evening Routine', 'evening'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineSection(String title, String routineKey) {
    final routineList = routines[routineKey] ?? [];
    if (routineList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No $title yet.',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.pinkAccent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...routineList.asMap().entries.map((entry) {
          int idx = entry.key;
          var product = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: CheckboxListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              tileColor: Colors.pinkAccent.withAlpha((0.03 * 255).toInt()),
              value: product['used'] ?? false,
              onChanged: (val) async {
                await toggleUsed(routineKey, idx);
                await _loadRoutines(); // refresh after insert/delete
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['brand'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    product['product'] ?? '',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    product['category'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              secondary:
                  product['image'] != null && product['image'] != ''
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          product['image'],
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      )
                      : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 0,
              ),
              activeColor: Colors.pinkAccent,
              checkColor: Colors.white,
            ),
          );
        }),
      ],
    );
  }
}
