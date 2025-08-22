import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/core/utils/google_maps_utils.dart';
import 'package:sweat_and_beers/features/detail/presentation/controllers/detail_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sweat_and_beers/core/constants/app_spacing.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.place?.title ?? l10n.detailScreenTitle),
        actions: [
          IconButton(
            icon: Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => controller.launchMap(),
          ),
        ],
      ),
      body: controller.obx(
        (details) {
          if (details != null && details.photos.isNotEmpty) {
            controller.precacheImages(context, details.photos);
          }
          // Display detailed information using 'details' object
          return SingleChildScrollView(
            padding: const EdgeInsets.all(s16),
            child: Column(
              spacing: s16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  details!.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                _PhotoGallery(details: details),
                _ShopInfo(details: details),
                _OpeningHours(details: details),
                _Reviews(details: details),
              ],
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text(l10n.error(error!))),
        onEmpty: Center(child: Text(l10n.noPlaceSelected)),
      ),
    );
  }
}

class _PhotoGallery extends GetView<DetailController> {
  const _PhotoGallery({required this.details});

  final PlaceDetails details;

  @override
  Widget build(BuildContext context) {
    if (details.photos.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(
          height: s200, // Fixed height for the PageView
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: details.photos.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              final photoReference = details.photos[index].photoReference;
              return CachedNetworkImage(
                imageUrl: buildGoogleMapsPhotoUrl(photoReference),
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              );
            },
          ),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(details.photos.length, (index) {
              return Container(
                width: s8,
                height: s8,
                margin: const EdgeInsets.symmetric(
                  horizontal: s4,
                  vertical: s16,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((255 * 0.5).round()),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ShopInfo extends GetView<DetailController> {
  const _ShopInfo({required this.details});

  final PlaceDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      spacing: s8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address
        if (details.formattedAddress != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.addressLabel}: ${details.formattedAddress}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton.icon(
                label: Text(l10n.map),
                icon: Icon(
                  Icons.location_pin,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () =>
                    controller.launchMap(address: details.formattedAddress),
              ),
            ],
          ),

        // Map View
        if (details.geometry != null)
          SizedBox(
            height: 200,
            child: GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  details.geometry!.location.lat,
                  details.geometry!.location.lng,
                ),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(details.placeId),
                  position: LatLng(
                    details.geometry!.location.lat,
                    details.geometry!.location.lng,
                  ),
                ),
              },
            ),
          ),

        // Phone Number
        if (details.formattedPhoneNumber != null)
          InkWell(
            onTap: () => controller.launchPhone(details.formattedPhoneNumber!),
            child: Text(
              '${l10n.phoneLabel}: ${details.formattedPhoneNumber}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

        // Rating
        if (details.rating != null)
          Row(
            spacing: s4,
            children: [
              Text(
                '${l10n.ratingLabel}: ${details.rating}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ...List.generate(5, (index) {
                return Icon(
                  index < details.rating!.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: Theme.of(context).colorScheme.secondary,
                  size: s16,
                );
              }),
            ],
          ),

        // Website
        if (details.website != null)
          InkWell(
            onTap: () => controller.openUrl(details.website!),
            child: Text(
              '${l10n.websiteLabel}: ${details.website}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }
}

class _OpeningHours extends StatelessWidget {
  const _OpeningHours({required this.details});

  final PlaceDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (details.openingHours == null ||
        details.openingHours?.weekdayText == null ||
        details.openingHours!.weekdayText.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.openingHoursLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        ...details.openingHours!.weekdayText.map(
          (text) => Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _Reviews extends GetView<DetailController> {
  const _Reviews({required this.details});

  final PlaceDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (details.reviews.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      spacing: s8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reviewsLabel, style: Theme.of(context).textTheme.labelLarge),
        ...details.reviews.map(
          (review) => Card(
            // Wrap in Card
            margin: const EdgeInsets.symmetric(vertical: s4), // Add margin
            child: Padding(
              padding: const EdgeInsets.all(s12), // Add padding
              child: Column(
                spacing: s8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // For author and stars
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.authorName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium, // Slightly larger font
                      ),
                      Row(
                        // Star rating
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (review.rating.floor())
                                ? Icons.star
                                : Icons.star_border,
                            color: Theme.of(context).colorScheme.secondary,
                            size: s16,
                          );
                        }),
                      ),
                    ],
                  ),
                  Text(
                    review.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (review.relativeTimeDescription
                      case final timeDescription) // Optional: display time
                    Padding(
                      padding: const EdgeInsets.only(top: s4),
                      child: Text(
                        timeDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((255 * 0.6).round()),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (details.url != null)
          TextButton(
            onPressed: () => controller.openUrl(details.url!),
            child: Text(l10n.seeAllReviews),
          ),
      ],
    );
  }
}
