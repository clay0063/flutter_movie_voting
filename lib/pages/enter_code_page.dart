import 'package:final_project/pages/movie_page.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});

  @override
  State<EnterCodePage> createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  String deviceID = PrefsManager.deviceId ?? '';
  Map<String, dynamic>? sessionData;
  String code = '';

  Future<void> _joinSession() async {
    try {
      Map<String, dynamic> fetchedSession =
          await SessionFetch.joinSession(deviceID, int.parse(code)); //crashes if nothing is entered
      await PrefsManager.saveSessionID(fetchedSession['sessionId']);

      setState(() {
        sessionData = fetchedSession;
      });

      _pageNavigation();
    } catch (error) {
      // Handle the exception or display an error message
      if (kDebugMode) {
        print('Error loading session data: $error');
      }
    }
  }

  void _pageNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoviePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Code Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Spacer(),
              const Text("Enter Code :"),
              TextField(
                maxLength: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Code',
                  // counterText: '',
                ),
                onChanged: (text) {
                  setState(() {
                    code = text;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _joinSession();
                },
                child: const Text('Start Session'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
