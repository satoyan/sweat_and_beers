import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:sweat_and_beers/app_routes.dart';
import 'package:sweat_and_beers/features/search/presentation/controllers/search_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';
import 'package:sweat_and_beers/features/search/presentation/widgets/search_result_card.dart';
import 'package:flutter/foundation.dart';
import 'package:sweat_and_beers/features/settings/presentation/screens/settings_screen.dart';
import 'package:sweat_and_beers/features/settings/bindings/settings_binding.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Get.to(
                () => const SettingsScreen(),
                binding: SettingsBinding(),
              );

              if (result == true) {
                controller.fetchLocationAndSearch();
              }
            },
          ),
          if (kDebugMode) ...[
            Obx(
              () => Switch(
                value: controller.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  controller.toggleThemeMode();
                },
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.login),
            //   onPressed: () {
            //     Get.toNamed(AppRoutes.signIn);
            //   },
            // ),
          ],
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              // Wrap with RefreshIndicator
              onRefresh: () async {
                await controller.fetchLocationAndSearch();
              },
              child: controller.obx(
                (state) {
                  return ListView.builder(
                    itemCount: state!.length,
                    itemBuilder: (context, index) {
                      final place = state[index];
                      return SearchResultCard(
                        place: place,
                        onTap: () =>
                            Get.toNamed(AppRoutes.detail, arguments: place),
                      );
                    },
                  );
                },
                onLoading: const Center(child: CircularProgressIndicator()),
                onError: (error) => Center(child: Text(l10n.error(error!))),
                onEmpty: Center(child: Text(l10n.pressToSearch)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchLocationAndSearch(),
        child: const Icon(Icons.search),
      ),
    );
  }
}
