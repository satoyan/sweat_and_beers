import 'package:get/get.dart';
import 'package:sweat_and_beers/features/detail/data/datasources/google_places_details_api_datasource.dart';
import 'package:sweat_and_beers/features/detail/data/repositories/place_details_repository_impl.dart';
import 'package:sweat_and_beers/features/detail/domain/usecases/get_place_details_usecase.dart';
import 'package:sweat_and_beers/features/detail/presentation/controllers/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GooglePlacesDetailsApiDataSource>(
      () => GooglePlacesDetailsApiDataSource(),
    );
    Get.lazyPut<PlaceDetailsRepositoryImpl>(
      () => PlaceDetailsRepositoryImpl(
        Get.find<GooglePlacesDetailsApiDataSource>(),
      ),
    );
    Get.lazyPut<GetPlaceDetailsUseCase>(
      () => GetPlaceDetailsUseCase(Get.find<PlaceDetailsRepositoryImpl>()),
    );
    Get.lazyPut<DetailController>(
      () => DetailController(
        getPlaceDetailsUseCase: Get.find<GetPlaceDetailsUseCase>(),
      ),
    );
  }
}
