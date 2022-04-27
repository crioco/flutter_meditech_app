import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meditech_app/const/custom_styles.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import '../auth_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
      future: AuthHelper.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          User? user = AuthHelper.currentUser();
          if (user != null) {
            Future.delayed(Duration.zero, () async {
              Navigator.pushNamedAndRemoveUntil(context, ReminderScreenRoute,
                  (Route<dynamic> route) => false);
            });
            // GET DATA FROM SHARED PREFERRENCE TO GLOBAL VARIABLES
          } else {
            return _getScreen(context);
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }

  _getScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        children: [
          Flexible(
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: const Image(
                      image: AssetImage(
                        'assets/images/iot_image.png',
                      ),
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Firebase\nCloud Firestore",
                  style: kHeadline,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    "This is a project that connects to hardware devices via Firebase and gets the readings from sensors. For detail, you can check out my channel.",
                    style: kBodyText,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.black12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        SignInScreenRoute, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'GET STARTED',
                    style: kButtonText.copyWith(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
