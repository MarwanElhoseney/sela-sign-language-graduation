
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../database/my_database.dart';
import '../model/my_user.dart';
import '../shared_data.dart';

abstract class regesterNaviegator {
  void showLoading({String message = "loading"});

  void hideDiloug();

  void showMessage(String message, String action);
}

class regesterViewModel extends ChangeNotifier {
  regesterNaviegator? naviegator;

  var authService = FirebaseAuth.instance;

  void regester(
      String email, String password, String Name,String phone) async {
    naviegator?.showLoading();
    try {
      var credential = await authService.createUserWithEmailAndPassword(
          email: email, password: password);
      MyUser newUser = MyUser(
        Name: Name,
        id: credential.user?.uid,
        email: email,
        phone: phone
      );
      var insertedUser = await MyDataBase.insertUser(newUser);
      naviegator?.hideDiloug();
      if (insertedUser != null) {
        SharedData.user = insertedUser;
        naviegator?.showMessage("regestered successfully", "ok");
      } else {
        naviegator?.showMessage("something went wrong", "cancel");
      }
    } on FirebaseAuthException catch (e) {
      naviegator?.hideDiloug();
      if (e.code == "weak-password") {
        naviegator?.showMessage("the password is too weak", "cancel");
      } else if (e.code == "email-already-in-use") {
        naviegator?.showMessage("email already in use", "cancel");
      }
    } catch (e) {
      naviegator?.hideDiloug();
      naviegator?.showMessage("something went wrong", "cancel");
    }
    }
}
