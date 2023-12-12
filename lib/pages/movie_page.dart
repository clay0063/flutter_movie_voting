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
                    : Center(
                        child: _movieCards(),
                      ),
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
      background: const SizedBox(
        width: 200,
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.thumb_down,
            color: Colors.black,
            size: 50,
          ),
        ),
      ),
      secondaryBackground: const SizedBox(
        width: 200,
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.thumb_up,
            color: Colors.black,
            size: 50,
          ),
        ),
      ),
      // child: Card(
      //   elevation: 2.0,
      //   margin: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 400.0, // Set your minimum width here
              ),
            ),
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
      // ),
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
