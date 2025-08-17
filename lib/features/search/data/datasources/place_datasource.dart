import 'package:sweat_and_beers/features/search/data/datasources/google_web_search_datasource.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';

class PlaceDataSourceImpl implements PlaceRepository {
  final GoogleWebSearchDataSource _googleWebSearchDataSource;

  PlaceDataSourceImpl({GoogleWebSearchDataSource? googleWebSearchDataSource})
      : _googleWebSearchDataSource = googleWebSearchDataSource ?? GoogleWebSearchDataSource();

  @override
  Future<List<SearchResult>> searchPlaces(String query) async {
    try {
      final results = await _googleWebSearchDataSource.search(query);
      return results;
    } catch (e) {
      rethrow;
    }
  }
}
