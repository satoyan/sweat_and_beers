import 'package:flutter_dotenv/flutter_dotenv.dart';

String buildGoogleMapsPhotoUrl(String photoReference) {
  final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
  return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
}
