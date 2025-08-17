
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/detail/presentation/screens/detail_screen.dart';
import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/features/auth/presentation/screens/signin_screen.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GetBuilder<SearchController>(
      init: SearchController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Get.to(() => const SignInScreen());
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
                          subtitle: Text(place.snippet),
                          onTap: () => Get.to(() => const DetailScreen(), arguments: place),
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
