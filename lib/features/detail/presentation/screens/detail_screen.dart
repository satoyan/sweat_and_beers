
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/detail/presentation/controllers/detail_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GetBuilder<DetailController>(
      init: DetailController(),
      builder: (controller) {
        final place = controller.place;
        if (place == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.detailScreenTitle),
            ),
            body: Center(
              child: Text(l10n.noPlaceSelected),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(place.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () => controller.launchMap(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(place.snippet),
              ],
            ),
          ),
        );
      },
    );
  }
}
