import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProject();
}

class _CreateProject extends State<CreateProject> {
  final List<String> _teamMembers = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
  ];

  List<String> _selectedTeamMembers = [];
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Project Title",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'School Management System',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Project Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                const Text(
                  "Add team members",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                MultiSelectDialogField(
                  items: _teamMembers
                      .map((member) => MultiSelectItem<String>(member, member))
                      .toList(),
                  title: Text("Team Members"),
                  selectedColor: Colors.blue,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  buttonIcon: const Icon(
                    Icons.group_add,
                    color: Colors.blue,
                  ),
                  buttonText: Text(
                    "Select Team Members",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    setState(() {
                      _selectedTeamMembers = results;
                    });
                  },
                ),
                SizedBox(height: 20),
                const Text(
                  "Start & End date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Date"),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 10),
                                  Text(
                                    _startDate == null
                                        ? 'Select start date'
                                        : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("End Date"),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 10),
                                  Text(
                                    _startDate == null
                                        ? 'Select end date'
                                        : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 54, 52, 163),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: Size.fromWidth(207),
                        ),
                        child: const Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: Size.fromWidth(207),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
