import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/Visualizer.dart';
import 'package:intl/intl.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String _fullName = '';
  String taskNum = 10.toString();

  @override
  void initState() {
    super.initState();
    _fetchFullName();
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat('d MMMM yyyy').format(dateTime);
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
              homeNavBar(),
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
                child: Visualizer(),
              ),
              const SizedBox(
                height: 20,
              ),
              homeTaskCard(),

              //Each Tasks
            ]),
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_rounded,
                color: Color.fromARGB(200, 54, 52, 163), // Set color to blue
                size: 60.0,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined), label: "Calender"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
  }

  Container homeTaskCard() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(235, 54, 52, 163),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 38, 50, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Text(
                    "See today's task",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row homeNavBar() {
    return Row(
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
    );
  }
}
