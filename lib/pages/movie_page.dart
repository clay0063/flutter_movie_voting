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
  int currentListIndex = 0;

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
    } catch (error) {
      // Handle the exception or display an error message
      print('Error loading movie data: $error');
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
            child: movieList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _movieCards(),
          ),
        ),
      ),
    );
  }

  Widget _movieCards() {
    return Dismissible(
      key: ValueKey<int>(int.parse(movieList[currentListIndex]['id'] ?? '0')),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // swiped left (reject)
        } else if (direction == DismissDirection.startToEnd) {
          // swiped right (approve)
        }
        setState(() {
          movieList.removeAt(currentListIndex);
          if (currentListIndex >= movieList.length) {
            currentListIndex = 0;
          }
        });
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        child: const Icon(
          Icons.check,
          color: Colors.black,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      child: Column(
        children: <Widget>[
          Image.network(
            movieList[currentListIndex]['image']!,
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
          Text(movieList[currentListIndex]['name'] ?? ''),
          Text(movieList[currentListIndex]['date'] ?? ''),
          Text(movieList[currentListIndex]['rating'] ?? ''),
        ],
      ),
    );
  }
}
