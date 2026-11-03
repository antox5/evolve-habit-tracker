import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_3/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loading = false;
  String? error;

  Future<void> signInWithGoogle() async {
      setState(() {
    loading = true;
    error = null;
  });

  try {
    if (kIsWeb) {
      // Web authentication
      final provider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      // Android authentication
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  } on FirebaseAuthException catch (e) {
    if (mounted) {
      setState(() => error = '${e.code}: ${e.message}');
    }
  } catch (e) {
    if (mounted) {
      setState(() => error = e.toString());
    }
  } finally {
    if (mounted) {
      setState(() => loading = false);
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppStyles.backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: AppStyles.circleAvatarColor,
                      child: const Icon(Icons.psychology, size: 70, color:AppStyles.iconColor),
                    ),
                    const SizedBox(height: 16),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Evolve!',
                          textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber),
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                      totalRepeatCount: 3,
                    ),
                    const SizedBox(height: 8.0),

                      // Subtitle
                      Text(
                        'Track your progress and grow',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 20),
                   Container(
  decoration: BoxDecoration(
    gradient: AppStyles.backgroundGradient,
    borderRadius: BorderRadius.circular(30), // Rounded pill shape
    boxShadow: [
      BoxShadow(
        color: Colors.orange.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent, // Keeps the gradient visible
    child: InkWell(
      onTap: () {
        signInWithGoogle();
      },
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, color: AppStyles.iconColor), // Or your Google icon
            const SizedBox(width: 8),
            Text(
              loading ? 'Signing in...' : 'Continue with Google',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
                    if (loading) const CircularProgressIndicator(),
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}