import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/ProjectList.dart';
import 'package:pmanager/Pages/Dashboards/SubTasks.dart';
import 'package:pmanager/Pages/Dashboards/TaskList.dart';

class ProjectDetails extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetails({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 229, 229, 229),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Project Detail",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color.fromRGBO(153, 215, 245, 1),
              child: Image.asset(
                'images/profilePic.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(123, 255, 255, 255)),
          ),
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${project['title']}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '${project['details']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 175, 175, 175),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Team Members',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "${project['teamMembers'].join(', ')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 175, 175, 175),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Subtasks",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              SubTasks(
                                  projectName:
                                      project['title']), // Pass project name
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(150, 54, 52, 163),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // Display subtasks
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TaskList(
                        projectName: project['title']), // Pass project name
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
