import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/core/constants/app_constants.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';

class GooglePlacesApiDataSource {
  final GoogleMapsPlaces _places;

  GooglePlacesApiDataSource({required String? apiKey})
    : _places = GoogleMapsPlaces(apiKey: apiKey);

  Future<List<SearchResult>> search(
    String query, {
    required double latitude,
    required double longitude,
    required int radius,
  }) async {
    PlacesSearchResponse response;
    try {
      response = await _places.searchNearbyWithRadius(
        Location(lat: latitude, lng: longitude),
        radius,
        keyword: query,
        type: AppConstants.placeTypes,
        language: AppConstants.defaultLang,
      );

      if (response.status == 'OK') {
        return response.results
            .map((result) => SearchResult.fromJson(result.toJson()))
            .toList();
      } else {
        logger.e(
          'Google Places API Error: ${response.errorMessage}',
          error: response.status,
        );
        throw Exception(response.errorMessage ?? 'Failed to load places');
      }
    } catch (e, s) {
      logger.e('Error in GooglePlacesApiDataSource', error: e, stackTrace: s);
      rethrow;
    }
  }
}
