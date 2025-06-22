import 'package:flutter/material.dart';
import 'package:sela_gradution_app/ui/welcome_screen.dart';

import 'onboarding_screen_2.dart';

class OnboardingScreen1 extends StatelessWidget {
  static const String routeName="OnboardingScreen1";

  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: Image.asset('assets/images/10102554.png'),
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
                child: Container(height: 5,width: 70,decoration: BoxDecoration(color: Color(0XFF064ECD),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 40,decoration: BoxDecoration(color: Color(0XFF678ED2),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Inclusive for All",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color(0XFF092E86)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Learn sign language, engage in dialogue, and make a difference even if you're not deaf.",
              textAlign: TextAlign.center,style: TextStyle(color: Color(0XFF064ECD)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
              }, child: const Text("Back",style: TextStyle(color:Color(0XFF064ECD)),),style:ElevatedButton.styleFrom(backgroundColor: Colors.white),),
              ElevatedButton(onPressed: () {
                Navigator.pushReplacementNamed(context, OnboardingScreen2.routeName);
              }, child: const Text("Next",style: TextStyle(color: Colors.white)),style:ElevatedButton.styleFrom(backgroundColor: Color(0XFF064ECD)),),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
