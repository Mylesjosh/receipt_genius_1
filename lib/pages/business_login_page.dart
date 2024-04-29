import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:receipt_genius/pages/forgot_passwd.dart';
import 'package:receipt_genius/pages/user_register_page.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/my_square_tile.dart';
import '../theme/theme_provider.dart';
import 'business_home_page.dart';
import 'business_reg_page.dart';

class BusinessLoginPage extends StatefulWidget {
  //final void Function()? onTap;

  const BusinessLoginPage({super.key, /*required this.onTap*/});


  @override
  State<BusinessLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<BusinessLoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //user type check
  bool isbusiness = true;

  // login method
  Future<void> login() async {
    // Check if email and password fields are empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Please enter both email and password."),
            ),
          );
        },
      );
      return; // Exit the method early
    }else
    try {
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
      // Check if the user is already authenticated
      if (FirebaseAuth.instance.currentUser != null) {
        // User is already authenticated, proceed with login
        showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        Navigator.of(context).pop();// Close the loading dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );// Close the login dialog
      }}  catch (e) {
      // Show error message if login fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text("Error Occurred: $e"),
            ),
          );
        },
      );
    }
  }

  @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }
    // forgot password
    void forgotPw() {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .background,
              title: const Text("User tapped forgot password."),
              content: ElevatedButton(
                child: Text("change Password"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassPage(),
                    ),
                  );
                },
              ),
            ),
      );
    }

    // google sign in
    void googleSignIn() {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .background,
              title: const Text("Login with Google?"),
              actions: [
                // cancel
                MaterialButton(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  elevation: 0,
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),

                // yes
                MaterialButton(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  elevation: 0,
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      ),
                  child: const Text("Yes"),
                ),
              ],
            ),
      );
    }

    // apple sign in
    void appleSignIn() {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .background,
              title: const Text("Login with Apple?"),
              actions: [
                // cancel
                MaterialButton(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  elevation: 0,
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),

                // yes
                MaterialButton(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  elevation: 0,
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      ),
                  child: const Text("Yes"),
                ),
              ],
            ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
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
                      color: Colors
                          .deepPurple[400] //Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

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

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: forgotPw,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: () {

                      login();
                    },
                    text: "Login",
                  ),

                  const SizedBox(height: 25),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .tertiary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                        onTap: googleSignIn,
                        child: Image.asset(
                          'lib/images/google.png',
                          height: 25,
                        ),
                      ),

                      const SizedBox(width: 25),

                      // apple button
                      SquareTile(
                        onTap: appleSignIn,
                        child: Image.asset(
                          'lib/images/apple.png',
                          height: 25,
                          color: Provider
                              .of<ThemeProvider>(context)
                              .isDarkMode
                              ? Colors.grey.shade400
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => BusinessRegisterPage()));
                        },
                        child: Text(
                          'Register your business now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

