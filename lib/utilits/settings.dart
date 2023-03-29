 import 'package:firebase_auth/firebase_auth.dart';

class getAcs {
  
  static final ActionCodeSettings acs = ActionCodeSettings(
    url: 'https://flutterfirebasesample.page.link/iGuj?email',
    handleCodeInApp: true,
    iOSBundleId: 'com.example.flutter_firebase',
    androidPackageName: 'com.example.flutter_firebase',
    androidInstallApp: true,
    androidMinimumVersion: '12');



}