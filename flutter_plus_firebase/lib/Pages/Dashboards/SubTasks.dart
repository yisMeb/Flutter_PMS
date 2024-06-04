import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmanager/Pages/Dashboards/DatabaseService.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SubTasks extends StatefulWidget {
  final String projectName;

  const SubTasks({Key? key, required this.projectName}) : super(key: key);

  @override
  State<SubTasks> createState() => _SubTasksState();
}

class _SubTasksState extends State<SubTasks> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedTeamMembers = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      List<String> teamMembers = await DatabaseServices().fetchTeamMembers();
      setState(() {
        _selectedTeamMembers = teamMembers;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch team members: $error')),
      );
    }
  }

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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 229, 229, 229),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                    labelText: "Task Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Start Date"),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 10),
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("End Date"),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 10),
                                  Text(
                                    _endDate == null
                                        ? 'Select end date'
                                        : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _taskDescriptionController,
                  decoration: const InputDecoration(
                    labelText: "Task Description",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                MultiSelectDialogField(
                  items: _selectedTeamMembers
                      .map((member) => MultiSelectItem<String>(member, member))
                      .toList(),
                  title: const Text("Team Members"),
                  selectedColor: Colors.blue,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    "Assign Team",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  onConfirm: (results) {
                    setState(() {
                      _selectedTeamMembers = results;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final taskName = _taskNameController.text;
                      final taskDescription = _taskDescriptionController.text;
                      if (_startDate != null && _endDate != null) {
                        try {
                          await DatabaseServices().createSubtask(
                            projectName:
                                widget.projectName, // Pass project name
                            taskName: taskName,
                            taskDescription: taskDescription,
                            startDate: _startDate!,
                            endDate: _endDate!,
                            selectedTeamMembers: _selectedTeamMembers,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Subtask created')),
                          );
                          Navigator.pop(
                              context); // Close the screen after creation
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Task with the same name already exists: $e'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please select start and end date')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 54, 52, 163),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size.fromWidth(207),
                  ),
                  child: const Text(
                    "Create task",
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
