import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final auth = AuthService();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await auth.signUp(
                    emailController.text.trim(),
                    passController.text.trim(),
                  );

                  if (user != null) {
                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account created. Check your email for verification.'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'email-already-in-use':
                      showError(context, 'This email is already in use.');
                      break;
                    case 'invalid-email':
                      showError(context, 'The email address is not valid.');
                      break;
                    case 'weak-password':
                      showError(context, 'The password is too weak.');
                      break;
                    default:
                      showError(context, 'Signup failed: ${e.message}');
                      break;
                  }
                } catch (e) {
                  showError(context, 'Unexpected error: $e');
                }
              },
              child: const Text('Create Account'),
            ),

            const SizedBox(height: 20),
            const Text('Or login using Google'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: IconButton(
                icon: Image.asset('assets/google_icon.png', height: 36, width: 36),
                onPressed: () async {
                  try {
                    final user = await auth.signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    }
                  } catch (e) {
                    showError(context, 'Google Sign-In failed: $e');
                  }
                },
                tooltip: 'Sign in with Google',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
