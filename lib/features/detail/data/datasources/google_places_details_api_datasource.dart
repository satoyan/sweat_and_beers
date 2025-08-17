import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';

class GooglePlacesDetailsApiDataSource {
  final GoogleMapsPlaces _places;

  GooglePlacesDetailsApiDataSource()
    : _places = GoogleMapsPlaces(apiKey: dotenv.env['GOOGLE_PLACES_API_KEY']);

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    try {
      final response = await _places.getDetailsByPlaceId(
        placeId,
        language: 'ja',
      );
      if (response.status == 'OK') {
        return response.result;
      } else {
        logger.e(
          'Google Places Details API Error: ${response.errorMessage}',
          error: response.status,
        );
        throw Exception(
          response.errorMessage ?? 'Failed to load place details',
        );
      }
    } catch (e, s) {
      logger.e(
        'Error in GooglePlacesDetailsApiDataSource',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
