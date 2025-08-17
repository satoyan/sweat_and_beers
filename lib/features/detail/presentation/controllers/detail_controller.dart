
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailController extends GetxController {
  final _place = Rx<SearchResult?>(null);
  SearchResult? get place => _place.value;

  @override
  void onInit() {
    super.onInit();
    _place.value = Get.arguments as SearchResult?;
  }

  Future<void> launchMap() async {
    final address = place?.snippet ?? '';
    if (address.isNotEmpty) {
      final query = Uri.encodeComponent(address);
      final url = 'https://www.google.com/maps/search/?api=1&query=$query';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('Error', 'Could not launch map');
      }
    }
  }
}
