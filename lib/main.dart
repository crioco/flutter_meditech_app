import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_meditech_app/route/router.dart' as router;
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:provider/provider.dart';
import 'const/custom_colors.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DataSharedPreferences.init();
    runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediTECH App',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: Colors.grey[200],
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: router.generateRoute,
        initialRoute: SplashScreenRoute,
      ),
    );
  }
}
