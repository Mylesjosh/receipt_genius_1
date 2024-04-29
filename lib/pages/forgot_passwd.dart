import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> checkIfEmailIsRegistered(String email) async {
    try {
      // Check if the email exists in Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('businessOwners').where('email', isEqualTo: email).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email registration: $e");
      return false;
    }
  }

  Future resetLink() async {
    try {
      //check if email is registered
      bool isEmailRegistered = await checkIfEmailIsRegistered(_emailController.text.trim());

      if (isEmailRegistered){
        await FirebaseAuth.instance
            .sendPasswordResetEmail(
            email: _emailController.text.trim());
        showDialog(
            context: context,
            builder: (context)
            {return AlertDialog(
              content: Text("Password reset link has been sent to your email."),
            );
            }
        );
      }
      else{
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: Text("this email is not registered"),
              );
            });
      }

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context)
          {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text("Enter your Email here and you will recieve a password reset link",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 20,),
          MyTextField(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
          ),
          SizedBox(height: 20,),
          MyButton(
            onTap: () {
              resetLink;
            },
            text: "Reset Password",
          ),
        ],
      ),
    );
  }
}
