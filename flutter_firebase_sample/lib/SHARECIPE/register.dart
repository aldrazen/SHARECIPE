import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/SHARECIPE/account.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.showLoginPage});
  final VoidCallback showLoginPage;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  late String errorMessage;
  late bool isError = false;
  late bool obscureText;

  Future createAccount() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userID = user.uid;
    final userDatabase =
        FirebaseFirestore.instance.collection('Account').doc(userID);
    final account = Account(
      id: userID,
      email: emailController.text,
      name: nameController.text,
      profilePic: '',
      birthdate: birthdayController.text,
      bio: '',
    );
    final json = account.toJson();
    await userDatabase.set(json);
    widget.showLoginPage;
  }

  Future signUpAccount() async {
    try {
      if (nameController.text.trim() == "") {
        return loginErrorHandling('Enter your name', context);
      } else if (birthdayController.text.trim() == "") {
        return loginErrorHandling('Enter your birthdate.', context);
      } else if (emailController.text.trim() == "") {
        return loginErrorHandling('Enter your email', context);
      } else if (passwordController.text.trim() == "") {
        return loginErrorHandling('Create your password', context);
      } else if (confirmPassController.text.trim() == "") {
        return loginErrorHandling('Confirm your password', context);
      } else if (confirmPassController.text.trim() !=
          passwordController.text.trim()) {
        loginErrorHandling('PASSWORD DOESNT MATCH.', context);
        confirmPassController.text = "";
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        createAccount();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message.toString();
        loginErrorHandling(errorMessage, context);
        nameController.clear();
        birthdayController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPassController.clear();
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
              child: Center(
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
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    errorMessage = "There is an error";
    isError;
    obscureText = true;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
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
              margin: const EdgeInsets.only(top: 290),
              width: 500,
              height: 560,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Column(
                  children: [
                    Image.asset(
                      'images/home.png',
                      height: 90,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Full name'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      readOnly: true,
                      controller: birthdayController,
                      decoration: InputDecoration(
                        hintText: 'Birthdate',
                        suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1980),
                                lastDate: DateTime.now());
                            if (pickedDate != null) {
                              setState(() {
                                birthdayController.text =
                                    DateFormat('MMMM/dd/yyyy')
                                        .format(pickedDate);
                              });
                            }
                          },
                          child: const Icon(
                            Icons.date_range_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: confirmPassController,
                      obscureText: obscureText,
                      decoration:
                          const InputDecoration(hintText: 'Confirm password'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 92, 1, 12),
                        minimumSize: Size.fromHeight(50),
                      ),
                      onPressed: signUpAccount,
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: widget.showLoginPage,
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Color.fromARGB(255, 92, 1, 12),
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
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
