import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart' hide SearchController;

import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';
import 'package:sweat_and_beers/features/detail/domain/usecases/get_place_details_usecase.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';

// Mocks
class MockLocationRepository extends Mock implements LocationRepository {}
class MockSearchPlacesUseCase extends Mock implements SearchPlacesUseCase {}
class MockGetPlaceDetailsUseCase extends Mock implements GetPlaceDetailsUseCase {}
class MockSettingsController extends Mock implements SettingsController {}

void main() {
  late SearchController searchController;
  late MockLocationRepository mockLocationRepository;
  late MockSearchPlacesUseCase mockSearchPlacesUseCase;
  late MockGetPlaceDetailsUseCase mockGetPlaceDetailsUseCase;
  late MockSettingsController mockSettingsController;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    mockSearchPlacesUseCase = MockSearchPlacesUseCase();
    mockGetPlaceDetailsUseCase = MockGetPlaceDetailsUseCase();
    mockSettingsController = MockSettingsController();

    when(mockSettingsController.searchKeyword).thenReturn('ビール');
    when(mockSettingsController.locale).thenReturn(const Locale('ja'));

    searchController = SearchController(
      locationRepository: mockLocationRepository,
      searchPlacesUseCase: mockSearchPlacesUseCase,
      getPlaceDetailsUseCase: mockGetPlaceDetailsUseCase,
      settingsController: mockSettingsController,
    );
  });

  test('should have initial state as empty', () {
    expect(searchController.state, null);
  });
}
