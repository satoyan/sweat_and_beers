import 'package:get/get.dart';
import 'package:sweat_and_beers/features/search/data/datasources/location_datasource.dart';
import 'package:sweat_and_beers/features/search/data/repositories/place_repository_impl.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';
import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<LocationRepository>(() => LocationDataSourceImpl());

    // Repositories
    Get.lazyPut<PlaceRepository>(
      () => PlaceRepositoryImpl(googlePlacesApiDataSource: Get.find()),
    );

    // Use Cases
    Get.lazyPut<SearchPlacesUseCase>(
      () => SearchPlacesUseCase(Get.find<PlaceRepository>()),
    );

    // Controllers
    Get.lazyPut<SearchController>(
      () => SearchController(
        locationRepository: Get.find<LocationRepository>(),
        searchPlacesUseCase: Get.find<SearchPlacesUseCase>(),
      ),
    );
  }
}
