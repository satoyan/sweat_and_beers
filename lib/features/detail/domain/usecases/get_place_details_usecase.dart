import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/features/detail/domain/repositories/place_details_repository.dart';

class GetPlaceDetailsUseCase {
  final PlaceDetailsRepository _repository;

  GetPlaceDetailsUseCase(this._repository);

  Future<PlaceDetails> call(String placeId) {
    return _repository.getPlaceDetails(placeId);
  }
}
