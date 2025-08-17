import 'package:get/get.dart';
import 'package:sweat_and_beers/app_routes.dart';
import 'package:sweat_and_beers/features/auth/presentation/screens/signin_screen.dart';
import 'package:sweat_and_beers/features/detail/presentation/screens/detail_screen.dart';
import 'package:sweat_and_beers/features/detail/bindings/detail_binding.dart';
import 'package:sweat_and_beers/features/search/bindings/search_binding.dart';
import 'package:sweat_and_beers/features/search/presentation/screens/search_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(name: AppRoutes.detail, page: () => const DetailScreen(), binding: DetailBinding()),
    GetPage(name: AppRoutes.signIn, page: () => const SignInScreen()),
  ];
}
