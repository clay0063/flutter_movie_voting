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
  static Future<Map<String, dynamic>> startSession(String device) async {
    const String baseUrl = 'https://movie-night-api.onrender.com/start-session';
    String fetchUrl = '$baseUrl?device_id=$device';

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> startSessionResponse =
          jsonDecode(response.body)['data'];
      return _formatStartSession(startSessionResponse);
    } else {
      throw Exception('Failed to start session');
    }
  }

  static Map<String, dynamic> _formatStartSession(dynamic data) {
    return {
      'message': data['message'] as String,
      'sessionId': data['session_id'] as String,
      'code': int.parse(data['code'] as String),
    };
  }

  static Future<Map<String, dynamic>> joinSession(
      String device, int code) async {
    const String baseUrl = 'https://movie-night-api.onrender.com/join-session';
    String fetchUrl = '$baseUrl?device_id=$device&code=$code';
    //code must be sent as int like &code=6052

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> joinSessionResponse =
          jsonDecode(response.body)['data'];

      return _formatJoinSession(joinSessionResponse);
    } else if (response.statusCode == 400) {
      Map<String, dynamic> joinSessionResponse = jsonDecode(response.body);
      Map<String, dynamic> errorFormatting = {
        'message': joinSessionResponse['message'] as String,
        'code': joinSessionResponse['code'] as int,
      };
      return errorFormatting;
    }
    else {
      throw Exception('Failed to start session');
    }
  }

  static Map<String, dynamic> _formatJoinSession(dynamic data) {
    return {
      'message': data['message'] as String,
      'sessionId': data['session_id'] as String,
    };
  }

  static Future<Map<String, dynamic>> voteOnMovie(
      String session, int movie, bool vote) async {
    const String baseUrl = 'https://movie-night-api.onrender.com/vote-movie';
    String fetchUrl = '$baseUrl?session_id=$session&movie_id=$movie&vote=$vote';
    final response = await http.get(Uri.parse(fetchUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> voteSessionResponse =
          jsonDecode(response.body)['data'];
      return _formatVoteData(voteSessionResponse);
    } else {
      throw Exception('Failed to start session');
    }
  }

  static Map<String, dynamic> _formatVoteData(dynamic data) {
    return {
      'message': data['message'] as String,
      'movieId': data['movie_id'] as String,
      'match': data['match'] as bool,
    };
  }
}
