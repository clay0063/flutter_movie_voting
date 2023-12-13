 
import 'package:final_project/utils/structs.dart';
import 'package:final_project/utils/theme_data.dart';
import 'package:flutter/material.dart';

  Widget movieCard(Movie movie) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Released: ${movie.date}"),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4.0),
                      Text(movie.rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }