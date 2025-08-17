import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/features/detail/data/datasources/google_places_details_api_datasource.dart';
import 'package:sweat_and_beers/features/detail/domain/repositories/place_details_repository.dart';

class PlaceDetailsRepositoryImpl implements PlaceDetailsRepository {
  final GooglePlacesDetailsApiDataSource _dataSource;

  PlaceDetailsRepositoryImpl(this._dataSource);

  @override
  Future<PlaceDetails> getPlaceDetails(String placeId) {
    return _dataSource.getPlaceDetails(placeId);
  }
}
