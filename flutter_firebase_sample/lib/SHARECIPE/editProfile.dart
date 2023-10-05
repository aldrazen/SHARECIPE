import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/photo.dart';
import 'package:firebase_sample/SHARECIPE/account.dart';
import 'package:firebase_sample/SHARECIPE/authenticator.dart';
import 'package:firebase_sample/SHARECIPE/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.account});
  final Account account;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final bioController = TextEditingController();
  PlatformFile? selectedPhoto;
  UploadTask? uploadTask;
  String urlFile = "";

  Future updateUser() async {
    final user =
        FirebaseFirestore.instance.collection('Account').doc(widget.account.id);
    user.update({
      'Name': nameController.text.trim(),
      'Bio': bioController.text.trim(),
      'Birthdate': birthdayController.text.trim(),
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthenticatorPage(),
      ),
    );
  }

  Widget hidePassword() => const Icon(
        Icons.visibility,
        size: 25,
      );
  Widget showPassword() => const Icon(
        Icons.visibility_off,
        size: 25,
      );

  Future updateDatabase(urlDownload, context) async {
    final userAccount = FirebaseAuth.instance.currentUser!;
    final userRef =
        FirebaseFirestore.instance.collection('Account').doc(userAccount.uid);

    // Update the 'Account' collection with the new profile picture URL
    await userRef.update({
      'Profilepic': urlDownload,
    }).then((value) {
      showAlert(context, "Success", "Profile picture added!");
    });

    // Now, let's assume you have a 'Post' collection with documents that include a field 'userId'
    // to identify the owner of the post.
    // Get all posts by the current user from the 'Post' collection
    final userPosts = await FirebaseFirestore.instance
        .collection('Post')
        .where('Account_ID', isEqualTo: userAccount.uid)
        .get();
    // Update the 'Profilepic' field in the 'Account_post' collection for each post
    for (final post in userPosts.docs) {
      final postId = post.id;
      final postRef =
          FirebaseFirestore.instance.collection('Account_post').doc(postId);

      await postRef.update({
        'Profile_pic': urlDownload,
      });
    }
    setState(() {
      selectedPhoto = null;
    });
  }

  Future uploadFile(context) async {
    showLoaderDialog(context);
    final path =
        'images/${'${generateRandomString(5)}-${selectedPhoto!.name}'}';
    final file = File(selectedPhoto!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: $urlDownload');
    updateDatabase(urlDownload, context);
  }

  showAlertDialogUpload(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color.fromARGB(255, 83, 0, 10),
      title: const Center(
        child: Text(
          'Choose photo?',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
              uploadFile(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlert(BuildContext context, String title, String msg) {
    Widget continueButton = TextButton(
      onPressed: () {
        if (title == "Success") {
          if (urlFile == '') urlFile = "-";
          Navigator.of(context).pop(
            Photo(image: urlFile),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AuthenticatorPage(),
            ),
          );
        }
      },
      child: const Text('Ok'),
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Color.fromARGB(255, 83, 0, 10),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      content: Text(msg, style: TextStyle(color: Colors.white)),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      selectedPhoto = result.files.first;
      addPhoto(context);
    });
  }

  String generateRandomString(int len) {
    var random = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[random.nextInt(_chars.length)])
        .join();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color.fromARGB(255, 83, 0, 10),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Text(
              'Setting profile picture...',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget imgExist() => Image.file(
        File(selectedPhoto!.path!),
        fit: BoxFit.cover,
      );
  Widget imgNotExist() => Image.asset(
        'images/profpicdefault.jpg',
      );
  checkImage() => (selectedPhoto != null) ? imgExist() : imgNotExist();

  Future<void> addPhoto(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 83, 0, 10),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PROFILE PICTURE',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          content: checkImage(),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    selectFile();
                  },
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Select photo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                */
                ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (selectedPhoto != null) {
                      showAlertDialogUpload(context);
                    } else {
                      showAlert(context, 'ERROR', 'Please select a photo!');
                    }
                  },
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Set photo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    nameController.text = widget.account.name;
    bioController.text = widget.account.bio;
    birthdayController.text = widget.account.birthdate;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    bioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
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
                Stack(
                  children: [
                    Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(),
                      child: Center(
                          child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 176, 41, 39),
                        radius: 100,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.account.profilePic),
                          radius: 95,
                        ),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 130, top: 198),
                      child: IconButton(
                        onPressed: () {
                          selectFile();
                        },
                        icon: Icon(Icons.add_a_photo),
                        iconSize: 50,
                        color: Color.fromARGB(255, 176, 41, 39),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(
                    label: const Text(
                      'Add/Edit bio:',
                      style: TextStyle(fontSize: 18),
                    ),
                    hintText: widget.account.bio,
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      label: const Text(
                        'Full name:',
                        style: TextStyle(fontSize: 18),
                      ),
                      hintText: widget.account.name),
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: birthdayController,
                  decoration: InputDecoration(
                    label: const Text(
                      'Birthday',
                      style: TextStyle(fontSize: 18),
                    ),
                    hintText: widget.account.birthdate,
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2030));
                        if (pickedDate != null) {
                          setState(() {
                            birthdayController.text =
                                DateFormat('MMMM/dd/yyyy').format(pickedDate);
                          });
                        }
                      },
                      child: const Icon(
                        Icons.date_range_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 92, 1, 12),
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () {
                    updateUser();
                  },
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
