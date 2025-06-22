import 'package:flutter/material.dart';

import 'onboarding_screen_1.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName="welcomeScreen";
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(


        children: [
          Expanded(
            flex: 3,
            child: Image.asset('assets/images/3179161-homem-e-mulher-se-comunicam-com-a-linguagem-de-sinais-vetor.png', fit: BoxFit.cover),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 70,decoration: BoxDecoration(color: Color(0XFF064ECD),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 40,decoration: BoxDecoration(color: Color(0XFF678ED2),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(height: 5,width: 40,decoration: BoxDecoration(color: Color(0XFF678ED2),borderRadius: BorderRadiusDirectional.circular(20)),),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  "Your Language, Your Voice",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Color(0XFF092E86)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    "Translate your thoughts effortlessly and bridge communication gaps with sign language.",
                    textAlign: TextAlign.center,style: TextStyle(color: Color(0XFF064ECD)),
                  ),
                ),
                Container(
                  width: 300,
                  child: ElevatedButton(onPressed: () {
Navigator.pushReplacementNamed(context,OnboardingScreen1.routeName);
                  }, child: Text("Next",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF064ECD)), ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
