import 'package:sweat_and_beers/core/config/app_config.dart';

String buildGoogleMapsPhotoUrl(String photoReference) {
  return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${AppConfig.apiKey}';
}
