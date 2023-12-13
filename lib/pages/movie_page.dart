import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/structs.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:final_project/utils/theme_data.dart';
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
                //DISPLAY LOADER THEN DISPLAY CARDS
                movieList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: _movieCardsList(),
                      ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _movieCardsList() {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        int movieId = int.parse(movieList[currentListIndex].id);
        if (direction == DismissDirection.endToStart) {
          // swiped left (reject)
          _handleSwipe(movieId, false);
        } else if (direction == DismissDirection.startToEnd) {
          // swiped right (approve)
          _handleSwipe(movieId, true);
        }
      },
      //APPROVAL EFFECT
      background: const SizedBox(
        width: 200,
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.thumb_up,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
      //REJECTION EFFECT
      secondaryBackground: const SizedBox(
        width: 200,
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.thumb_down,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
      child: _movieCard(),
    );
  }

  Widget _movieCard() {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            Text(
              movieList[currentListIndex].name,
              textAlign: TextAlign.center,
              style: ThemeTextTheme.textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Released: ${movieList[currentListIndex].date}"),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4.0),
                      Text(movieList[currentListIndex].rating),
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

  Future<void> _handleSwipe(int movieId, bool vote) async {
    //true = vote for approve
    //false = vote for deny
    Map<String, dynamic> voteResult = await SessionFetch.voteOnMovie(sessionID!, movieId, vote);
    bool match = voteResult['match'];
    if (match) {
      print('WINNER IS ${voteResult['movieId']}');
    }

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
