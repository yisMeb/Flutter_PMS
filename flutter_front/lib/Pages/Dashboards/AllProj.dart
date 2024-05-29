import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/CalanderWidget.dart';
import 'package:pmanager/Pages/Dashboards/ProjectList.dart';

class AllProj extends StatefulWidget {
  const AllProj({super.key});

  @override
  State<AllProj> createState() => _AllProjState();
}

class _AllProjState extends State<AllProj> {
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
                  onPressed: () {},
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
