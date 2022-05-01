import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/screens/dashboard_screen.dart';
import 'package:flutter_meditech_app/screens/edit_pill_setting_screen.dart';
import 'package:flutter_meditech_app/screens/pill_settings_screen.dart';
import 'package:flutter_meditech_app/screens/signin_screen.dart';
import 'package:flutter_meditech_app/screens/signup_screen.dart';
import 'package:flutter_meditech_app/screens/splash_screen.dart';
import 'package:flutter_meditech_app/screens/undefined_screen.dart';
import 'package:flutter_meditech_app/screens/reminder_screen.dart';
import 'package:flutter_meditech_app/screens/summary_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());

    case SignInScreenRoute:
      return MaterialPageRoute(builder: (context) => SignInScreen());

    case SignUpScreenRoute:
      return MaterialPageRoute(builder: (context) => SignUpScreen());

    case ReminderScreenRoute:
      return MaterialPageRoute(builder: (context) => ReminderScreen());

    case SummaryScreenRoute:
      return MaterialPageRoute(builder: (context) => SummaryScreen());

    case DashboardScreenRoute:
      return MaterialPageRoute(builder: (context) => DashboardScreen());

    case PillSettingsScreenRoute:
      return MaterialPageRoute(builder: (context) => PillSettingsScreen());

    case EditPillSettingScreenRoute:
      return MaterialPageRoute(builder: (context) => EditPillSettingScreen());

    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(
                name: settings.name!,
              ));
  }
}
