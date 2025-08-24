import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const String _languageCodeKey = 'language_code';
  static const String _searchKeywordKey = 'search_keyword';
  static const String _radiusKey = 'radius';

  final Rx<Locale> _locale = (Get.locale ?? const Locale('ja')).obs;
  Locale get locale => _locale.value;

  final RxString _searchKeyword = 'クラフトビール'.obs; // Default to クラフトビール
  String get searchKeyword => _searchKeyword.value;

  final RxDouble _radius = 500.0.obs;
  double get radius => _radius.value;

  final RxBool settingsChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
    _loadSearchKeyword();
    _loadRadius();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null) {
      _locale.value = Locale(languageCode);
      Get.updateLocale(_locale.value);
    }
  }

  Future<void> changeLocale(String languageCode) async {
    if (_locale.value.languageCode != languageCode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, languageCode);
      _locale.value = Locale(languageCode);
      Get.updateLocale(_locale.value);
      settingsChanged.value = true;
    }
  }

  Future<void> _loadSearchKeyword() async {
    final prefs = await SharedPreferences.getInstance();
    final keyword = prefs.getString(_searchKeywordKey);
    if (keyword != null) {
      _searchKeyword.value = keyword;
    }
  }

  Future<void> changeSearchKeyword(String keyword) async {
    if (_searchKeyword.value != keyword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_searchKeywordKey, keyword);
      _searchKeyword.value = keyword;
      settingsChanged.value = true;
    }
  }

  Future<void> _loadRadius() async {
    final prefs = await SharedPreferences.getInstance();
    final radius = prefs.getDouble(_radiusKey);
    if (radius != null) {
      _radius.value = radius;
    }
  }

  Future<void> changeRadius(double value) async {
    if (_radius.value != value) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_radiusKey, value);
      _radius.value = value;
      settingsChanged.value = true;
    }
  }
}
