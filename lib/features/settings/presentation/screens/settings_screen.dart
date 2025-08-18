import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/settings/presentation/controllers/settings_controller.dart';
import 'package:sweat_and_beers/generated/l10n/app_localizations.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: controller.settingsChanged.value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.settingsChanged.value = false;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(l10n.language),
              trailing: Obx(
                () => DropdownButton<String>(
                  value: controller.locale.languageCode,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeLocale(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ja', child: Text('日本語')),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(l10n.searchKeyword),
              trailing: Obx(
                () => DropdownButton<String>(
                  value: controller.searchKeyword,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeSearchKeyword(newValue);
                    }
                  },
                  items: [
                    DropdownMenuItem(value: 'ビール', child: Text(l10n.beer)),
                    DropdownMenuItem(
                      value: 'クラフトビール',
                      child: Text(l10n.craftBeer),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
