
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static Future<void> init({FirebaseOptions? options}) async {
    try {
      if (Firebase.apps.isEmpty) {
        if (options != null) {
          await Firebase.initializeApp(options: options);
        } else {
          await Firebase.initializeApp();
        }
      }
    } catch (_) {
      // Already initialized or using default options.
    }
  }

  static Future<String?> currentIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_id_token');
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firebase_id_token');
  }

  static Future<String?> signInWithPhone({
    required String phone,
    required Future<String?> Function() getSmsCode,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final completer = Completer<String?>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: timeout,
      verificationCompleted: (PhoneAuthCredential cred) async {
        final cr = await _auth.signInWithCredential(cred);
        final tok = await cr.user?.getIdToken();
        if (tok != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('firebase_id_token', tok);
        }
        completer.complete(tok);
      },
      verificationFailed: (e) => completer.completeError(e),
      codeSent: (String verificationId, int? resendToken) async {
        final smsCode = await getSmsCode();
        if (smsCode == null) {
          completer.complete(null);
          return;
        }
        final cred = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        final cr = await _auth.signInWithCredential(cred);
        final tok = await cr.user?.getIdToken();
        if (tok != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('firebase_id_token', tok);
        }
        completer.complete(tok);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) completer.complete(null);
      },
    );
    return completer.future;
  }
}
