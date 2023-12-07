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
      rating: json['vote_average'].toStringAsFixed(2),
    );
  }
}