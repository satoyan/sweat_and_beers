import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart' hide SearchController;

import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';

import '../../../../mocks.dart';

void main() {
  late SearchController searchController;
  late MockLocationRepository mockLocationRepository;
  late MockSearchPlacesUseCase mockSearchPlacesUseCase;
  late MockGetPlaceDetailsUseCase mockGetPlaceDetailsUseCase;
  late SettingsController settingsController; // Use real instance

  final tPosition = Position(
    latitude: 35.681236,
    longitude: 139.767125,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    isMocked: false,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
  final tSearchResults = [
    SearchResult(
      title: 'Test Place',
      link: 'http://test.com',
      snippet: 'A test place',
      latitude: 0,
      longitude: 0,
    ),
  ];

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    mockSearchPlacesUseCase = MockSearchPlacesUseCase();
    mockGetPlaceDetailsUseCase = MockGetPlaceDetailsUseCase();
    settingsController = SettingsController(); // Instantiate real controller

    searchController = SearchController(
      locationRepository: mockLocationRepository,
      searchPlacesUseCase: mockSearchPlacesUseCase,
      getPlaceDetailsUseCase: mockGetPlaceDetailsUseCase,
      settingsController: settingsController,
    );
  });

  group('SearchController', () {
    test('should fetch location and search places on init', () async {
      // Arrange
      when(
        mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => tPosition);
      when(mockSearchPlacesUseCase.call(
        any,
        location: anyNamed('location'),
        radius: anyNamed('radius'),
      )).thenAnswer((_) async => tSearchResults);

      // Act
      await searchController.fetchLocationAndSearch();

      // Assert
      expect(searchController.currentPosition, tPosition);
      expect(searchController.state, tSearchResults);
      verify(mockLocationRepository.getCurrentLocation()).called(1);
      verify(mockSearchPlacesUseCase.call(
        any,
        location: anyNamed('location'),
        radius: anyNamed('radius'),
      )).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
      verifyNoMoreInteractions(mockSearchPlacesUseCase);
    });

    test('should handle error when fetching location fails', () async {
      // Arrange
      when(
        mockLocationRepository.getCurrentLocation(),
      ).thenThrow(Exception('Location error'));

      // Act
      await searchController.fetchLocationAndSearch();

      // Assert
      expect(searchController.currentPosition, null);
      expect(searchController.state, null); // State should be error
      expect(searchController.status.isError, true);
      verify(mockLocationRepository.getCurrentLocation()).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
      verifyZeroInteractions(mockSearchPlacesUseCase);
    });

    test('should handle error when searching places fails', () async {
      // Arrange
      when(
        mockLocationRepository.getCurrentLocation(),
      ).thenAnswer((_) async => tPosition);
      when(
        mockSearchPlacesUseCase.call(
          any,
          location: anyNamed('location'),
          radius: anyNamed('radius'),
        ),
      ).thenThrow(Exception('Search error'));

      // Act
      await searchController.fetchLocationAndSearch();

      // Assert
      expect(searchController.currentPosition, tPosition);
      expect(searchController.state, null); // State should be error
      expect(searchController.status.isError, true);
      verify(mockLocationRepository.getCurrentLocation()).called(1);
      verify(
        mockSearchPlacesUseCase.call(
          any,
          location: anyNamed('location'),
          radius: anyNamed('radius'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLocationRepository);
      verifyNoMoreInteractions(mockSearchPlacesUseCase);
    });

    test('onRadiusChanged should update radius', () {
      // Arrange
      final newRadius = 1000.0;

      // Act
      searchController.onRadiusChanged(newRadius);

      // Assert
      expect(searchController.radius, newRadius);
    });

    test('toggleThemeMode should switch theme mode', () {
      // Arrange
      searchController.toggleThemeMode(); // Initial call to set to dark
      expect(searchController.themeMode, ThemeMode.light);

      // Act
      searchController.toggleThemeMode(); // Switch to light
      expect(searchController.themeMode, ThemeMode.dark);
    });
  });
}
