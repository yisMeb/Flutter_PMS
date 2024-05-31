import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pmanager/Pages/forgot.dart';
import 'package:pmanager/Pages/landing_page.dart';
import 'package:pmanager/Pages/login_page.dart';
import 'package:pmanager/Pages/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "${dotenv.env["APIKEY"]}",
          appId: "${dotenv.env["APPID"]}",
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
