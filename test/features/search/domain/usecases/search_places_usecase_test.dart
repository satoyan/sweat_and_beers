import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:geolocator/geolocator.dart';

// Mock class for PlaceRepository
class MockPlaceRepository extends Mock implements PlaceRepository {
  @override
  Future<List<SearchResult>> searchPlaces(
    String query, {
    required double latitude,
    required double longitude,
    required int radius,
  }) {
    return super.noSuchMethod(
          Invocation.method(
            #searchPlaces,
            [query],
            {#latitude: latitude, #longitude: longitude, #radius: radius},
          ),
          returnValue: Future.value(<SearchResult>[]),
          returnValueForMissingStub: Future.value(<SearchResult>[]),
        )
        as Future<List<SearchResult>>;
  }
}

void main() {
  late SearchPlacesUseCase useCase;
  late MockPlaceRepository mockPlaceRepository;

  setUp(() {
    mockPlaceRepository = MockPlaceRepository();
    useCase = SearchPlacesUseCase(mockPlaceRepository);
  });

  group('SearchPlacesUseCase', () {
    final tQuery = 'beer';
    final tLocation = Position(
      latitude: 0,
      longitude: 0,
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
    final tRadius = 500;
    final tSearchResults = [
      SearchResult(
        title: 'Test Place',
        link: 'http://test.com',
        snippet: 'A test place',
        latitude: 0,
        longitude: 0,
      ),
    ];

    test(
      'should return a list of SearchResult when the call is successful',
      () async {
        // Arrange
        when(
          mockPlaceRepository.searchPlaces(
            tQuery,
            latitude: tLocation.latitude,
            longitude: tLocation.longitude,
            radius: tRadius,
          ),
        ).thenAnswer((_) => Future.value(tSearchResults));

        // Act
        final result = await useCase.call(
          tQuery,
          location: tLocation,
          radius: tRadius,
        );

        // Assert
        expect(result, tSearchResults);
        verify(
          mockPlaceRepository.searchPlaces(
            tQuery,
            latitude: tLocation.latitude,
            longitude: tLocation.longitude,
            radius: tRadius,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockPlaceRepository);
      },
    );

    test(
      'should throw an exception when the call to repository is unsuccessful',
      () async {
        // Arrange
        when(
          mockPlaceRepository.searchPlaces(
            tQuery,
            latitude: tLocation.latitude,
            longitude: tLocation.longitude,
            radius: tRadius,
          ),
        ).thenThrow(Exception('Failed to search'));

        // Act
        final call = useCase.call(tQuery, location: tLocation, radius: tRadius);

        // Assert
        expect(() => call, throwsA(isA<Exception>()));
        verify(
          mockPlaceRepository.searchPlaces(
            tQuery,
            latitude: tLocation.latitude,
            longitude: tLocation.longitude,
            radius: tRadius,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockPlaceRepository);
      },
    );
  });
}
