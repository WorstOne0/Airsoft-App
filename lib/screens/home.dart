// Flutter Packages
import 'package:airsoft/models/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  bool get wantKeepAlive => true;

  List<Story> stories = [Story(0, 0, false, "Motinhaa", "url", "url")];

  Widget buildStoryCard(Story storie) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 150,
        width: 110,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.network(
              "https://www.combatpursuit.com/wp-content/uploads/Airsoft-Action-1-1024x634.jpg",
            ).image,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Stack(
          children: [
            Positioned(
              bottom: 5,
              left: 10,
              child: Text(
                "Motinhaa",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 190,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(
                  "https://i.ytimg.com/vi/Oqdt0y3iTHc/maxresdefault.jpg",
                ).image,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phantons Team",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 0.9,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "há 5 minutos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 0.9,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: const Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "325",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 0.9),
                    ),
                  ],
                ),
                SizedBox(width: 25),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.comment,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "53 Comentários",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      "Stories",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(""),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => buildStoryCard(stories.first),
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      "Postagens",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(""),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) => buildPostCard(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton:
          // FloatingActionButton(
          //   onPressed: () {},
          //   child: Icon(Icons.add),
          // )
          SpeedDial(
        icon: Icons.add,
        spacing: 10,
        spaceBetweenChildren: 3,
        childPadding: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.post_add),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            label: 'Post',
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          SpeedDialChild(
            child: const Icon(Icons.post_add),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            label: 'Stories',
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ],
      ),
    );
  }
}
