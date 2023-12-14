import 'package:flutter/material.dart';

//trying to move all the logic to here required passing in BuildContext logic from async functions which gives warnings
//couldn't figure out how to work around that in time so 

Widget errorWidget(BuildContext context, String error) {
  return AlertDialog(
    title: const Text('Error'),
    content: Text(error),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
    ],
  );
}
