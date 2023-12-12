import 'package:final_project/pages/movie_page.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/prefs_manager.dart';
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

  void _buttonControl() {
    _joinSession();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MoviePage()),
    // );
  }

  Future<void> _joinSession() async {
    try {
      Map<String, dynamic> fetchedSession =
          await SessionFetch.joinSession(deviceID, int.parse(code));
      await PrefsManager.saveSessionID(fetchedSession['sessionId']);

      setState(() {
        sessionData = fetchedSession;
      });
    } catch (error) {
      // Handle the exception or display an error message
      print('Error loading session data: $error');
    }
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
                  _buttonControl();
                },
                child: const Text('Start Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
