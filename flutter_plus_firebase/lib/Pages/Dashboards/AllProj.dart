import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/CalanderWidget.dart';
import 'package:pmanager/Pages/Dashboards/DatabaseService.dart';
import 'package:pmanager/Pages/Dashboards/ProjectList.dart';

class AllProj extends StatefulWidget {
  const AllProj({super.key});

  @override
  State<AllProj> createState() => _AllProjState();
}

class _AllProjState extends State<AllProj> {
  final TextEditingController _reminderTitleController =
      TextEditingController();
  DateTime? _selectedReminderTime;

  void _setReminder() async {
    if (_selectedReminderTime != null &&
        _reminderTitleController.text.isNotEmpty) {
      await DatabaseServices().createReminder(
        title: _reminderTitleController.text,
        reminderTime: _selectedReminderTime!,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reminder set successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a title and select a time')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CalendarWidget(),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Show a dialog to enter reminder details
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Set Reminder'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _reminderTitleController,
                                decoration: InputDecoration(labelText: 'Title'),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        _selectedReminderTime = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute,
                                        );
                                      });
                                    }
                                  }
                                },
                                child: Text('Select Date & Time'),
                              ),
                              if (_selectedReminderTime != null)
                                Text(
                                    'Reminder Time: ${_selectedReminderTime.toString()}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _setReminder();
                                Navigator.pop(context);
                              },
                              child: Text('Set Reminder'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 54, 52, 163),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size.fromWidth(307),
                  ),
                  child: const Text(
                    "Set Reminder",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Projects",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ProjectList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
