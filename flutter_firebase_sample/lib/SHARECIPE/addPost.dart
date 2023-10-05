import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/photo.dart';
import 'package:firebase_sample/SHARECIPE/account.dart';
import 'package:firebase_sample/SHARECIPE/post.dart';
import 'package:firebase_sample/SHARECIPE/profile.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.currentAccount});
  final Account currentAccount;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final captionController = TextEditingController();
  final recipeController = TextEditingController();
  final preptimeController = TextEditingController();
  final cooktimeController = TextEditingController();
  final servingController = TextEditingController();
  PlatformFile? selectedPhoto;
  UploadTask? uploadTask;
  String urlFile = "";
  String postID = const Uuid().v4();
  late String urlDownload;

  late String errorMessage;
  /*
  Future updateDatabase(context) async {
    final user = FirebaseFirestore.instance
        .collection('Account_post')
        .doc(widget.currentAccount.id);
    await user.update({
      'Image': urlDownload,
    }).then((value) {
      showAlert(context, "Success", "Image updated!");
    });
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
    updateDatabase(context);
    /*
    setState(() {
      urlFile = urlDownload;
      uploadTask = null;
    });
    */
  }
  */

  Future<void> createPost() async {
    if (selectedPhoto == null) {
      showAlert(context, 'Error', 'Please select a photo!');
      return;
    }
    showLoaderDialog(context);
    final timestamp = Timestamp.now();
    final path = 'images/${generateRandomString(5)}-${selectedPhoto!.name}';
    final file = File(selectedPhoto!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      final snapshot = await ref.putFile(file);
      final urlDownload = await snapshot.ref.getDownloadURL();
      final post = FirebaseFirestore.instance
          .collection('Post')
          .doc(widget.currentAccount.id)
          .collection('Account_post')
          .doc(postID);

      final addPost = Post(
        postTime: timestamp,
        postID: postID,
        accPF: widget.currentAccount.profilePic,
        accName: widget.currentAccount.name,
        postDesc: captionController.text,
        postRecipe: recipeController.text,
        postImage: urlDownload,
        accountID: widget.currentAccount.id,
        prepTime: preptimeController.text,
        cookTime: cooktimeController.text,
        serving: servingController.text,
      );

      final json = addPost.toJson();
      await post.set(json);
      setState(() {
        captionController.text = "";
        recipeController.text = "";
        preptimeController.text = "";
        cooktimeController.text = "";
        servingController.text = "";
        selectedPhoto = null;
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message.toString();
      Navigator.pop(context);
      showAlert(context, 'Error', errorMessage);
    }
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
              //uploadFile(context);
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
                'SHARE YOUR RECIPE!',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Select photo',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
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
                    'Choose',
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

  showAlert(BuildContext context, String title, String msg) {
    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
        if (title == "Success") {
          if (urlFile == '') urlFile = "-";
          Navigator.of(context).pop(
            Photo(image: urlFile),
          );
        }
      },
      child:
          const Text('Ok', style: TextStyle(fontSize: 15, color: Colors.white)),
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Color.fromARGB(255, 92, 1, 12),
      title: Row(
        children: [
          Icon(
            Icons.error_outline_outlined,
            size: 35,
            color: Colors.red,
          ),
          SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
      content: Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(msg,
              style: const TextStyle(fontSize: 20, color: Colors.white))),
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
      Navigator.of(context).pop();
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
              'POSTING...',
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
        'images/ssssss.png',
      );
  checkImage() => (selectedPhoto != null) ? imgExist() : imgNotExist();

  @override
  void initState() {
    errorMessage = "This is an error";

    super.initState();
  }

  @override
  void dispose() {
    captionController.dispose();
    recipeController.dispose();
    preptimeController.dispose();
    cooktimeController.dispose();
    servingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SHARE RECIPE'),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 40),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 220.0,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: checkImage(),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 260, top: 180),
                          child: IconButton(
                            onPressed: () {
                              addPhoto(context);
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
                      controller: captionController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Caption',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: recipeController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Recipe',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: preptimeController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Prep time',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: cooktimeController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Cook time',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: servingController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Serving',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 92, 1, 12),
                        minimumSize: Size.fromHeight(50),
                      ),
                      onPressed: () {
                        createPost();
                      },
                      child: const Text(
                        'POST',
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
          ],
        ));
  }
}
