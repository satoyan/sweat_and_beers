import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/core/utils/google_maps_utils.dart';
import 'package:sweat_and_beers/features/detail/presentation/controllers/detail_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sweat_and_beers/core/constants/app_spacing.dart';

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
          // Display detailed information using 'details' object
          return SingleChildScrollView(
            padding: const EdgeInsets.all(s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  details!.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: s16),

                // Photo
                if (details.photos.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: s200, // Fixed height for the PageView
                        child: PageView.builder(
                          controller: controller.pageController,
                          itemCount: details.photos.length,
                          onPageChanged: controller.onPageChanged,
                          itemBuilder: (context, index) {
                            final photoReference =
                                details.photos[index].photoReference;
                            return Image.network(
                              buildGoogleMapsPhotoUrl(photoReference),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(details.photos.length, (
                            index,
                          ) {
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
                                    : Theme.of(context).colorScheme.onSurface
                                          .withAlpha((255 * 0.5).round()),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: s16),

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
                        onPressed: () => controller.launchMap(
                          address: details.formattedAddress,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: s8),

                // Phone Number
                if (details.formattedPhoneNumber != null)
                  InkWell(
                    onTap: () =>
                        controller.launchPhone(details.formattedPhoneNumber!),
                    child: Text(
                      '${l10n.phoneLabel}: ${details.formattedPhoneNumber}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                const SizedBox(height: s8),

                // Rating
                if (details.rating != null)
                  Row(
                    children: [
                      Text(
                        '${l10n.ratingLabel}: ${details.rating}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: s4),
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
                const SizedBox(height: s8),

                // Website
                if (details.website != null)
                  InkWell(
                    onTap: () async {
                      final uri = Uri.parse(details.website!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        Get.snackbar('Error', 'Could not launch website');
                      }
                    },
                    child: Text(
                      '${l10n.websiteLabel}: ${details.website}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                const SizedBox(height: s8),

                // Opening Hours
                if (details.openingHours != null &&
                    details.openingHours?.weekdayText != null &&
                    details.openingHours!.weekdayText.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.openingHoursLabel,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      ...details.openingHours!.weekdayText.map(
                        (text) => Text(
                          text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: s16),

                // Reviews (if available)
                if (details.reviews.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.reviewsLabel,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      ...details.reviews.map(
                        (review) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: s4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${review.authorName} (${review.rating}/5)',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                review.text,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
