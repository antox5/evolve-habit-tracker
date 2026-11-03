import 'package:flutter/material.dart';
import 'package:flutter_application_3/cubits.dart';
import 'package:flutter_application_3/models/models.dart';
import 'package:flutter_application_3/notifications.dart';
import 'package:flutter_application_3/screens/habit_screen.dart';
import 'package:flutter_application_3/screens/sign_in_page.dart';
import 'package:flutter_application_3/widgets/progress_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toastification/toastification.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final user = FirebaseAuth.instance.currentUser;
  final String userId = user?.uid ?? '';

  runApp(
   
     BlocProvider(
    create: (context) => HabitCubit(userId: userId),
    child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ToastificationWrapper(
        child: MaterialApp(
        
          title: 'Evolve!',
          
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
          
            useMaterial3: true,
            primaryColor: Colors.white,
            
            
          ),
          home: const AuthGate(),
        ),
      
    );
  }
}

    


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // Not signed in: show Google sign-in.
        if (user == null) {
          return const SignInPage();
        }

        // Signed in: show your existing product screen.
        return BlocProvider(
          create: (context) => HabitCubit(userId: user.uid),
          child: HabitScreen());
      },
    );
  }
}
    


