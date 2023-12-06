import 'package:flutter/material.dart';
import 'package:final_project/utils/prefs_manager.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPrefs')
      ),
      body: Center(
        child: Text(
          'ID: ${PrefsManager.deviceId ?? 'None'}'
        ),)
    );
  }
}