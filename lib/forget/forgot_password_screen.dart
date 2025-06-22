import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sela_gradution_app/forget/verfiey_code_screen.dart';
import '../utils/dialoud_utils/dialoug.dart';
import '../utils/email_validetor.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "forgetPasswordScreen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Color(0XFF092E86)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    Text("Forget password",
                        style: TextStyle(fontSize: 20, color: Color(0XFF092E86),)),
        
                    Spacer(flex: 2),
                  ],
                ),
                SizedBox(height: 20),
                Center(child: Image.asset('assets/images/Group 396.png', height: 150)),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Please enter your email\n to receive an OTP code",
                    style: TextStyle(fontSize: 20, color: Color(0XFF092E86)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 16, color: Color(0XFF092E86)),
                  ),
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
                    filled: true,
                    fillColor: Color(0XFF658ACB),
                    labelText: 'Enter your email',
                    labelStyle: TextStyle(color: Color(0XFF3558AD), fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
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
                SizedBox(height: 20),
                Container(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: sendCode,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Send Code", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF064ECD)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendCode() async {
    if (formKey.currentState?.validate() == false) return;

    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        showMessage("This email is not registered", "cancel");
        setState(() {
          isLoading = false;
        });
        return;
      }

      String phoneNumber = snapshot.docs.first.get('phone').toString().trim();

      print("Phone number from Firestore: $phoneNumber");

      // تحويل الرقم إلى صيغة دولية +20XXXXXXXXXX
      if (phoneNumber.startsWith('0')) {
        phoneNumber = '+20' + phoneNumber.substring(1);
      }

      // التحقق من الصيغة النهائية
      if (!RegExp(r'^\+20\d{10}$').hasMatch(phoneNumber)) {
        showMessage("Phone number format is invalid", "cancel");
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });
          showMessage("Verification failed: ${e.message}", "cancel");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage("An error occurred: $e", "cancel");
    }
  }

  void showMessage(String message, String action) {
    if (action == "cancel") {
      DialougUtiles.showMessage(
        context,
        message,
        negActionTitles: action,
      );
    }
  }
}
