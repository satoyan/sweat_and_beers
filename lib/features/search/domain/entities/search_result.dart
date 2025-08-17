import 'package:google_maps_webservice/places.dart';

class SearchResult {
  final String title;
  final String? address;
  final String? phoneNumber;
  final double? rating;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final String link;
  final String snippet;
  double? distance;
  final bool? isOpen;
  final String? placeId; // New field for place ID

  SearchResult({
    required this.title,
    this.address,
    this.phoneNumber,
    this.rating,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.link,
    required this.snippet,
    this.distance,
    this.isOpen,
    this.placeId,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['name'] as String,
      address: json['formatted_address'] as String?,
      phoneNumber: json['international_phone_number'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      photoUrl: json['photos'] != null && (json['photos'] as List).isNotEmpty
          ? (json['photos'][0] as Photo).photoReference
          : null,
      latitude: (json['geometry'] as Geometry).location.lat,
      longitude: (json['geometry'] as Geometry).location.lng,
      link: json['url'] as String? ?? '',
      snippet: json['vicinity'] as String? ?? '',
      isOpen: (json['opening_hours'] as OpeningHoursDetail?)?.openNow,
      placeId: json['place_id'] as String?,
    );
  }
}
