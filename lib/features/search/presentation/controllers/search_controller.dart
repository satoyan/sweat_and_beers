
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/features/search/data/datasources/location_datasource.dart';
import 'package:sweat_and_beers/features/search/data/datasources/place_datasource.dart';

class SearchController extends GetxController {
  final LocationRepository _locationService;
  final PlaceRepository _placeService;

  SearchController({
    LocationRepository? locationRepository,
    PlaceRepository? placeRepository,
  })  : _locationService = locationRepository ?? LocationDataSourceImpl(),
        _placeService = placeRepository ?? PlaceDataSourceImpl();

  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  Position? get currentPosition => _currentPosition.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _error = ''.obs;
  String get error => _error.value;

  final _places = <SearchResult>[].obs;
  List<SearchResult> get places => _places;

  final _radius = 500.0.obs;
  double get radius => _radius.value;

  @override
  void onInit() {
    super.onInit();
    _fetchLocationAndSearch();
  }

  void onRadiusChanged(double value) {
    _radius.value = value;
  }

  Future<void> _fetchLocationAndSearch() async {
    _isLoading.value = true;
    _error.value = '';
    try {
      _currentPosition.value = await _locationService.getCurrentLocation();
      if (_currentPosition.value != null) {
        await _searchPlaces();
      }
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _searchPlaces() async {
    if (currentPosition == null) return;

    final query =
        'beers within ${radius}m near me lat:${currentPosition!.latitude} lng:${currentPosition!.longitude} address phone number website';
    try {
      final results = await _placeService.searchPlaces(query);
      _places.value = results;
    } catch (e) {
      _error.value = e.toString();
    }
  }
}
