import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication Wrapper Service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Expose the authentication state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Email and Password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('SignIn Error: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown SignIn Error: $e');
      return null;
    }
  }

  /// Create Account with Email and Password
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // SECTION 3.1 BLUEPRINT MAPPING
      // After successfully generating the Firebase Auth UID (credential.user!.uid),
      // we will map this newly generated UID to write a fresh record into the 
      // Firestore 'users' collection. 
      // 
      // Future Implementation:
      // await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      //   'uid': credential.user!.uid,
      //   'email': email,
      //   'createdAt': FieldValue.serverTimestamp(),
      //   ...
      // });
      
      return credential;
    } on FirebaseAuthException catch (e) {
      print('SignUp Error: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown SignUp Error: $e');
      return null;
    }
  }

  /// Verify Phone Number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print('Phone Verification Error: $e');
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('SignOut Error: $e');
    }
  }
}
