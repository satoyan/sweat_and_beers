import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/search/data/datasources/google_places_api_datasource.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
    Get.lazyPut(() => GooglePlacesApiDataSource(apiKey: apiKey));
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
