import 'package:geolocator/geolocator.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';

class SearchPlacesUseCase {
  final PlaceRepository _placeRepository;

  SearchPlacesUseCase(this._placeRepository);

  Future<List<SearchResult>> call(String query, {Position? location, int? radius}) async {
    return await _placeRepository.searchPlaces(query);
  }
}
