// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Sweat & Beers';

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

  @override
  String get shopStatusOpen => '営業中';

  @override
  String get shopStatusClosed => '閉店';

  @override
  String distanceMeters(Object distance) {
    return '距離: $distance m';
  }

  @override
  String distanceKilometers(Object distance) {
    return '距離: $distance km';
  }

  @override
  String get addressLabel => '住所';

  @override
  String get phoneLabel => '電話番号';

  @override
  String get ratingLabel => '評価';

  @override
  String get websiteLabel => 'ウェブサイト';

  @override
  String get openingHoursLabel => '営業時間';

  @override
  String get reviewsLabel => 'レビュー';

  @override
  String get map => '地図';

  @override
  String shopOpensAt(Object time) {
    return '開店時間: $time';
  }

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get searchKeyword => '検索キーワード';

  @override
  String get beer => 'ビール';

  @override
  String get craftBeer => 'クラフトビール';

  @override
  String get permanentlyClosed => '永続的に閉鎖';

  @override
  String get seeAllReviews => 'すべてのレビューを見る';
}
