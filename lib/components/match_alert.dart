import 'package:final_project/pages/welcome_page.dart';
import 'package:final_project/utils/structs.dart';
import 'package:final_project/utils/theme_data.dart';
import 'package:flutter/material.dart';

Widget matchAlert(BuildContext context, Movie movie) {
  return AlertDialog(
    title: const Text('Match!'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, //wrap content instead of stretching
        children: <Widget>[
          Image.network(
            movie.image,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // in case of image load error
              return const Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 100,
              );
            },
          ),
          Text(
            movie.name,
            textAlign: TextAlign.center,
            style: ThemeTextTheme.textTheme.titleLarge,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        },
        child: const Text('OK'),
      ),
    ],
  );
}
