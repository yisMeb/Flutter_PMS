import 'package:flutter/material.dart';
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
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: HomeWrap,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get HomeWrap {
    return [
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
      const SizedBox(
        height: 20,
      ),
      taskLists()
    ];
  }

  Column taskLists() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Todays Task",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: 0.3,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 29, 78, 95),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        "UI Design",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 227, 237, 240),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "On Progress",
                          style: TextStyle(
                            color: Color.fromARGB(255, 29, 78, 95),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "8 November 2024 | 13 Subtask",
                    style: TextStyle(
                      color: Color.fromARGB(190, 158, 158, 158),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
