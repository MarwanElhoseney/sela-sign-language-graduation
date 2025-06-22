
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sela_gradution_app/database/my_database.dart';
import 'package:sela_gradution_app/shared_data.dart';

abstract class logInNaviegator {
  void showLoading({String message = "loading"});

  void hideDiloug();

  void showMessage(String message, String action);
}

class logInViewModel extends ChangeNotifier {
  var authService = FirebaseAuth.instance;
  logInNaviegator? naviegator;

  void signIn(email, password) async {
    try {
      naviegator?.showLoading();
      var credintial = await authService.signInWithEmailAndPassword(
          email: email, password: password);
      var retrivedUser = await MyDataBase.getUserById(credintial.user!.uid);
      if (retrivedUser == null) {
        naviegator?.showMessage("wrong email or password", "cancel");
      } else {
        SharedData.user = retrivedUser;  // حفظ بيانات المستخدم
        naviegator?.hideDiloug();
        // تمرير بيانات المستخدم عند النجاح
        naviegator?.showMessage("logged in successfully", "ok");
      }
    } on FirebaseAuthException catch (e) {
      naviegator?.hideDiloug();
      naviegator?.showMessage("wrong email or password", "cancel");
    }
  }
}