// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sweat and Beers';

  @override
  String get searchScreenTitle => 'Search';

  @override
  String searchRadius(Object radius) {
    return 'Search Radius: ${radius}m';
  }

  @override
  String get pressToSearch => 'Press the search button to find places';

  @override
  String get detailScreenTitle => 'Detail';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get noTitle => 'No title';

  @override
  String get noPlaceSelected => 'No place selected';

  @override
  String get couldNotLaunchMap => 'Could not launch map app';

  @override
  String get signInScreenTitle => 'Sign In';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get signInWithFacebook => 'Sign In with Facebook';

  @override
  String get shopStatusOpen => 'Open Now';

  @override
  String get shopStatusClosed => 'Closed';

  @override
  String distanceMeters(Object distance) {
    return 'Distance: $distance m';
  }

  @override
  String distanceKilometers(Object distance) {
    return 'Distance: $distance km';
  }

  @override
  String get addressLabel => 'Address';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get websiteLabel => 'Website';

  @override
  String get openingHoursLabel => 'Opening Hours';

  @override
  String get reviewsLabel => 'Reviews';

  @override
  String get map => 'Map';
}
