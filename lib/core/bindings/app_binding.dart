import 'package:get/get.dart';
import 'package:sweat_and_beers/core/config/app_config.dart';
import 'package:sweat_and_beers/features/search/data/datasources/google_places_api_datasource.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GooglePlacesApiDataSource(apiKey: AppConfig.apiKey));
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
