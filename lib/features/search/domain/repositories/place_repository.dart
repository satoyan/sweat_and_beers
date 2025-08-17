import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';

abstract class PlaceRepository {
  Future<List<SearchResult>> searchPlaces(String query, {required double latitude, required double longitude, required int radius});
}
