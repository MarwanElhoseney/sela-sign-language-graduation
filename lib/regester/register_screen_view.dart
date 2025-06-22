import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sela_gradution_app/login/login_screen.dart';
import 'package:sela_gradution_app/regester/regester_view_model.dart';
import '../utils/dialoud_utils/dialoug.dart';
import '../utils/email_validetor.dart';
import 'package:flutter/services.dart';

import '../utils/phone_number_validate.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "RegisterScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> implements regesterNaviegator {
  var formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool obscurePassword = true; // التحكم في إخفاء كلمة المرور
  bool obscureConfirmPassword = true; // التحكم في إخفاء تأكيد كلمة المرور
  late regesterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = regesterViewModel();
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
                children: [
                  Image.asset(
                    'assets/images/Untitled-3.png',
                    height: 150,
                  ),
                  Row(
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(fontSize: 22, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Enter your personal information",
                        style: TextStyle(fontSize: 12, color: Color(0XFF3558AD)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "User name",
                        style: TextStyle(fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: userNameController,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Please enter your full name";
                      }
                      if (input.length < 2) {
                        return "Name must be at least 2 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your user name',
                      labelStyle: TextStyle(color: Color(0XFF3558AD), fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      if (!isValidEmail(input)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your email',
                      labelStyle: TextStyle(color: Color(0XFF3558AD), fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      prefixIcon: Icon(Icons.mail, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),

                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // يقبل أرقام فقط
                      ArabicToEnglishDigitsFormatter(), // تحويل أي رقم عربي إلى إنجليزي
                    ],
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Please enter a phone number";
                      }
// إزالة أي مسافات أو أي رموز غير رقمية
                      input = input.replaceAll(RegExp(r'[^0-9]'), '');
// التأكد من أن الرقم يحتوي على 12 رقمًا بعد إضافة رمز الدولة
                      if (input.length != 11) { // الرقم يجب أن يحتوي على 12 رقمًا (بدون +20)
                        return "Phone number must be 11 digits (excluding country code)";
                      }
                      return null;
                    },
                    onSaved: (value) {
// إزالة أي مسافات أو أي رموز غير رقمية
                      String cleanPhone = value!.replaceAll(RegExp(r'[^0-9]'), '');
// إضافة +20 للرقم
                      cleanPhone = '20' + cleanPhone;
// تخزين الرقم بالصيغة الصحيحة
                      phoneController.text = '+$cleanPhone';
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your phone number',
                      labelStyle: TextStyle(color: Color(0XFF3558AD), fontSize: 14),
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: obscurePassword, // استخدم المتغير الخاص بكلمة المرور
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Please enter a password";
                      }
                      if (input.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your password',
                      labelStyle: TextStyle(color: Color(0XFF3558AD), fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Confirm Password",
                        style: TextStyle(fontSize: 16, color: Color(0XFF092E86)),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword, // استخدم المتغير الخاص بتأكيد كلمة المرور
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return "Please confirm your password";
                      }
                      if (input.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      if (input != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm your password',
                      labelStyle: TextStyle(color: Color(0XFF3558AD), fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF092E86), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "By signing up, you agree to the terms of use and privacy policy.",
                    style: TextStyle(fontSize: 10, color: Color(0XFF092E86)),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      child: const Text("Register", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF064ECD)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                    },
                    child: const Text(
                      "Already have an account? LogIn",
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
    viewModel.regester(emailController.text, passwordController.text,
        userNameController.text, phoneController.text);
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
      DialougUtiles.showMessage(
        context,
        message,
        posActionTitles: action,
        posAction: () {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        },
      );
    } else if (action == "cancel") {
      DialougUtiles.showMessage(context, message, negActionTitles: action);
    }
  }
}























