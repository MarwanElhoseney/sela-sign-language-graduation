import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sela_gradution_app/forget/forgot_password_screen.dart';
import 'package:sela_gradution_app/login/login_screen_view_model.dart';
import 'package:sela_gradution_app/regester/register_screen_view.dart';
import 'package:sela_gradution_app/shared_data.dart';
import '../presentation/screens/home_screen.dart';
import '../utils/dialoud_utils/dialoug.dart';
import '../utils/email_validetor.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements logInNaviegator {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscure = true;
  late logInViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = logInViewModel();
    viewModel.naviegator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/Untitled-3.png',
                    height: 100,
                  ),
                  Row(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 22, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Login to continue using app.",
                        style: TextStyle(
                            fontSize: 12, color: Color(0XFF3558AD)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Plz enter email";
                      }
                      if (!isValidEmail(input)) {
                        return "Enter valid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      labelStyle: TextStyle(
                        color: Color(0XFF3558AD),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: obscure,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Plz enter password";
                      }
                      if (input.length < 8) {
                        return "Password must be at least 8 chars";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your password',
                      labelStyle: TextStyle(
                        color: Color(0XFF3558AD),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                        },
                        child: const Text(
                          "Forget your password?",
                          style: TextStyle(color: Color(0XFF092E86)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      child: const Text("Login", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF064ECD)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "Or login with",
                          style: TextStyle(color: Color(0XFF092E86)),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.facebook,size: 30,), color: Color(0XFF092E86)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.g_mobiledata,size: 50,), color: Color(0XFF092E86)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Color(0XFF092E86)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn() {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    viewModel.signIn(emailController.text, passwordController.text);
  }

  @override
  void hideDiloug() {
    DialougUtiles.hideDialougs(context);
  }

  @override
  void showLoading({String message = "loading"}) {
    DialougUtiles.showLoadingDilaogs(context, message);
  }

  @override
  void showMessage(String message, String action) {
    if (action == "ok") {
      Navigator.pushReplacementNamed(
        context,
        HomeScreen.routeName,
        arguments: SharedData.user,
      );
    } else if (action == "cancel") {
      DialougUtiles.showMessage(context, message, negActionTitles: action);
    }
  }
}
