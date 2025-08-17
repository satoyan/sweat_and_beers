import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult place;
  final VoidCallback onTap;

  const SearchResultCard({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              _buildPlaceImage(place.photoUrl),
              const SizedBox(height: 12.0),

              // Title
              Text(
                place.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),

              // Open/Closed Status
              if (place.isOpen != null)
                Row(
                  children: [
                    Icon(
                      place.isOpen! ? Icons.check_circle : Icons.cancel,
                      color: place.isOpen! ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      place.isOpen!
                          ? l10n.shopStatusOpen
                          : l10n.shopStatusClosed,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: place.isOpen! ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8.0),

              // Address
              if (place.address != null)
                Text(
                  place.address!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 4.0),

              // Rating
              if (place.rating != null)
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < place.rating!.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8.0),

              // Phone Number
              if (place.phoneNumber != null)
                Text(
                  place.phoneNumber!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              const SizedBox(height: 8.0),

              // Snippet/Summary
              Text(
                place.snippet,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),

              // Distance (Placeholder for now)
              if (place.distance != null)
                Text(
                  place.distance! < 1000
                      ? l10n.distanceMeters(place.distance!.toStringAsFixed(0))
                      : l10n.distanceKilometers(
                          (place.distance! / 1000).toStringAsFixed(2),
                        ),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String buildImageUrl(String photoUrl) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoUrl&key=${dotenv.env['GOOGLE_PLACES_API_KEY']}';
  }

  Widget _buildPlaceImage(String? photoUrl) {
    if (photoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          buildImageUrl(photoUrl),
          fit: BoxFit.cover,
          height: 150,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      );
    } else {
      return Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey,
        ),
      );
    }
  }
}

