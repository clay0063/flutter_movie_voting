import 'package:final_project/components/error_alert.dart';
import 'package:final_project/pages/movie_page.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:final_project/utils/theme_data.dart';
import 'package:flutter/material.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});

  @override
  State<EnterCodePage> createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  String deviceID = PrefsManager.deviceId ?? '';
  Map<String, dynamic>? sessionData;
  bool isButtonEnabled = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //enable/disable button based on if there is a code entered or not
    textController.addListener(() {
      setState(() {
        isButtonEnabled = textController.text.isNotEmpty;
      });
    });
  }

  Future<void> _joinSession() async {
    try {
      Map<String, dynamic> fetchedSession = await SessionFetch.joinSession(
          deviceID, int.parse(textController.text));

      if (fetchedSession['sessionId'] != null) {
        await PrefsManager.saveSessionID(fetchedSession['sessionId']);
      } else if (fetchedSession['message'] != null) {
        _throwError(fetchedSession['message']);
        return;
      } else {
        throw Error;
      }

      setState(() {
        sessionData = fetchedSession;
      });

      _pageNavigation();
    } catch (error) {
      _throwError(error.toString());
    }
  }

  void _throwError(errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorWidget(context, errorMessage);
      },
    );
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
        title: const Text("Voting Bloc"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter Code:",
                  style: ThemeTextTheme.textTheme.titleMedium,
                ),
              ),
              TextField(
                maxLength: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Code',
                  filled: true,
                ),
                onChanged: (text) {
                  textController.text = text;
                },
              ),
              ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        _joinSession();
                      }
                    : null,
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
