import 'package:flutter/material.dart';
import 'package:voice_assistance_flutter/pages/homePage.dart';
import 'package:voice_assistance_flutter/pages/splashPage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  runApp(VoiceBotApp());
}

class VoiceBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Bot',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            SplashScreen(), // Set the splash screen as the initial route
        '/home': (context) =>
            VoiceBotHomePage(), // Define your home screen route
      },
    );
  }
}
