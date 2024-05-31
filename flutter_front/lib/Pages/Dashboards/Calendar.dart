import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool _isYearView = true;
  final DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the back button
        title: Text('Calendar - ${_isYearView ? 'Year Overview' : 'Year'}'),
        actions: [
          IconButton(
            icon: Icon(
                _isYearView ? Icons.calendar_today : Icons.calendar_view_month),
            onPressed: () {
              setState(() {
                _isYearView = !_isYearView;
              });
            },
          ),
        ],
      ),
      body: _isYearView ? _buildYearView() : _buildMonthView(),
    );
  }

  Widget _buildYearView() {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _isYearView = false;
            });
          },
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat.MMMM()
                        .format(DateTime(_currentDate.year, index + 1)),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: _buildMonthGrid(index + 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthGrid(int month) {
    DateTime firstDayOfMonth = DateTime(_currentDate.year, month, 1);
    int daysInMonth = DateUtils.getDaysInMonth(_currentDate.year, month);

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
      ),
      itemCount: firstDayOfMonth.weekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < firstDayOfMonth.weekday) {
          return Container();
        }
        int day = index - firstDayOfMonth.weekday + 1;
        DateTime date = DateTime(_currentDate.year, month, day);
        bool isToday = date.year == _currentDate.year &&
            date.month == _currentDate.month &&
            date.day == _currentDate.day;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: isToday ? Colors.blue : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isToday ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthView() {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  DateFormat.yMMMM()
                      .format(DateTime(_currentDate.year, index + 1)),
                ),
              ),
              Divider(),
              _buildMonthDaysList(index + 1),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthDaysList(int month) {
    DateTime firstDayOfMonth = DateTime(_currentDate.year, month, 1);
    int daysInMonth = DateUtils.getDaysInMonth(_currentDate.year, month);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        DateTime date = DateTime(_currentDate.year, month, index + 1);
        bool isToday = date.year == _currentDate.year &&
            date.month == _currentDate.month &&
            date.day == _currentDate.day;

        return ListTile(
          title: Text(
            DateFormat.E().add_d().format(date),
          ),
          tileColor: isToday ? Colors.blue[100] : null,
        );
      },
    );
  }
}
