import 'package:movies_search/entities/Movie.dart';

class MoviesList {
  final int page;
  final int totalPages;
  final List<Movie> movies;

  MoviesList.fromJson(Map<String, dynamic> json):
        page = json['page'],
        totalPages = json['total_pages'],
        movies = new List<Movie>.from(json['results'].map((movie) => new Movie.fromJson(movie)));

}