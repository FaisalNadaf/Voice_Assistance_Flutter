import 'package:flutter/material.dart';
import 'dart:async'; // For the timer

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the home screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, '/home'); // Change to your actual home route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.deepPurple, // Change the background color to match your theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your Voice Bot logo
            Image.asset(
              'assets/images/SplashLogo-removebg.png',
              height: 200, // Adjust height as needed
            ),
            SizedBox(height: 20), // Space between image and text
            // App name or splash text
            Text(
              'Voice Bot',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            // Tagline or description
            Text(
              'Your smart \'Zoe\' assistant',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
