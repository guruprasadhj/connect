import 'package:connect/screens/home_screens/home_screen.dart';
import 'package:connect/screens/loader.dart';
import 'package:connect/screens/login_screens/login_screen.dart';
import 'package:connect/screens/register.dart';
import 'package:connect/screens/signup.dart';
import 'package:connect/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'package:connect/screens/login.dart';
import 'package:connect/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'connect',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MainPage(),
          );
        });
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(); // HomePage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
