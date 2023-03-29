import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_firebase/links/shared_preferences.dart';

import '../data/AppResponse.dart';

class AuthService {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  Future<AppResponse> sendEmailLink({
    required String email,
  }) async {
    print('sendEmailLink[$email]');
    try {
      final actionCodeSettings = firebase_auth.ActionCodeSettings(
          url: 'https://flutterfirebasesample.page.link/iGuj-001',
          handleCodeInApp: true,
          iOSBundleId: 'com.example.flutter_firebase',
          androidPackageName: 'com.example.flutter_firebase',
          androidInstallApp: true,
          androidMinimumVersion: '12');

      print('actionCodeSettings[${actionCodeSettings.asMap()}]');
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      SharedPrefService.instance.setString('passwordLessEmail', email);
      return AppResponse(1, StatusCode.SUCCESS);
    } catch (e, s) {
      return AppResponse(1, StatusCode.ERROR);
    }
  }

  Future<AppResponse> retrieveDynamicLinkAndSignIn({
    required bool fromColdState,
  }) async {
    try {
      String email =
          SharedPrefService.instance.getString('passwordLessEmail') ?? '';
      if (email.isEmpty) {
        return AppResponse(1, StatusCode.ERROR);
      }

      PendingDynamicLinkData? dynamicLinkData;

      Uri? deepLink;
      if (fromColdState) {
        dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
        if (dynamicLinkData != null) {
          deepLink = dynamicLinkData.link;
        }
      } else {
        dynamicLinkData =
            await FirebaseDynamicLinks.instance.getDynamicLink(deepLink);
        deepLink = dynamicLinkData!.link;
      }

      if (deepLink != null) {
        bool validLink =
            _firebaseAuth.isSignInWithEmailLink(deepLink.toString());

        SharedPrefService.instance.setString('passwordLessEmail', '');
        if (validLink) {
          final firebase_auth.UserCredential userCredential =
              await _firebaseAuth.signInWithEmailLink(
            email: email,
            emailLink: deepLink.toString(),
          );
          if (userCredential.user != null) {
            return AppResponse(1, StatusCode.ERROR);
          } else {
            print('userCredential.user is [${userCredential.user}]');
          }
        } else {
          print('Link is not valid');
          return AppResponse(1, StatusCode.ERROR);
        }
      }
    } catch (e, s) {
      return AppResponse(1, StatusCode.ERROR);
    }
    return AppResponse(1, StatusCode.ERROR);
  }
}

mixin FirebaseDynamicLinks {}
