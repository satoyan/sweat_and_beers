import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:sweat_and_beers/features/detail/domain/usecases/get_place_details_usecase.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchController extends GetxController
    with StateMixin<List<SearchResult>> {
  final LocationRepository _locationRepository;
  final SearchPlacesUseCase _searchPlacesUseCase;
  final SettingsController _settingsController;

  SearchController({
    required LocationRepository locationRepository,
    required SearchPlacesUseCase searchPlacesUseCase,
    required GetPlaceDetailsUseCase getPlaceDetailsUseCase,
    required SettingsController settingsController,
  }) : _locationRepository = locationRepository,
       _searchPlacesUseCase = searchPlacesUseCase,
       _settingsController = settingsController;

  final Rx<Position?> _currentPosition = Rx<Position?>(null);

  Position? get currentPosition => _currentPosition.value;

  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  void toggleThemeMode() {
    _themeMode.value = _themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    Get.changeThemeMode(_themeMode.value);
  }

  @override
  void onInit() {
    super.onInit();
    fetchLocationAndSearch();
  }

  Future<void> fetchLocationAndSearch() async {
    change(null, status: RxStatus.loading());
    try {
      _currentPosition.value = await _locationRepository.getCurrentLocation();
      if (_currentPosition.value != null) {
        await _searchPlaces();
      } else {
        change([], status: RxStatus.empty());
      }
    } catch (e, s) {
      logger.e(
        'Error fetching location or searching places',
        error: e,
        stackTrace: s,
      );
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> _searchPlaces() async {
    if (currentPosition == null) {
      change([], status: RxStatus.empty());
      return;
    }

    final query = _settingsController.searchKeyword;
    try {
      final results = await _searchPlacesUseCase.call(
        query,
        location: currentPosition!,
        radius: _settingsController.radius.toInt(),
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
      if (results.isEmpty) {
        final lat = currentPosition!.latitude;
        final lng = currentPosition!.longitude;
        final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          Get.snackbar('Error', 'Could not launch map');
        }
        change([], status: RxStatus.empty());
      } else {
        results.sort((a, b) => a.distance!.compareTo(b.distance!));
        change(results, status: RxStatus.success());
      }
    } catch (e, s) {
      logger.e('Error searching places', error: e, stackTrace: s);
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
