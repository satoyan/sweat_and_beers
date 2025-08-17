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
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['name'] as String,
      address: json['formatted_address'] as String?,
      phoneNumber: json['international_phone_number'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      photoUrl: json['photos'] != null && (json['photos'] as List).isNotEmpty
          ? (json['photos'][0]['photo_reference'] as String)
          : null,
      latitude: json['geometry']?['location']?['lat'] as double?,
      longitude: json['geometry']?['location']?['lng'] as double?,
      link: json['url'] as String? ?? '',
      snippet: json['vicinity'] as String? ?? '',
    );
  }
}
