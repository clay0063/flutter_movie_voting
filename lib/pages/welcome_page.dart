import 'package:final_project/pages/enter_code_page.dart';
import 'package:final_project/pages/share_code_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShareCodePage()),
                  );
                },
                child: const Text('Start Session'),
              ),
              const Spacer(),
              const Text("Choose an option"),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EnterCodePage()),
                  );
                },
                child: const Text('Enter Code'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
