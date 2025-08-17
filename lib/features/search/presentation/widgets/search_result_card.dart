import 'package:flutter/material.dart';
import 'package:sweat_and_beers/core/utils/google_maps_utils.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:sweat_and_beers/core/constants/app_spacing.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult place;
  final VoidCallback onTap;

  const SearchResultCard({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(s12),
        child: Padding(
          padding: const EdgeInsets.all(s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              _buildPlaceImage(context, place.photoUrl),
              const SizedBox(height: s12),

              // Title
              Text(
                place.title,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: s8),

              // Open/Closed Status
              Row(
                children: [
                  Icon(
                    place.isOpen ? Icons.check_circle : Icons.cancel,
                    color: place.isOpen
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    size: s16,
                  ),
                  const SizedBox(width: s4),
                  Text(
                    place.isOpen ? l10n.shopStatusOpen : l10n.shopStatusClosed,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: place.isOpen
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: s8),

              // Address
              if (place.address != null)
                Text(
                  place.address!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: s4),

              // Rating
              if (place.rating != null)
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < place.rating!.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Theme.of(context).colorScheme.secondary,
                      size: s16,
                    );
                  }).toList(),
                ),
              const SizedBox(height: s8),

              // Phone Number
              if (place.phoneNumber != null)
                Text(
                  place.phoneNumber!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: s8),

              // Snippet/Summary
              Text(
                place.snippet,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: s8),

              // Distance (Placeholder for now)
              if (place.distance != null)
                Text(
                  place.distance! < 1000
                      ? l10n.distanceMeters(place.distance!.toStringAsFixed(0))
                      : l10n.distanceKilometers(
                          (place.distance! / 1000).toStringAsFixed(2),
                        ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceImage(BuildContext context, String? photoUrl) {
    if (photoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(s8),
        child: Image.network(
          buildGoogleMapsPhotoUrl(photoUrl),
          fit: BoxFit.cover,
          height: s152,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            height: s152,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.broken_image,
              size: s52,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: s152,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Icon(
          Icons.image_not_supported,
          size: s52,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }
  }
}
