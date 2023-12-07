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
  late Future<List<Movie>> movieList;

  @override
  void initState() {
    super.initState();
    movieList = MovieFetch.fetchMovieData();
    // _getMovieList();
  }

  // Future<void> _getMovieList() async {
  //   List<Movie> list = await MovieFetch.fetchMovieData();

  //   setState(() {
  //     movieList = list;
  //   });
  // }

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
            child: FutureBuilder<List<Movie>>(
              future: movieList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Movie movie = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: Column(
                            children: [
                              Image.network(
                                movie.image,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  //in case of image load error
                                  return const Placeholder(
                                    fallbackHeight: 200,
                                    fallbackWidth: 100,
                                  );
                                },
                              ),
                              Text(movie.name),
                              Text(movie.date),
                              Text(movie.rating),
                              Text(movie.id),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}


// Image.network(
//   movie.image,
//   height: 200,
//   fit: BoxFit.contain,
//   errorBuilder: (context, error, stackTrace) {
//     //in case of image load error
//     return const Placeholder(
//       fallbackHeight: 200,
//       fallbackWidth: 100,
//     );
//   },
// ),