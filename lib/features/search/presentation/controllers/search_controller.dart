import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';

class SearchController extends GetxController {
  final LocationRepository _locationRepository;
  final SearchPlacesUseCase _searchPlacesUseCase;

  SearchController({
    required LocationRepository locationRepository,
    required SearchPlacesUseCase searchPlacesUseCase,
  }) : _locationRepository = locationRepository,
       _searchPlacesUseCase = searchPlacesUseCase;

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
      _currentPosition.value = await _locationRepository.getCurrentLocation();
      if (_currentPosition.value != null) {
        await _searchPlaces();
      }
    } catch (e, s) {
      logger.e(
        'Error fetching location or searching places',
        error: e,
        stackTrace: s,
      );
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _searchPlaces() async {
    if (currentPosition == null) {
      return;
    }

    final query = 'ビール';
    try {
      final results = await _searchPlacesUseCase.call(
        query,
        location: currentPosition!,
        radius: radius.toInt(),
      );
      for (var result in results) {
        if (result.latitude != null && result.longitude != null) {
          result.distance = Geolocator.distanceBetween(
            currentPosition!.latitude,
            currentPosition!.longitude,
            result.latitude!,
            result.longitude!,
          );
        }
      }
      _places.value = results;
    } catch (e, s) {
      logger.e('Error searching places', error: e, stackTrace: s);
      _error.value = e.toString();
    }
  }
}
