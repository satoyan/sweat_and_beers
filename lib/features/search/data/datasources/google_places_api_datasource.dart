import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';

class GooglePlacesApiDataSource {
  final GoogleMapsPlaces _places;

  GooglePlacesApiDataSource({required String? apiKey})
      : _places = GoogleMapsPlaces(apiKey: apiKey);

  Future<List<SearchResult>> search(String query, {double? latitude, double? longitude, int? radius}) async {
    PlacesSearchResponse response;
    try {
      if (latitude != null && longitude != null) {
        response = await _places.searchNearbyWithRadius(
          Location(lat: latitude, lng: longitude),
          radius ?? 500, // Default radius if not provided
          keyword: query,
          type: 'restaurant', // You can refine this type based on your needs
        );
      } else {
        response = await _places.searchByText(query);
      }

      if (response.status == 'OK') {
        return response.results.map((result) => SearchResult.fromJson(result.toJson())).toList();
      } else {
        logger.e('Google Places API Error: ${response.errorMessage}');
        throw Exception(response.errorMessage ?? 'Failed to load places');
      }
    } catch (e, s) {
      logger.e('Error in GooglePlacesApiDataSource', error: e, stackTrace: s);
      rethrow;
    }
  }
}
