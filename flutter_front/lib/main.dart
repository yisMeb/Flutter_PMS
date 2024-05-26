import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmanager/Pages/forgot.dart';
import 'package:pmanager/Pages/landing_page.dart';
import 'package:pmanager/Pages/login_page.dart';
import 'package:pmanager/Pages/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAY7wHbt4QKipALgR4kyo2ItwvjgJt7tGY",
          appId: "1:1067253489994:android:ed0eb8e4634f8b125b61b3",
          messagingSenderId: "1067253489994",
          projectId: "projectmanagement-f11f5"));

  runApp(MaterialApp(
    home: const landing_page(),
    debugShowCheckedModeBanner: false,
    routes: {
      '/login': (context) => const login_page(),
      '/signup': (context) => const Signup(),
      '/forgot': (context) => const Forgot(),
    },
  ));
}
