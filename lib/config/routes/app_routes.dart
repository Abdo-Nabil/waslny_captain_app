import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/features/on_boarding/on_boarding_screen.dart';

import '../../resources/font_manager.dart';
import '../../resources/app_strings.dart';

class Routes {
  static const String onBoardingRoute = '/onBoarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      //
      case Routes.onBoardingRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const OnBoardingScreen();
          },
        );
      //
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) {
            return Container();
          },
        );
      //
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: ((context) => Scaffold(
            body: Center(
              child: Text(
                AppStrings.notFoundPage.tr(context),
                style: const TextStyle(
                  fontSize: FontSize.s24,
                ),
              ),
            ),
          )),
    );
  }
}
