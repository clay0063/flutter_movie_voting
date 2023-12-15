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

//Warning about an error:

//Either iOS or Android running from the terminal (flutter run) works fine
//iOS running from the Flutter Debug works fine too
//but Android running from Flutter Debug crashes on the "share code" screen
//Didn't realize this until too late and can't figure out the issue behind it :/

//The crash is a Paused on exception in socket_patch.dart
//"No address associated with hostname movie-night-api.onrender.com"

//Tried adding some things to the androidManifest to fix it and it cleared a terminal warning
//But it still crashes when running through flutter debug! sorry!!