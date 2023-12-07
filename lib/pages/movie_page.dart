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
            child: _buildMovieList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList() {
    return ListView.builder(
      itemCount: movieList.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Image.network(
              movieList[index]['image']!,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                //in case of image load error
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
        );
      },
    );
  }
}
