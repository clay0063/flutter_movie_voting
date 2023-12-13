import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String error;
  
  const ErrorWidget({
    super.key,
    this.error = "An error has occurred."
    });
  

  @override
  Widget build(BuildContext context) {
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
}