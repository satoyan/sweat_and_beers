import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/core/config/app_config.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';

class GooglePlacesDetailsApiDataSource {
  final GoogleMapsPlaces _places;

  GooglePlacesDetailsApiDataSource()
    : _places = GoogleMapsPlaces(apiKey: AppConfig.apiKey);

  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    try {
      final response = await _places.getDetailsByPlaceId(
        placeId,
        language: Get.locale?.languageCode ?? 'en',
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
