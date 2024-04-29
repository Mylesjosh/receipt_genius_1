import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'business_home_page.dart';
import 'business_login_page.dart';
import 'user_login_page.dart';

import 'dart:io';
import 'package:path/path.dart' as path;

class BusinessRegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const BusinessRegisterPage({super.key, this.onTap});

  @override
  State<BusinessRegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<BusinessRegisterPage> {
  XFile? _selectedImage;
  // text editing controllers
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    businessNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool confirmPassword(){
    if(passwordController.text == confirmPasswordController.text){
      return true;
    }
    else
      return false;
  }

  // register method
  Future register() async {
// Show progress indicator while logging in
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //final XFile? imageFile = await _getImage();
    final String? logoUrl = await uploadImage(_selectedImage);
    Navigator.of(context).pop();
    // create user account first
    if (confirmPassword()) {

      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),);

      addUserDetails(
        businessNameController.text.trim(),
        emailController.text.trim(),
        logoUrl,
      );

      Navigator.of(context).pop();
      // once created, send user to homepage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }else {
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text("Your password confirmation is incorrect"),
                )
            );
          }
      );
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }


  Future<String?> uploadImage(XFile? imageFile) async {
    if (imageFile == null) return null;

    try {
      final File file = File(imageFile.path);
      final Reference ref = FirebaseStorage.instance.ref().child('logos/${path.basename(imageFile.path)}');
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future addUserDetails(String businessName, String email, String? logoUrl) async {
    try{
      // Get the current user's UID
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('businessOwners').doc(uid).set({
        'businessname': businessName,
        'email': email,
        'logoUrl': logoUrl,
      }
      );
    }catch(e){
      print("Error adding user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Image.asset(
                  'lib/images/unlock.png',
                  height: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Let\'s create an account for you',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // business name textfield
                MyTextField(
                  controller: businessNameController,
                  hintText: 'Business Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // Add Logo Button
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Add Logo"),
                    SizedBox(width: 10.w,),
                    IconButton(onPressed: () async {
                      final XFile? image = await _getImage();
                      setState(() {
                        _selectedImage = image;
                      });},
                        icon: Icon(Icons.add_circle)),
                  ],
                ),

                // Image Preview
                if (_selectedImage != null)
                  FutureBuilder(
                    future: _selectedImage!.readAsBytes(),
                    builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(child: Image.memory(snapshot.data!));
                      } else {
                        return Container(child: CircularProgressIndicator());
                      }
                    },
                  )
                else
                  Text('No logo selected'),
                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: register,
                  text: "Sign Up",
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a Registered Business?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessLoginPage()));
                      },
                      child: const Text(
                        'Login Here!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                /*SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A User?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap:widget.onTap,
                      child: const Text(
                        'Register Here!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),*/

              ],
            ),
          ),
        ),
      ),
    );
  }
}
