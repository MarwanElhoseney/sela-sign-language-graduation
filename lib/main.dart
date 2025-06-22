import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sela_gradution_app/firebase_options.dart';
import 'package:sela_gradution_app/presentation/screens/home_screen.dart';
import 'package:sela_gradution_app/presentation/providers/home_provider.dart';
import 'package:sela_gradution_app/regester/register_screen_view.dart';
import 'package:sela_gradution_app/ui/onboarding_screen_1.dart';
import 'package:sela_gradution_app/ui/onboarding_screen_2.dart';
import 'package:sela_gradution_app/ui/welcome_screen.dart';
import 'forget/forgot_password_screen.dart' show ForgetPasswordScreen, ForgotPasswordScreen;
import 'forget/verfiey_code_screen.dart';
import 'login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Color(0XFFEDF4FE)),
      routes: {
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        OnboardingScreen1.routeName: (context) => OnboardingScreen1(),
        OnboardingScreen2.routeName: (context) => OnboardingScreen2(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      initialRoute: WelcomeScreen.routeName,
    );
  }
}