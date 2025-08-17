// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'スウェット＆ビアーズ';

  @override
  String get searchScreenTitle => '検索';

  @override
  String searchRadius(Object radius) {
    return '検索半径: ${radius}m';
  }

  @override
  String get pressToSearch => '検索ボタンを押して場所を探す';

  @override
  String get detailScreenTitle => '詳細';

  @override
  String error(Object error) {
    return 'エラー: $error';
  }

  @override
  String get noTitle => 'タイトルなし';

  @override
  String get noPlaceSelected => '場所が選択されていません';

  @override
  String get couldNotLaunchMap => '地図アプリを起動できませんでした';

  @override
  String get signInScreenTitle => 'サインイン';

  @override
  String get signInWithGoogle => 'Googleでサインイン';

  @override
  String get signInWithFacebook => 'Facebookでサインイン';
}
