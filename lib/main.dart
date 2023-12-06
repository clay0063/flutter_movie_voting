import 'package:final_project/pages/enter_code_page.dart';
import 'package:final_project/pages/movie_page.dart';
import 'package:final_project/pages/share_code_page.dart';
import 'package:final_project/pages/welcome_page.dart';
import 'package:final_project/utils/prefs_manager.dart';
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
  int currentPageIndex = 0;
  List<Widget> pages = const [
    WelcomePage(),
    EnterCodePage(),
    ShareCodePage(),
    MoviePage()
  ];

  @override
  void initState(){
    super.initState();
    // PrefsManager.saveDeviceID();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   colorScheme: ThemeColorScheme.colorScheme,
      //   textTheme: ThemeTextTheme.textTheme,
      // ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App 2'),
        ),
        body: pages[currentPageIndex],
        //pages is a List with three widgets
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.data_object), label: 'Enter'),
            NavigationDestination(icon: Icon(Icons.data_object), label: 'Share'),
            NavigationDestination(icon: Icon(Icons.contact_page), label: 'Movie'),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            //triggered when new page is selected
            setState( () {
                currentPageIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
