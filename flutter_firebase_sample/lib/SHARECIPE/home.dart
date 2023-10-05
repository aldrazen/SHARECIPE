import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_sample/SHARECIPE/post.dart';
import 'package:firebase_sample/SHARECIPE/postClicked.dart';
import 'package:flutter/material.dart';

class ProjectHome extends StatefulWidget {
  const ProjectHome({super.key});

  @override
  State<ProjectHome> createState() => _ProjectHomeState();
}

class _ProjectHomeState extends State<ProjectHome> {
  // QUERY THE SUB COLLECTION OF POST NAMED 'ACCOUNT_POST'
  Stream<List<Post>> streamPost() {
    return FirebaseFirestore.instance
        .collectionGroup('Account_post')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }

  var boldText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  var bigText = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 176, 41, 39),
  );
  var descText = const TextStyle(fontSize: 14);

  late bool isLiked = false;
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
          Icon(iconVal, color: const Color.fromARGB(255, 176, 41, 39)),
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

  Widget showPostList(Post post) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
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
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            post.postImage,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: const Color.fromARGB(255, 176, 41, 39),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 176, 41, 39),
                                radius: 28,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(post.accPF),
                                  radius: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                post.accName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.postDesc,
                                style: boldText,
                              ),
                              Row(
                                children: [
                                  buttonActions(Icons.favorite),
                                  const Text(
                                    '1.1k',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  buildRowTabs(post),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Feed',
            style: bigText,
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Post>>(
          stream: streamPost(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Oops. Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final post = snapshot.data!;
              return ListView(children: post.map(showPostList).toList());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
