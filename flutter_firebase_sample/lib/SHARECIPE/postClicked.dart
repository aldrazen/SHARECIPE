import 'package:firebase_sample/SHARECIPE/post.dart';
import 'package:flutter/material.dart';

class ProjectPost extends StatefulWidget {
  const ProjectPost({super.key, required this.viewPost});
  final Post viewPost;

  @override
  State<ProjectPost> createState() => _ProjectPostState();
}

class _ProjectPostState extends State<ProjectPost> {
  var boldText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  var bigText = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 176, 41, 39),
  );
  var descText = TextStyle(fontSize: 14);

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
  buildIconTab(iconVal, title, time) => Column(
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
  buildRowTabs() => Row(
        children: [
          buildIconTab(Icons.kitchen, 'PREP', widget.viewPost.prepTime),
          SizedBox(width: 16),
          buildIconTab(Icons.timer, 'COOK', widget.viewPost.cookTime),
          SizedBox(width: 16),
          buildIconTab(Icons.restaurant, 'SERVING', widget.viewPost.serving),
        ],
      );

  Widget buildIngredient(String ingredient) {
    return ListTile(
      leading: Icon(Icons.star, color: Color.fromARGB(255, 176, 41, 39)),
      title: Text(ingredient),
    );
  }

  Widget buildDirection(String direction) {
    return ListTile(
      leading: const Icon(
        Icons.arrow_right_outlined,
        color: Color.fromARGB(255, 176, 41, 39),
      ),
      title: Text(direction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.viewPost.accName,
          style: bigText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 176, 41, 39),
                            radius: 28,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(widget.viewPost.accPF),
                              radius: 27,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.viewPost.postDesc,
                              style: boldText,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          widget.viewPost.postImage,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 176, 41, 39),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          children: [
                            buttonActions(Icons.favorite),
                            const Text(
                              '1.1k hearts',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            buildRowTabs(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'INGREDIENTS',
                        style: boldText,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildIngredient('6 tablespoons olive oil'),
                          buildIngredient(
                              '2 lemons, 1 thinly sliced, 1 juiced'),
                          buildIngredient('4 garlic cloves, minced'),
                          buildIngredient('1 teaspoon salt'),
                          buildIngredient(
                              '1⁄2 teaspoon fresh ground black pepper'),
                          buildIngredient('3⁄4 lb fresh green beans'),
                          buildIngredient('8 small red potatoes, quartered'),
                          buildIngredient(
                              '4 chicken breasts (bones left in, with skin) or 3 1/4 lbs chicken breasts (bones left in, with skin)'),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'DIRECTIONS',
                        style: boldText,
                      ),
                      SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDirection(
                              'Preheat oven to 400°F Coat a large baking dish or cast-iron skillet with 1 tablespoon of the olive oil. Arrange the lemon slices in a single layer in the bottom of the dish or skillet.'),
                          buildDirection(
                              'In a large bowl, combine the remaining oil, lemon juice, garlic, salt, and pepper; add the green beans and toss to coat. Using a slotted spoon or tongs, remove the green beans and arrange them on top of the lemon slices. Add the potatoes to the same olive-oil mixture and toss to coat. Using a slotted spoon or tongs, arrange the potatoes along the inside edge of the dish or skillet on top of the green beans. Place the chicken in the same bowl with the olive-oil mixture and coat thoroughly. Place the chicken, skin-side up, in the dish or skillet. Pour any of the remaining olive-oil mixture over the chicken.'),
                          buildDirection(
                              'Roast for 50 minutes. Remove the chicken from the dish or skillet. Place the beans and potatoes back in oven for 10 minutes more or until the potatoes are tender. Place a chicken breast on each of 4 serving plates; divide the green beans and potatoes equally. Serve warm.'),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
