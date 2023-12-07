import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MovieFetch {

  static Future<List<Map<String, String>>> fetchMovieData() async {
    const String apiUrl = 'https://api.themoviedb.org/3/movie/popular';
    const String headerToken =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMDIwYmZkMzQwYmZkMmRiODFiMDA0YmE0OTY5NTUyZCIsInN1YiI6IjYzOTBkNzNiMWM2MzViMDA4NGRkYzg5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qHWjzmgZvJwQRfN7VDWZPEbciXAzvEhC0youpbKI354';

    Map<String, String> headers = {
      'Authorization': headerToken,
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> movieList = jsonDecode(response.body)['results'];

      return movieList.map((movieData) => _mapMovieData(movieData)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Map<String, String> _mapMovieData(dynamic movieData) {
    String imageURL = 'https://image.tmdb.org/t/p/w500';
    return {
      'id': movieData['id'].toString(),
      'name': movieData['title'] as String,
      'image': imageURL + movieData['poster_path'],
      'date': movieData['release_date'] as String,
      'rating': movieData['vote_average'].toString(),
    };
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
