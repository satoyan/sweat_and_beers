import 'package:google_maps_webservice/places.dart';

abstract class PlaceDetailsRepository {
  Future<PlaceDetails> getPlaceDetails(String placeId);
}
