import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _fetchFullName();
  }

  Future<void> _fetchFullName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref =
          FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as dynamic;
        setState(() {
          _fullName = data['fullName'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(color: Color.fromRGBO(54, 52, 163, 1)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.notifications_none_outlined),
                      const SizedBox(width: 10),
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
              ),
              Row(
                children: [
                  Text(
                    _fullName,
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PieChart(PieChartData(
                      centerSpaceRadius: 5,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      sections: [
                        PieChartSectionData(
                            value: 35, color: Colors.purple, radius: 100),
                        PieChartSectionData(
                            value: 40, color: Colors.amber, radius: 100),
                        PieChartSectionData(
                            value: 55, color: Colors.green, radius: 100),
                        PieChartSectionData(
                            value: 70, color: Colors.orange, radius: 100),
                      ]))),
            ]),
      )),
    );
  }
}
