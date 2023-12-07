import 'package:final_project/utils/structs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieFetch {

  static Future<List<Movie>> fetchMovieData(int pageNumber) async {
    const String baseUrl = 'https://api.themoviedb.org/3/movie/popular?page=';
    String apiUrl = baseUrl + pageNumber.toString();
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
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}

