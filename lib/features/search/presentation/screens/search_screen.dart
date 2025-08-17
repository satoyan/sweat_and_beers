
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:sweat_and_beers/app_routes.dart';
import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GetBuilder<SearchController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Get.toNamed(AppRoutes.signIn);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(l10n.searchRadius(controller.radius.round()))),
              ),
              Obx(
                () => Slider(
                  value: controller.radius,
                  min: 100,
                  max: 5000,
                  divisions: 49,
                  label: controller.radius.round().toString(),
                  onChanged: (value) {
                    controller.onRadiusChanged(value);
                  },
                  onChangeEnd: (value) {
                    controller.onInit(); // Re-fetch results when slider stops moving
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.error.isNotEmpty) {
                    return Center(child: Text(l10n.error(controller.error)));
                  } else if (controller.places.isNotEmpty) {
                    return ListView.builder(
                      itemCount: controller.places.length,
                      itemBuilder: (context, index) {
                        final place = controller.places[index];
                        return ListTile(
                          title: Text(place.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (place.address != null) Text(place.address!),
                              if (place.phoneNumber != null) Text('Phone: ${place.phoneNumber}'),
                              if (place.rating != null) Text('Rating: ${place.rating}'),
                              Text(place.snippet),
                              if (place.distance != null)
                                Text(
                                    'Distance: ${place.distance! < 1000 ? '${place.distance!.toStringAsFixed(0)} m' : '${(place.distance! / 1000).toStringAsFixed(2)} km'}'),
                            ],
                          ),
                          leading: place.photoUrl != null
                              ? Image.network(
                                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place.photoUrl}&key=${dotenv.env['GOOGLE_PLACES_API_KEY']}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                )
                              : null,
                          onTap: () => Get.toNamed(AppRoutes.detail, arguments: place),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(l10n.pressToSearch),
                    );
                  }
                }),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => controller.onInit(),
            child: const Icon(Icons.search),
          ),
        );
      },
    );
  }
}
