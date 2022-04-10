import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meditech_app/auth_helper.dart';
import 'package:flutter_meditech_app/const/custom_styles.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/my_password_field.dart';
import 'package:flutter_meditech_app/widgets/my_text_button.dart';
import 'package:flutter_meditech_app/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordVisibility = true;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    _firstname.dispose();
    _lastname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 30),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Image(
                              width: 24,
                              color: Colors.white,
                              image: AssetImage('assets/images/back_arrow.png'),
                            ),
                          ),
                          const Text(
                            "Register",
                            style: kHeadline,
                          ),
                          const Text(
                            "Create new account to get started.",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          MyTextField(
                            hintText: 'First Name',
                            inputType: TextInputType.name,
                            textEditingController: _firstname,
                          ),
                          MyTextField(
                            hintText: 'Last Name',
                            inputType: TextInputType.name,
                            textEditingController: _lastname,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                            textEditingController: _email,
                          ),
                          MyPasswordField(
                            hintText: 'Password',
                            textEditingController: _password,
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                          ),
                          MyPasswordField(
                            hintText: 'Password Confirm',
                            textEditingController: _passwordConfirm,
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                SignInScreenRoute,
                                (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "Sign In",
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: _signUp,
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signUp() async {
    var email = _email.text.trim();
    var pw = _password.text.trim();
    var pwConfirm = _passwordConfirm.text.trim();
    var firstname = _firstname.text.trim();
    var lastname = _lastname.text.trim();

    if (email.isEmpty || pw.isEmpty || firstname.isEmpty || lastname.isEmpty) {
      await showOkAlertDialog(
        context: context,
        message: 'Fill all Textboxes',
      );
      return;
    } else if (pw != pwConfirm) {
      await showOkAlertDialog(
        context: context,
        message: 'Passwords entered does not match',
      );
      return;
    }

    var obj = await AuthHelper.signUp(email, pw);

    if (obj is User) {
      addUser(firstname: firstname, lastname: lastname, user: obj);
      Navigator.pushNamedAndRemoveUntil(
          context, DashboardScreenRoute, (Route<dynamic> route) => false);
      dispose();
    } else {
      await showOkAlertDialog(
        context: context,
        message: obj,
      );
    }
  }

  void addUser({required String firstname, required String lastname, required User user}) async{
    DocumentReference users = FirebaseFirestore.instance.collection('Users').doc(user.uid);
    await users
    .set({'firstname': firstname, 'lastname': lastname})
    .then((value) => print('User Added'))
    .catchError((error)=>{print('Failed to add user. $error')});
  }
}
