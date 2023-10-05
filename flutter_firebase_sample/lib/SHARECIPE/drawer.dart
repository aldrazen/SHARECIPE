import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/SHARECIPE/home.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final userAccount = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 92, 1, 12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(top: 80, left: 20, right: 20),
            width: 300,
            child: Image.asset('images/ssssss.png'),
          ),
          const SizedBox(height: 90),
          Row(
            children: [
              const SizedBox(width: 20),
              const Icon(
                Icons.home,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(width: 30),
              InkWell(
                hoverColor: Colors.white,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectHome(),
                    ),
                  );
                },
                child: const Text(
                  'HOME',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: [
              const SizedBox(width: 20),
              const Icon(
                Icons.account_circle,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(width: 30),
              InkWell(
                hoverColor: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'MY PROFILE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 420,
          ),
          ElevatedButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout),
              label: Text('LOGOUT'))
        ],
      ),
    );
  }
}
