import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/DatabaseService.dart';
import 'package:pmanager/Pages/Dashboards/Visualizer.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _fullName;
  late String taskNum;
  late List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fullName = '';
    taskNum = '0';
    _fetchFullName();
    _fetchTasks();
  }

  double _calculateProgress(DateTime startDate, DateTime endDate) {
    final totalDuration = endDate.difference(startDate).inDays;
    final elapsedDuration = DateTime.now().difference(startDate).inDays;
    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }

  Color _getColorBasedOnProgress(double progress) {
    if (progress >= 0.9) {
      return Colors.red;
    } else if (progress == 0.0) {
      return const Color.fromARGB(255, 170, 153, 4);
    } else {
      return Colors.blue;
    }
  }

  String _getStatusText(double progress) {
    if (progress >= 1.0) {
      return 'Completed';
    } else if (progress <= 0.0) {
      return 'Queued';
    } else {
      return 'On Progress';
    }
  }

  Future<void> _fetchTasks() async {
    try {
      final List<Map<String, dynamic>> tasks =
          await DatabaseServices().fetchSubtasks();
      tasks.sort((a, b) {
        final DateTime deadlineA = DateTime.parse(a['endDate']);
        final DateTime deadlineB = DateTime.parse(b['endDate']);
        return deadlineA.compareTo(deadlineB);
      });
      setState(() {
        _tasks = tasks;
        taskNum = tasks.length.toString();
      });
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  Future<void> _fetchFullName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref =
          FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as dynamic;
        //setState(() => _fullName = data['fullName'] ?? '');
        if (mounted) {
          setState(() => _fullName = data['fullName'] ?? '');
        }
      }
    }
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat('d MMMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHomeNavBar(),
                const SizedBox(height: 20),
                _buildFullNameText(),
                const SizedBox(height: 20),
                _buildVisualizer(),
                const SizedBox(height: 20),
                _buildHomeTaskCard(),
                const SizedBox(height: 20),
                const Text(
                  "Your Tasks",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTaskLists(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameText() {
    return Row(
      children: [
        Text(
          _fullName,
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Widget _buildVisualizer() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Visualizer(),
      ),
    );
  }

  Widget _buildHomeTaskCard() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 54, 52, 163),
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('images/cardbg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              formattedDate(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Today Tasks \n"),
                      TextSpan(
                          text: "$taskNum tasks today",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          )),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskLists() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _tasks.map((task) {
        final double progress = _calculateProgress(
          DateTime.parse(task['startDate']),
          DateTime.parse(task['endDate']),
        );
        final int teamMemberCount = task['selectedTeamMembers'] != null
            ? task['selectedTeamMembers'].length
            : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 5,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorBasedOnProgress(progress),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          task['taskName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 227, 237, 240),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _getStatusText(progress),
                            style: TextStyle(
                              color: _getColorBasedOnProgress(progress),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${formattedDate(DateTime.parse(task['startDate']))} | $teamMemberCount Teams",
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
        );
      }).toList(),
    );
  }

  Widget _buildHomeNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Welcome Back!",
          style: TextStyle(color: Color.fromRGBO(54, 52, 163, 1)),
        ),
        Row(
          children: [
            Icon(Icons.notifications_none_outlined),
            SizedBox(width: 10),
            CircleAvatar(
              radius: 25,
              backgroundColor: Color.fromRGBO(153, 215, 245, 1),
              child: ClipOval(
                child: Image.asset(
                  'images/profilePic.png',
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
