import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MovieFetch {

  static Future<List<Movie>> fetchMovieData() async {
    const String apiUrl = 'https://api.themoviedb.org/3/movie/popular';
    // const String apiKey = '1020bfd340bfd2db81b004ba4969552d';
    const String headerToken =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMDIwYmZkMzQwYmZkMmRiODFiMDA0YmE0OTY5NTUyZCIsInN1YiI6IjYzOTBkNzNiMWM2MzViMDA4NGRkYzg5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qHWjzmgZvJwQRfN7VDWZPEbciXAzvEhC0youpbKI354';

    Map<String, String> headers = {
      'Authorization': headerToken,
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> movieList = jsonDecode(response.body)['results'];

      return movieList.map((movieData) => Movie.fromJson(movieData)).toList();
      // return movieList.map((dynamic item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Future<List<Map<String, dynamic>>> getMovieList() async {
  //   var originalList = await _fetchData();
  //   return originalList.map((dynamic item) => Map<String, dynamic>.from(item)).toList();
  // }
}

//STRUCTURES
class Movie {
  final String id;
  final String name;
  final String image;
  final String date;
  final String rating;

  const Movie({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
    this.rating = '0.0',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String imageURL = 'https://image.tmdb.org/t/p/w500';
    return Movie(
      id: json['id'].toString(),
      name: json['title'] as String,
      image: imageURL + json['poster_path'],
      date: json['release_date'] as String,
      rating: json['vote_average'].toString(),
    );
  }
}

//random number generator
String randomPageNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(500) + 1;
  return randomNumber.toString();
}

//convert the dynamic lists to string lists
List<String> convertToListString(List<dynamic>? value) {
  if (value != null) {
    return value.map((dynamic element) => element.toString()).toList();
  } else {
    return [];
  }
}
