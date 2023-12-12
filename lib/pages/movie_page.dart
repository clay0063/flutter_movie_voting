import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/structs.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final String? deviceID = PrefsManager.deviceId;
  late String? sessionID;
  List<Movie> movieList = [];
  List<Movie> swipedMovieList = [];
  int currentListIndex = 0;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
    // _loadMovieData();
  }

  Future<void> _loadSessionData() async {
    try {
      sessionID = await PrefsManager.getSessionID();
      //if no sessionId boot to home
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    _loadMovieData();
  }

  Future<void> _loadMovieData() async {
    try {
      List<Movie> fetchedMovieList =
          await MovieFetch.fetchMovieData(pageNumber);

      setState(() {
        movieList.addAll(fetchedMovieList);
      });
    } catch (error) {
      // Handle the exception or display an error message
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Code Page"),
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                const Spacer(),
                movieList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _movieCards(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _movieCards() {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // swiped left (reject)
          // _handleDismiss(reject);
        } else if (direction == DismissDirection.startToEnd) {
          // swiped right (approve)
          // _handleDismiss(approve);
        }
        _handleSwipe();
      },
      background: Container(
        alignment: Alignment.center,
        child: const Icon(
          Icons.check,
          color: Colors.black,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      child: Column(
        children: <Widget>[
          Image.network(
            movieList[currentListIndex].image,
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
          Text(movieList[currentListIndex].name),
          Text(movieList[currentListIndex].date),
          Text(movieList[currentListIndex].rating),
        ],
      ),
    );
  }

  Future<void> _handleSwipe() async {
    if (currentListIndex >= movieList.length - 1) {
      // Reached near the end of the list, load more data
      pageNumber++;
      await _loadMovieData();
      currentListIndex++;
    }

    setState(() {
      currentListIndex++;
    });
  }
}
