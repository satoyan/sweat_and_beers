import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/detail/presentation/controllers/detail_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

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
            icon: const Icon(Icons.map),
            onPressed: () => controller.launchMap(),
          ),
        ],
      ),
      body: controller.obx(
        (details) {
          // Display detailed information using 'details' object
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  details!.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Photo
                if (details.photos.isNotEmpty)
                  Image.network(
                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${details.photos[0].photoReference}&key=${dotenv.env['GOOGLE_PLACES_API_KEY']}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                const SizedBox(height: 16),

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
                      IconButton(
                        icon: const Icon(Icons.map),
                        onPressed: () => controller.launchMap(address: details.formattedAddress),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

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
                const SizedBox(height: 8),

                // Rating
                if (details.rating != null)
                  Row(
                    children: [
                      Text(
                        '${l10n.ratingLabel}: ${details.rating}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(5, (index) {
                        return Icon(
                          index < details.rating!.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 18,
                        );
                      }),
                    ],
                  ),
                const SizedBox(height: 8),

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
                const SizedBox(height: 8),

                // Opening Hours
                // Opening Hours
                // Opening Hours
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
                      ...(details.openingHours?.weekdayText ?? []).map(
                        (text) => Text(
                          text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

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
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
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
