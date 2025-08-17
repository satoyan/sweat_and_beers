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
  Future<List<SearchResult>> searchPlaces(
    String query, {
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    try {
      final results = await _googlePlacesApiDataSource.search(
        query,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      return results;
    } catch (e, s) {
      logger.e('Error in PlaceRepositoryImpl', error: e, stackTrace: s);
      rethrow;
    }
  }
}
