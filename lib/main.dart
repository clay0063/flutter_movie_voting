import 'package:final_project/pages/welcome_page.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:final_project/utils/theme_data.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsManager.saveDeviceID();
  PrefsManager.deviceId= await PrefsManager.getDeviceID();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ThemeColorScheme.colorScheme,
        textTheme: ThemeTextTheme.textTheme,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Voting Bloc'),
        ),
        body: const WelcomePage(),
      ),
    );
  }
}
