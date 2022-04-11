import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/screens/dashboard_screen.dart';
import 'package:flutter_meditech_app/screens/signin_screen.dart';
import 'package:flutter_meditech_app/screens/signup_screen.dart';
import 'package:flutter_meditech_app/screens/splash_screen.dart';
import 'package:flutter_meditech_app/screens/undefined_screen.dart';
import 'package:flutter_meditech_app/screens/reminder_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case ReminderScreenRoute:
      return MaterialPageRoute(builder: (context) => ReminderScreen());

    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());

    case SignInScreenRoute:
      return MaterialPageRoute(builder: (context) => SignInScreen());

    case SignUpScreenRoute:
      return MaterialPageRoute(builder: (context) => SignUpScreen());

    case DashboardScreenRoute:
      return MaterialPageRoute(builder: (context) => DashboardScreen());


    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(
                name: settings.name!,
              ));
  }
}
