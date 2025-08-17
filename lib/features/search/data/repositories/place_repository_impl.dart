import 'package:sweat_and_beers/features/search/data/datasources/google_places_api_datasource.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final GooglePlacesApiDataSource _googlePlacesApiDataSource;

  PlaceRepositoryImpl({
    required GooglePlacesApiDataSource googlePlacesApiDataSource,
  }) : _googlePlacesApiDataSource = googlePlacesApiDataSource;

  @override
  Future<List<SearchResult>> searchPlaces(String query) async {
    try {
      final results = await _googlePlacesApiDataSource.search(query);
      return results;
    } catch (e, s) {
      logger.e('Error in PlaceRepositoryImpl', error: e, stackTrace: s);
      rethrow;
    }
  }
}
