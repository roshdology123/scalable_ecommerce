import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class GoogleAuthDataSource {
  Future<UserModel> signInWithGoogle();
}

class GoogleAuthDataSourceImpl implements GoogleAuthDataSource {
  final GoogleSignIn _googleSignIn;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  GoogleAuthDataSourceImpl({
    required GoogleSignIn googleSignIn,
    required firebase_auth.FirebaseAuth firebaseAuth,
  })  : _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      firebase_auth.User? firebaseUser;

      if (kIsWeb) {
        // Web-specific implementation
        debugPrint('Using Google Sign-In for Web');

        final firebase_auth.GoogleAuthProvider googleProvider =
        firebase_auth.GoogleAuthProvider();

        // Add scopes
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        debugPrint('Google Provider Scopes: ${googleProvider.scopes}');

        try {
          // This will open a popup window for Google Sign-In
          final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithPopup(googleProvider);

          debugPrint('User Credential: ${userCredential.user?.email}');

          if (userCredential.user == null) {
            throw ServerException(message: 'Failed to sign in with Google on Web');
          }

          debugPrint('Successfully signed in: ${userCredential.user?.email}');
          firebaseUser = userCredential.user;

        } on firebase_auth.FirebaseAuthException catch (e) {
          debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
          debugPrint('Full error details: $e');

          // Handle specific error codes
          switch (e.code) {
            case 'popup-blocked':
              throw ServerException(
                  message: 'Popup was blocked. Please allow popups for this site.'
              );
            case 'popup-closed-by-user':
              throw ServerException(
                  message: 'Sign-in was cancelled.'
              );
            case 'unauthorized-domain':
              throw ServerException(
                  message: 'This domain is not authorized for Google Sign-In. Check Firebase Console.'
              );
            default:
              throw ServerException(
                  message: 'Google Sign-In failed: ${e.message}'
              );
          }
        }
      } else {
        // Mobile implementation (iOS/Android)
        // Fixed: Changed authenticate() to signIn()
        final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
        debugPrint('Google User: ${googleUser?.email}');

        if (googleUser == null) {
          throw ServerException(message: 'Google Sign-In aborted');
        }

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        if (googleAuth.idToken == null) {
          throw ServerException(message: 'Failed to get authentication tokens');
        }

        final firebase_auth.AuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        final firebase_auth.UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
        firebaseUser = userCredential.user;
      }

      if (firebaseUser == null) {
        throw ServerException(message: 'Failed to sign in with Firebase');
      }

      // Convert Firebase UID (String) to int for UserModel
      final int userId = firebaseUser.uid.hashCode;

      return UserModel(
        id: userId,
        email: firebaseUser.email ?? '',
        firstName: firebaseUser.displayName?.split(' ').first ?? '',
        lastName: firebaseUser.displayName?.split(' ').last ?? '',
        username: firebaseUser.email?.split('@').first ?? '',
        phone: firebaseUser.phoneNumber,
        avatar: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Outer FirebaseAuthException: ${e.code} - ${e.message}');
      throw ServerException(message: e.message ?? 'Firebase Auth Error');
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Unknown error type: ${e.runtimeType}');
      debugPrint('Unknown error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException(message: 'Unknown error during Google Sign-In: $e');
    }
  }
}