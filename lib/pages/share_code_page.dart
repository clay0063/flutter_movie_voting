import 'package:final_project/components/error_alert.dart';
import 'package:final_project/pages/movie_page.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:final_project/utils/theme_data.dart';
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

   @override
  void initState() {
    super.initState();
    _fetchSession();
  }


  Future<void> _fetchSession() async {
    try {
      Map<String, dynamic> fetchedSession =
          await SessionFetch.startSession(deviceID);

      if (fetchedSession.isEmpty ||
          fetchedSession['sessionId'] == null ||
          fetchedSession['sessionId'] == '') {
        _throwError('Unable to create session');
        return;
      } else {
        await PrefsManager.saveSessionID(fetchedSession['sessionId']);
      }

      setState(() {
        sessionData = fetchedSession;
        code = fetchedSession['code'].toString();
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voting Bloc"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Spacer(),
              Text(
                "Your code:",
                style: ThemeTextTheme.textTheme.titleMedium,
              ),
              Text(
                code,
                style: ThemeTextTheme.textTheme.displaySmall,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoviePage()),
                  );
                },
                child: const Text('Start Voting'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
