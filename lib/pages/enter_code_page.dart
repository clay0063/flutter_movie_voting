import 'package:final_project/pages/movie_page.dart';
import 'package:flutter/material.dart';

class EnterCodePage extends StatelessWidget {
  const EnterCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Code Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Text("Enter Code Page Content"),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoviePage()),
                  );
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