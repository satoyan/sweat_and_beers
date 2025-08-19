import 'package:mockito/annotations.dart';
import 'package:sweat_and_beers/features/detail/domain/usecases/get_place_details_usecase.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';

export './mocks.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationRepository>(),
  MockSpec<SearchPlacesUseCase>(),
  MockSpec<GetPlaceDetailsUseCase>(),
])
void main() {}
