class Movie {
  final String title;
  final String posterPath;

  Movie.fromJson(Map<String, dynamic> json):
        title = json['title'],
        posterPath = 'https://image.tmdb.org/t/p/w500/${json['poster_path']}';

}