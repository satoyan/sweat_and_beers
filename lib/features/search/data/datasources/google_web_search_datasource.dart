import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';

class GoogleWebSearchDataSource {
  Future<List<SearchResult>> search(String query) async {
    try {
      // final response = await default_api.google_web_search(query: query);
      // final results = response['results'] as List<dynamic>;
      // return results.map((result) => SearchResult.fromJson(result)).toList();
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
