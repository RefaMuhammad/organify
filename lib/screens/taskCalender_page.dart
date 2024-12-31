import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class Task {
  final String title;
  final DateTime date;

  Task({required this.title, required this.date});
}

class TaskCalendar extends StatefulWidget {
  @override
  _TaskCalendarState createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Data dummy untuk tugas
  Map<DateTime, List<Task>> tasks = {
    DateTime(2024, 12, 5): [Task(title: 'Tugas Mk 1', date: DateTime(2024, 12, 5))],
    DateTime(2024, 12, 15): [Task(title: 'Tugas Mk 2', date: DateTime(2024, 12, 15))],
    DateTime(2024, 12, 20): [
      Task(title: 'Tugas Mk 3', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 4', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 5', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 6', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 7', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 8', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 9', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 10', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 11', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 12', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 13', date: DateTime(2024, 12, 20)),
      Task(title: 'Tugas Mk 14', date: DateTime(2024, 12, 20)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0E8), // Background color #F1F0E8
      appBar: AppBar(
        backgroundColor: Color(0xFFD9D9D9), // Background color AppBar #D9D9D9
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFFD9D9D9),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
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
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) {
                  // Jika tanggal yang dipilih, jangan tampilkan penanda
                  if (isSameDay(_selectedDay, day)) {
                    return [];
                  }
                  // Tampilkan penanda untuk tanggal lain yang memiliki tugas
                  return tasks[DateTime(day.year, day.month, day.day)] ?? [];
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Color(0xFF4E6167),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF4E6167),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _selectedDay == null
                  ? Center(child: Text('Pilih tanggal untuk melihat tugas'))
                  : ListView(
                children: tasks[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)]
                    ?.map((task) => Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9), // Background color #D9D9D9
                    borderRadius: BorderRadius.circular(12.0), // Ujung melengkung
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Margin antar item
                  padding: EdgeInsets.symmetric(vertical: 1.0), // Padding di dalam Container
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222831)), // Gaya teks
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.flag), // Warna ikon
                      onPressed: () {
                        _addEventToCalendar(task);
                      },
                    ),
                  ),
                ))
                    .toList() ??
                    [],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addEventToCalendar(Task task) {
    final Event event = Event(
      title: task.title,
      description: 'Tugas untuk tanggal ${task.date.toLocal()}',
      location: 'Ruang Kelas',
      startDate: task.date,
      endDate: task.date.add(Duration(hours: 1)),
    );

    Add2Calendar.addEvent2Cal(event).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tugas berhasil ditambahkan ke kalender')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan tugas ke kalender: $error')),
      );
    });
  }
}