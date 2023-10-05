import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/SHARECIPE/account.dart';
import 'package:firebase_sample/SHARECIPE/drawer.dart';
import 'package:firebase_sample/SHARECIPE/post.dart';
import 'package:firebase_sample/SHARECIPE/addPost.dart';
import 'package:firebase_sample/SHARECIPE/editProfile.dart';
import 'package:firebase_sample/SHARECIPE/postClicked.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PlatformFile? selectedPhoto;
  UploadTask? uploadTask;
  String urlFile = "";
  late bool isLiked;
  var boldText = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  var bigText = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 176, 41, 39),
  );

  var descText = const TextStyle(fontSize: 14);

  //TO ACCESS THE CURRENT ACCOUNT'S PROFILE
  Future<Account> accountProfile() async {
    final userAccount = FirebaseAuth.instance.currentUser!;
    final account = await FirebaseFirestore.instance
        .collection('Account')
        .doc(userAccount.uid)
        .get();
    if (account.exists) {
      final accountData = account.data() as Map<String, dynamic>;
      return Account.fromJson(accountData);
    } else {
      throw Exception('Account not found');
    }
  }

  profile(Account account) => Stack(
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          Container(
            height: 75,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 36,
            width: 117,
            margin: const EdgeInsets.only(left: 290, top: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(account: account),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(183, 255, 255, 255),
              ),
              child: const Text('edit profile'),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: boldText,
                ),
                Text(
                  account.bio,
                  style: descText,
                )
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 28,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 176, 41, 39),
                      radius: 52,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(account.profilePic),
                        radius: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'recipe shared',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '89',
                        style: boldText,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'followers',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '541',
                        style: boldText,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 176, 41, 39),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    'Posts',
                    style: bigText,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(width: 180),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddPost(currentAccount: account),
                    ),
                  );
                },
                child: const Text(
                  'Share your new recipe here...                                      ',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      );

  buttonActions(iconVal) => IconButton(
        onPressed: () {
          setState(() {
            isLiked = (isLiked) ? false : true;
          });
        },
        icon: Icon(
          iconVal,
          color:
              (isLiked && iconVal == Icons.favorite) ? Colors.red : Colors.grey,
          size: 32,
        ),
      );
  buildIconTab(iconVal, title, time) => Row(
        children: [
          Icon(iconVal, color: Color.fromARGB(255, 176, 41, 39)),
          const SizedBox(width: 5),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      );

  buildRowTabs(Post post) => Row(
        children: [
          buildIconTab(Icons.kitchen, 'PREP', post.prepTime),
          const SizedBox(width: 16),
          buildIconTab(Icons.timer, 'COOK', post.cookTime),
          const SizedBox(width: 16),
          buildIconTab(Icons.restaurant, 'SERVING', post.serving),
        ],
      );

  //QUERY TO ACCESS ACCOUNT POST OF CURRENT COLLECTION FROM POST COLLECTION
  Stream<List<Post>> accountPost() {
    final userAccount = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('Post')
        .doc(userAccount.uid)
        .collection('Account_post')
        .orderBy('Post_time', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }

  Widget postList(Post post) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 176, 41, 39),
                      radius: 28,
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(post.accPF),
                          radius: 25),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      post.accName,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 176, 41, 39),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProjectPost(viewPost: post),
                          ),
                        );
                      });
                    },
                    child: Image.network(
                      post.postImage,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 176, 41, 39),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    post.postDesc,
                    style: boldText,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buttonActions(Icons.favorite),
                    const Text(
                      '1.1k',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    buildRowTabs(post),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 176, 41, 39),
          ),
        ],
      );

  @override
  void initState() {
    isLiked = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: bigText,
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: ListView(
        children: [
          FutureBuilder(
            future: accountProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong :( ${snapshot.error})');
              } else if (snapshot.hasData) {
                final account = snapshot.data!;
                return Center(
                  child: Column(
                    children: [
                      profile(account),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          StreamBuilder<List<Post>>(
            stream: accountPost(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Oops. Something went wrong! ${snapshot.error}');
              } else if (snapshot.hasData) {
                final post = snapshot.data!;
                return Column(
                  children: post.map(postList).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.transparent,
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
