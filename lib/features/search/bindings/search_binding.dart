import 'package:get/get.dart';
import 'package:sweat_and_beers/features/search/data/datasources/location_datasource.dart';
import 'package:sweat_and_beers/features/search/data/repositories/place_repository_impl.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/location_repository.dart';
import 'package:sweat_and_beers/features/search/domain/repositories/place_repository.dart';
import 'package:sweat_and_beers/features/search/domain/usecases/search_places_usecase.dart';
import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/features/detail/data/datasources/google_places_details_api_datasource.dart';
import 'package:sweat_and_beers/features/detail/data/repositories/place_details_repository_impl.dart';
import 'package:sweat_and_beers/features/detail/domain/usecases/get_place_details_usecase.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<LocationRepository>(() => LocationDataSourceImpl());
    Get.lazyPut<GooglePlacesDetailsApiDataSource>(
      () => GooglePlacesDetailsApiDataSource(),
    );

    // Repositories
    Get.lazyPut<PlaceRepository>(
      () => PlaceRepositoryImpl(googlePlacesApiDataSource: Get.find()),
    );
    Get.lazyPut<PlaceDetailsRepositoryImpl>(
      () => PlaceDetailsRepositoryImpl(Get.find<GooglePlacesDetailsApiDataSource>()),
    );

    // Use Cases
    Get.lazyPut<SearchPlacesUseCase>(
      () => SearchPlacesUseCase(Get.find<PlaceRepository>()),
    );
    Get.lazyPut<GetPlaceDetailsUseCase>(
      () => GetPlaceDetailsUseCase(Get.find<PlaceDetailsRepositoryImpl>()),
    );

    // Controllers
    Get.lazyPut<SearchController>(
      () => SearchController(
        locationRepository: Get.find<LocationRepository>(),
        searchPlacesUseCase: Get.find<SearchPlacesUseCase>(),
        getPlaceDetailsUseCase: Get.find<GetPlaceDetailsUseCase>(),
        settingsController: Get.find<SettingsController>(),
      ),
    );
  }
}
