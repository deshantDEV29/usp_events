import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usp_events/model/user.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Account created successful");

      // ignore: deprecated_member_use
      user.updateProfile(displayName: name);
      print(_auth.currentUser!.displayName);

      var data = {
        "name": name,
        "email": email,
        "status": "Unavailable",
      };

      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .set(data);

      return user;
    } else {
      print("Account creation failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Login successful");
      return user;
    } else {
      print("Login failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut() async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut();
  } catch (e) {
    print("error");
  }
}

UserModel currentData = new UserModel("", "");

void getUserData() async {
  UserModel user;
  var value = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  if (value.exists) {
    user = UserModel(value.get("name"), value.get("email"));
    currentData = user;
  }
  print(currentData.userEmail);
}

UserModel get currentUserData {
  return currentData;
}
