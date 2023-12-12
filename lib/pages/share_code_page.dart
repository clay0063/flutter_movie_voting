import 'package:final_project/pages/movie_page.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:flutter/material.dart';

class ShareCodePage extends StatefulWidget {
  const ShareCodePage({super.key});

  @override
  State<ShareCodePage> createState() => _ShareCodePageState();
}

class _ShareCodePageState extends State<ShareCodePage> {
  String deviceID = PrefsManager.deviceId ?? '';
  Map<String, dynamic>? sessionData;
  String code = "_ _ _ _";

  void _buttonControl() {
    _fetchSession();
  }

  Future<void> _fetchSession() async {
    try {
      Map<String, dynamic> fetchedSession =
          await SessionFetch.startSession(deviceID);

      if (fetchedSession.isEmpty || fetchedSession['sessionId'] == '') {
        return;
      } else {
        await PrefsManager.saveSessionID(fetchedSession['sessionId']);
      }

      setState(() {
        sessionData = fetchedSession;
        code = fetchedSession['code'].toString();
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
        title: const Text("Share Code Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Text("Share Code Page Content"),
              ElevatedButton(
                onPressed: _buttonControl,
                child: const Text('Generate Code'),
              ),
              Text(code),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoviePage()),
                  );
                },
                child: const Text('Start Voting'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
