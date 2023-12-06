import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

// Future<List<TCGCard>>
void fetchData() async {
  const String apiUrl = 'https://api.themoviedb.org/3/movie/popular';
  // const String apiKey = '1020bfd340bfd2db81b004ba4969552d';
  const String headerToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMDIwYmZkMzQwYmZkMmRiODFiMDA0YmE0OTY5NTUyZCIsInN1YiI6IjYzOTBkNzNiMWM2MzViMDA4NGRkYzg5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qHWjzmgZvJwQRfN7VDWZPEbciXAzvEhC0youpbKI354';

  Map<String, String> headers = {
    'Authorization': headerToken,
    'Content-Type': 'application/json',
  };

  // final String apiUrlWithParams = '$apiUrl?page=${randomPageNumber()}&pageSize=20';

  final response = await http.get(Uri.parse(apiUrl), headers: headers);

  if (response.statusCode == 200) {
    // List<dynamic> cardDataList = jsonDecode(response.body)['data']; 
    // return cardDataList
    //     .map((cardData) => TCGCard.fromJson(cardData))
    //     .toList();
    print(response.body);
  } else {
    throw Exception('Failed to fetch data');
  }
}


//card class set-up
class TCGCard {
  final String id;
  final String name;
  final String hp;
  final String flavorText;
  final List<String> types;
  final String image;

  const TCGCard({
    required this.id,
    required this.name,
    this.hp = '0',
    this.flavorText = '',
    this.types = const ['Basic'],
    this.image = '',
  });

  factory TCGCard.fromJson(Map<String, dynamic> json) {
    return TCGCard(
      id: json['id'] as String? ?? 'No ID',
      name: json['name'] as String? ?? 'No Name',
      hp: json['hp'] as String? ?? '0',
      flavorText: json['flavorText'] as String? ?? '',
      types: convertToListString(json['types']),
      image: json['images']['small'] as String? ?? '',
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