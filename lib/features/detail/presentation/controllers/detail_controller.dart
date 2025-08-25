import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  final _currentPage = 0.obs;
  int get currentPage => _currentPage.value;

  late PageController _pageController;
  PageController get pageController => _pageController;

  late GoogleMapController mapController;

  @override
  void onInit() {
    super.onInit();
    _place.value = Get.arguments as SearchResult?;
    _pageController = PageController();
    if (_place.value != null && _place.value!.placeId != null) {
      _fetchPlaceDetails(_place.value!.placeId!);
    } else {
      change(
        null,
        status: RxStatus.error('No place selected or place ID missing'),
      );
    }
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    _currentPage.value = index;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    change(null, status: RxStatus.loading());
    try {
      final details = await _getPlaceDetailsUseCase.call(placeId);
      logger.d(details.toJson());

      change(details, status: RxStatus.success());
    } catch (e, s) {
      logger.e('Error fetching place details', error: e, stackTrace: s);
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> launchMap({String? address}) async {
    final mapAddress =
        address ?? state?.formattedAddress ?? place?.address ?? '';
    Location? coords;
    if (state?.geometry?.location != null) {
      coords = state!.geometry!.location;
    } else if (place?.latitude != null && place?.longitude != null) {
      coords = Location(lat: place!.latitude!, lng: place!.longitude!);
    }

    if (coords != null) {
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showMarker(
        coords: Coords(coords.lat, coords.lng),
        title: mapAddress,
      );
    } else if (mapAddress.isNotEmpty) {
      // Fallback to the previous implementation if no coords are available
      final query = Uri.encodeComponent(mapAddress);
      if (Platform.isIOS) {
        final url = 'maps://?q=$query';
        await openUrl(url);
      } else {
        final url = 'https://www.google.com/maps/search/?api=1&query=$query';
        await openUrl(url);
      }
    }
  }

  Future<void> launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: "tel", path: phoneNumber);
    await openUrl(uri.toString());
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      logger.e('Could not launch URL', error: 'Could not launch $url');
      Get.snackbar('Error', 'Could not launch URL');
    }
  }
}
