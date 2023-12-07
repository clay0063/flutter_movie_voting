import 'package:final_project/utils/structs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieFetch {
  static Future<List<Movie>> fetchMovieData(int pageNumber) async {
    const String baseUrl = 'https://api.themoviedb.org/3/movie/popular?page=';
    const String headerToken =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMDIwYmZkMzQwYmZkMmRiODFiMDA0YmE0OTY5NTUyZCIsInN1YiI6IjYzOTBkNzNiMWM2MzViMDA4NGRkYzg5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qHWjzmgZvJwQRfN7VDWZPEbciXAzvEhC0youpbKI354';

    Map<String, String> headers = {
      'Authorization': headerToken,
      'Content-Type': 'application/json',
    };

    String apiUrl = baseUrl + pageNumber.toString();
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> movieList = jsonDecode(response.body)['results'];

      return movieList.map((movieData) => Movie.fromJson(movieData)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}

class SessionFetch {
  static Future<List<Map<String, dynamic>>> startSession(String device) async {
    const String baseUrl = 'https://movie-night-api.onrender.com/start-session';
    String fetchUrl = '$baseUrl?device_id=$device';
    //"returns {data: {String message, String session_id, String code }}"

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      List<dynamic> startSessionResponse = jsonDecode(response.body)['data'];

      return startSessionResponse
          .map((data) => _formatStartSession(data))
          .toList();
    } else {
      throw Exception('Failed to start session');
    }
  }

  static Map<String, dynamic> _formatStartSession(dynamic data) {
    return {
      'message': data['message'] as String,
      'sessionID': data['session_id'] as String,
      'code': int.parse(data['code'] as String),
    };
  }

  Future<List<Map<String, String>>> joinSession(String device, int code) async {
    const String baseUrl = 'https://movie-night-api.onrender.com/join-session';
    String fetchUrl = '$baseUrl?device_id=$device&code=$code';

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      List<dynamic> joinSessionResponse = jsonDecode(response.body)['data'];

      return joinSessionResponse
          .map((data) => _formatJoinSession(data))
          .toList();
    } else {
      throw Exception('Failed to start session');
    }
    //"returns {data: {String message, String session_id }}"
  }

  Map<String, String> _formatJoinSession(dynamic data) {
    return {
      'message': data['message'] as String,
      'sessionID': data['session_id'] as String,
    };
  }

  Future<List<Map<String, dynamic>>> voteOnMovie(
      String session, int movie, bool vote) async {
    const String baseUrl = 'https://movie-night-api.onrender.com/vote-movie';
    String fetchUrl = '$baseUrl?session_id=$session&movie_id=$movie&vote=$vote';

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      List<dynamic> voteSessionResponse = jsonDecode(response.body)['data'];

      return voteSessionResponse.map((data) => _formatVoteData(data)).toList();
    } else {
      throw Exception('Failed to start session');
    }
    //"returns {data: {String message, int movie_id, Boolean match}}"
  }

  Map<String, dynamic> _formatVoteData(dynamic data) {
    return {
      'message': data['message'] as String,
      'movieID': data['movie_id'] as int,
      'match': data['match'] as bool,
    };
  }
}
