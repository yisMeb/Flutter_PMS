import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmanager/Pages/Dashboards/DatabaseService.dart';

class TaskList extends StatefulWidget {
  final String projectName;

  const TaskList({Key? key, required this.projectName}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<List<Map<String, dynamic>>> _taskListFuture;

  @override
  void initState() {
    super.initState();
    _taskListFuture =
        DatabaseServices().fetchTasks(projectName: widget.projectName);
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _taskListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tasks found'));
        }

        final tasks = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final taskName = task['taskName'];
                  final taskDescription = task['taskDescription'];
                  final startDate = DateTime.parse(task['startDate']);
                  final endDate = DateTime.parse(task['endDate']);
                  final isDone = task['isDone'] ?? false;

                  final words = taskDescription.split(' ');

                  final truncatedDescription = words.length <= 10
                      ? taskDescription
                      : words.take(10).join(' ') + '...';

                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        // Swipe right - delete task
                        await DatabaseServices().deleteTask(taskName);
                      } else if (direction == DismissDirection.startToEnd) {
                        // Swipe left - mark task as completed
                        await DatabaseServices().markTaskAsDone(taskName);
                      }
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.green, // Background color when swiped left
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20.0),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red, // Background color when swiped right
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isDone
                              ? Colors.grey
                              : Colors.white, // Change color if task is done
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                taskName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                truncatedDescription,
                                style: const TextStyle(
                                  color: Color.fromARGB(127, 97, 97, 97),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
