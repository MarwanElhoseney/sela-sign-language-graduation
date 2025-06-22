import 'package:flutter/material.dart';
import 'package:sela_gradution_app/login/login_screen.dart';
import 'package:sela_gradution_app/regester/register_screen_view.dart';

class OnboardingScreen2 extends StatelessWidget {
  static const String routeName="OnboardingScreen2";

  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: Image.asset('assets/images/3332224-linguas-do-dia-internacional-dos-sinais-vetor.png',fit: BoxFit.cover,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 40,decoration: BoxDecoration(color: Color(0XFF678ED2),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 40,decoration: BoxDecoration(color: Color(0XFF678ED2),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 70,decoration: BoxDecoration(color: Color(0XFF064ECD),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Break Barriers",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color(0XFF092E86)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Empower communication with real-time sign language translation – connecting  everyone, everywhere.",
              textAlign: TextAlign.center,style: TextStyle(color: Color(0XFF064ECD)),
            ),
          ),
          const SizedBox(height: 20),
          Container(
              width: 300,
              child: ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }, child: const Text("Login",style: TextStyle(color: Colors.white)),style:ElevatedButton.styleFrom(backgroundColor: Color(0XFF064ECD))),

          ),
          Container(width: 300,
            child: ElevatedButton(onPressed: () {
              Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
            }, child: const Text("Register",style: TextStyle(color:Color(0XFF064ECD)),),style:ElevatedButton.styleFrom(backgroundColor: Colors.white),),
          ),        ],
      ),
    );
  }
}
