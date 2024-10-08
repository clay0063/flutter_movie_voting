import 'package:final_project/components/error_alert.dart';
import 'package:final_project/components/match_alert.dart';
import 'package:final_project/pages/welcome_page.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:final_project/utils/structs.dart';
import 'package:final_project/utils/prefs_manager.dart';
import 'package:final_project/components/movie_card.dart';
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
  }

  Future<void> _loadSessionData() async {
    try {
      sessionID = await PrefsManager.getSessionID();
      if (sessionID == null || sessionID == '') {
        _throwError('Unable to connect to session');
      }
    } catch (error) {
      _throwError(error.toString());
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
        title: const Text("Voting Bloc"),
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
      child: movieCard(movieList[currentListIndex]),
    );
  }

  void _checkMatch(bool match, int movieId) {
    if (match) {
      Movie? movie =
          movieList.firstWhere((movie) => movie.id == movieId.toString());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return matchAlert(context, movie);
        },
      );
    }
  }

  Future<void> _handleSwipe(int movieId, bool vote) async {
    //true = vote for approve
    //false = vote for deny
    Map<String, dynamic> voteResult =
        await SessionFetch.voteOnMovie(sessionID!, movieId, vote);
    bool match = voteResult['match'];
    int matchedMovie = int.parse(voteResult['movieId']);
    _checkMatch(match, matchedMovie);

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

  void _throwError(errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorWidget(context, errorMessage);
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
