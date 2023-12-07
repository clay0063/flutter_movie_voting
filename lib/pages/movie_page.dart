import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final String? deviceID = PrefsManager.deviceId;
  final String? sessionID = '';
  late List<Map<String, String>> movieList;

  @override
  void initState() {
    super.initState();
    movieList = [];
    _loadMovieData();
  }

  Future<void> _loadMovieData() async {
    try {
      List<Map<String, String>> fetchedMovieList =
          await MovieFetch.fetchMovieData();
      setState(() {
        movieList = fetchedMovieList;
      });
    } catch (e) {
      // Handle the exception or display an error message
      print('Error loading movie data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Code Page"),
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _movieCards(),
          ),
        ),
      ),
    );
  }

  Widget _movieCards() {
    return ListView.builder(
      itemCount: movieList.length,
      itemBuilder: (context, index) {
        return Center(
            child: Dismissible(
          key: ValueKey<int>(int.parse(movieList[index]['id'] ?? '0')),
          onDismissed: (direction) {
            // Handle dismiss event based on direction
            if (direction == DismissDirection.endToStart) {
              // Swiped left (reject)
              // Handle reject action here
            } else if (direction == DismissDirection.startToEnd) {
              // Swiped right (approve)
              // Handle approve action here
            }
            setState(() {
              movieList.removeAt(index);
            });
          },
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          child: Column(
            children: <Widget>[
              Image.network(
                movieList[index]['image']!,
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
              Text(movieList[index]['name'] ?? ''),
              Text(movieList[index]['date'] ?? ''),
              Text(movieList[index]['rating'] ?? ''),
              Text(movieList[index]['id'] ?? ''),
            ],
          ),
        ),
        );
      },
    );
  }
}
