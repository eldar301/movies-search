import 'package:http/http.dart' as http;

class APIPair{
  final int page;
  final http.Response response;
  APIPair(this.page, this.response);
}

class API {

  final String _baseURL = 'api.themoviedb.org';
  final String _apiKey = 'c10c04cb3d4049b358a035c060a8502c';
  final String _apiVersion = '3';
  final int pageSize = 20;

  Future<APIPair> fetchPopularMovies(int page) async {
    final response = await _sendRequest('movie/popular', {'page': '$page'});
    return APIPair(page, response);
  }

  Future<http.Response> _sendRequest(String path, Map<String, String> params) {
    params.putIfAbsent('api_key', () => _apiKey);
    params.putIfAbsent('language', () => 'enUS');
    return http.get(Uri.http(_baseURL, '$_apiVersion/$path', params));
  }

}