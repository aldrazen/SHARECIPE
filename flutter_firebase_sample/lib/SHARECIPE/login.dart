import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/SHARECIPE/register.dart';
import 'package:firebase_sample/SHARECIPE/resetpassword.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.showRegisterPage});
  final VoidCallback showRegisterPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String errormessage;
  late bool isError;
  late bool obscureText;
  //LOGIN
  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        errormessage = error.message.toString();
        loginErrorHandling(errormessage, context);
      });
    }
  }

  Widget hidePassword() => const Icon(
        Icons.visibility,
        size: 25,
      );
  Widget showPassword() => const Icon(
        Icons.visibility_off,
        size: 25,
      );

  checkPassword() => (obscureText) ? hidePassword() : showPassword();

  Future<void> loginErrorHandling(String subtitle, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text(
            'Error occured.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    obscureText = true;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 0, 10),
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/aa.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.only(top: 290, right: 10, left: 10),
              width: 500,
              height: 380,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(
                  Radius.circular(70),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
                  children: [
                    Image.asset(
                      'images/ssssss.png',
                      height: 75,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.account_circle_rounded,
                            size: 25,
                            color: Colors.black,
                          ),
                          hintText: 'Email'),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock_rounded,
                          size: 25,
                          color: Colors.black,
                        ),
                        suffixIcon: InkWell(
                          child: checkPassword(),
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                        hintText: 'Password',
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 83, 0, 10),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: widget.showRegisterPage,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          child: const Text(
                            "REGISTER",
                            style: TextStyle(
                              color: Color.fromARGB(255, 92, 1, 12),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
