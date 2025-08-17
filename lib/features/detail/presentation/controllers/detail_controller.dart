
import 'package:get/get.dart';
import 'package:sweat_and_beers/features/search/domain/entities/search_result.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sweat_and_beers/core/utils/logger.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sweat_and_beers/features/detail/domain/usecases/get_place_details_usecase.dart';

class DetailController extends GetxController with StateMixin<PlaceDetails> {
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;

  DetailController({required GetPlaceDetailsUseCase getPlaceDetailsUseCase})
      : _getPlaceDetailsUseCase = getPlaceDetailsUseCase;

  final _place = Rx<SearchResult?>(null);
  SearchResult? get place => _place.value;

  @override
  void onInit() {
    super.onInit();
    _place.value = Get.arguments as SearchResult?;
    if (_place.value != null && _place.value!.placeId != null) {
      _fetchPlaceDetails(_place.value!.placeId!);
    } else {
      change(null, status: RxStatus.error('No place selected or place ID missing'));
    }
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    change(null, status: RxStatus.loading());
    try {
      final details = await _getPlaceDetailsUseCase.call(placeId);
      change(details, status: RxStatus.success());
    } catch (e, s) {
      logger.e('Error fetching place details', error: e, stackTrace: s);
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> launchMap() async {
    final address = state?.formattedAddress ?? place?.address ?? '';
    if (address.isNotEmpty) {
      final query = Uri.encodeComponent(address);
      final url = 'https://www.google.com/maps/search/?api=1&query=$query';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        logger.e('Could not launch map', error: 'Could not launch map');
        Get.snackbar('Error', 'Could not launch map');
      }
    }
  }
}
