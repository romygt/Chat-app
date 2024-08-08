/*import 'package:chatuiapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat app'),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * 15,
              left: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('assets/images/logo.png')),
          Positioned(
              top: mq.height * 15,
              left: mq.width * .5,
              width: mq.width * .9,
              height: mq.height * .07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 223, 255, 178),
                      shape: StadiumBorder(),
                      elevation: 1),
                  onPressed: () {},
                  icon: Image.asset('assets/images/google.png',
                      height: mq.height * .03),
                  label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(text: 'Login with '),
                          TextSpan(
                              text: 'Google',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ]),
                  )))
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
import 'dart:math';
import 'dart:developer' as developer;

import 'package:chatuiapp/main.dart';
import 'package:chatuiapp/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  _handleGoogleBtnClick() {
    _signInWithGoogle().then((user) {
      developer.log('\nUser: ${user?.user}');
      developer.log('\nUserAdditionalInfo: ${user?.additionalUserInfo}');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Home()));
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        print('Sign-In process canceled by the user.');
        return null;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        print('Failed to get Google authentication.');
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In Error: $e');
      // You might want to handle specific exceptions or show a user-friendly error message
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat app'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * 0.1,
            left: mq.width * 0.25,
            width: mq.width * 0.5,
            child: Image.asset('assets/images/logo.png'),
          ),
          Positioned(
            top: mq.height * 0.35,
            left: mq.width * 0.1,
            right: mq.width * 0.1,
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.02),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.04),
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic with username and password here
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                    shape: StadiumBorder(),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: mq.height * 0.04),
                Text('OR',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
                SizedBox(height: mq.height * 0.04),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 223, 255, 178),
                    shape: StadiumBorder(),
                    elevation: 1,
                  ),
                  onPressed: () {
                    // Handle Google sign-in logic here
                    _handleGoogleBtnClick();
                  },
                  icon: Image.asset('assets/images/google.png',
                      height: mq.height * 0.03),
                  label: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
