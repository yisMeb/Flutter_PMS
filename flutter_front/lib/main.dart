import 'package:flutter/material.dart';
import 'package:pmanager/Pages/landing_page.dart';
import 'package:pmanager/Pages/login_page.dart';

void main() {
  runApp(
    MaterialApp(
     home: const landing_page(),
     debugShowCheckedModeBanner: false,
      routes: {
        '/login' : (context) =>const login_page(),
      },
    )
  );
}
