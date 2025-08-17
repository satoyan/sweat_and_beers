import 'package:sweat_and_beers/api/google_web_search.dart';
import 'package:sweat_and_beers/models/search_result.dart';

class PlaceService {
  final GoogleWebSearch _googleWebSearch;

  PlaceService({GoogleWebSearch? googleWebSearch})
      : _googleWebSearch = googleWebSearch ?? GoogleWebSearch();

  Future<List<SearchResult>> searchPlaces(String query) async {
    try {
      final results = await _googleWebSearch.search(query);
      return results;
    } catch (e) {
      rethrow;
    }
  }
}
