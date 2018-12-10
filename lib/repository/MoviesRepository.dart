import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_search/api/API.dart';
import 'package:movies_search/entities/Movie.dart';
import 'package:movies_search/entities/MoviesList.dart';
import 'package:movies_search/repository/Repository.dart';

class MoviesRepository implements Repository<Movie> {

  final _api = API();
  final _cachedPages = HashMap<int, MoviesList>();
  final _pagesInProgress = HashSet<int>();
  final _fetchCompleters = HashMap<int, Completer<Movie>>();

  @override
  Future<Movie> get(int index) async {
    final requestedPage = _buildPageFrom(index);

    if (_cachedPages.containsKey(requestedPage)) {
      final requestedOffset = _buildOffsetFrom(index);
      return _cachedPages[requestedPage].movies[requestedOffset];
    }

    if (_pagesInProgress.add(requestedPage)) {
      _api.fetchPopularMovies(requestedPage).asStream().listen(_handleResponse);
    }

    return _fetchCompleters.putIfAbsent(index, () => Completer<Movie>()).future;
  }

  void _handleResponse(APIPair pair) {
    if (pair.response.statusCode != 200) {
      return;
    }

    final moviesList = MoviesList.fromJson(json.decode(pair.response.body));
    final fetchedPage = moviesList.page;

    _cachedPages[fetchedPage] = moviesList;

    _pagesInProgress.remove(fetchedPage);

    for (var index = _buildFirstIndexOf(fetchedPage); index <= _buildLastIndexOf(fetchedPage); index++) {
      final completer = _fetchCompleters.remove(index);
      if (completer != null) {
        final movieIndexOffset = _buildOffsetFrom(index);
        completer.complete(moviesList.movies[movieIndexOffset]);
      }
    }
  }

  int _buildFirstIndexOf(int page) {
    return _api.pageSize * (page - 1);
  }

  int _buildLastIndexOf(int page) {
    return _api.pageSize * page - 1;
  }

  int _buildPageFrom(int index) {
    return index ~/ _api.pageSize + 1;
  }

  int _buildOffsetFrom(int index) {
    return index % _api.pageSize;
  }

}