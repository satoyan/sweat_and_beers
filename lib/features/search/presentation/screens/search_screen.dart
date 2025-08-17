import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:sweat_and_beers/app_routes.dart';
import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:sweat_and_beers/features/search/presentation/widgets/search_result_card.dart';
import 'package:flutter/foundation.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (kDebugMode)
            Obx(
              () => Switch(
                value: controller.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  controller.toggleThemeMode();
                },
              ),
            ),
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
            child: controller.obx(
              (state) { // 'state' here is the List<SearchResult>
                return ListView.builder(
                  itemCount: state!.length,
                  itemBuilder: (context, index) {
                    final place = state[index];
                    return SearchResultCard(
                      place: place,
                      onTap: () => Get.toNamed(AppRoutes.detail, arguments: place),
                    );
                  },
                );
              },
              onLoading: const Center(child: CircularProgressIndicator()),
              onError: (error) => Center(child: Text(l10n.error(error!))), 
              onEmpty: Center(child: Text(l10n.pressToSearch)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onInit(),
        child: const Icon(Icons.search),
      ),
    );
  }
}