import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/CalanderWidget.dart';

class AllProj extends StatefulWidget {
  const AllProj({super.key});

  @override
  State<AllProj> createState() => _AllProj();
}

class _AllProj extends State<AllProj> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //calender
              CalendarWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
