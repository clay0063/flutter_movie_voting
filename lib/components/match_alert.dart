import 'package:final_project/utils/structs.dart';
import 'package:final_project/utils/theme_data.dart';
import 'package:flutter/material.dart';

Widget matchAlert(BuildContext context, Movie movie) {
  return AlertDialog(
    title: const Center(
      child: Text("Match Made!"),
    ),
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
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: const Text('Back to Home'),
      ),
    ],
    actionsAlignment: MainAxisAlignment.center,
    backgroundColor: ThemeColorScheme.colorScheme.surface,
  );
}
