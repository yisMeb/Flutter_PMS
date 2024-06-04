import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmanager/Pages/Dashboards/DatabaseService.dart';
import 'package:pmanager/Pages/Dashboards/ProjectDetails.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  late Future<List<Map<String, dynamic>>> _projectListFuture;

  @override
  void initState() {
    super.initState();
    _projectListFuture = DatabaseServices().fetchProjects();
  }

  double _calculateProgress(DateTime startDate, DateTime endDate) {
    final totalDuration = endDate.difference(startDate).inDays;
    final elapsedDuration = DateTime.now().difference(startDate).inDays;
    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    return formatter.format(date);
  }

  Future<int> _fetchSubtaskCount(String projectName) async {
    return await DatabaseServices().fetchSubtaskCount(projectName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _projectListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No projects found'));
        }

        final projects = snapshot.data!;
        return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            final title = project['title'];
            final details = project['details'];
            final startDate = DateTime.parse(project['startDate']);
            final endDate = DateTime.parse(project['endDate']);
            final progress = _calculateProgress(startDate, endDate);
            final teamMembers = project['teamMembers'] ?? [];
            String statusText;
            Color statusColor;
            if (progress == 1.0) {
              statusText = "Completed";
              statusColor = const Color.fromARGB(173, 244, 67, 54);
            } else if (progress == 0.0) {
              statusText = "Queued";
              statusColor = const Color.fromARGB(172, 134, 122, 7);
            } else {
              statusText = "On Progress";
              statusColor = const Color.fromARGB(173, 29, 79, 95);
            }
            return FutureBuilder<int>(
              future: _fetchSubtaskCount(project['title']),
              builder: (context, subtaskSnapshot) {
                if (subtaskSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (subtaskSnapshot.hasError) {
                  return Center(child: Text('Error: ${subtaskSnapshot.error}'));
                }

                final subtaskCount = subtaskSnapshot.data ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetails(project: project),
                        ),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 5,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 29, 78, 95),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${_formatDate(startDate)} | $subtaskCount Subtasks",
                                style: const TextStyle(
                                  color: Color.fromARGB(190, 158, 158, 158),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
