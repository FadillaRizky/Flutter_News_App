import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:news_api_flutter_package/model/article.dart';

import 'news_web_view.dart';

class BacaNanti extends StatefulWidget {
  final String idUser;

  const BacaNanti({Key? key, required this.idUser}) : super(key: key);

  @override
  State<BacaNanti> createState() => _BacaNantiState();
}

class _BacaNantiState extends State<BacaNanti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baca Nanti"),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child("user")
            .child(widget.idUser)
            .child(DateFormat('yyyy-MM', "id").format(DateTime.now()))
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && (snapshot.data!).snapshot.value != null) {
            return buildListReadLater(snapshot);
          }
          if (snapshot.hasData) {
            return Center(
              child: Text("Tidak ada Berita"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView buildListReadLater(AsyncSnapshot<DatabaseEvent> snapshot) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        // Article article = snapshot.data[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(seconds: 1),
          child: SlideAnimation(
            verticalOffset: 44.0,
            child: FadeInAnimation(
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => NewsWebView(url: snapshot.data[index].url!),
                  //     ));
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            // article.urlToImage ?? "",
                            "-",
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, obj, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  "assets/placeholder.png",
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
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
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0x6C494949),
                                Color(0xFF505050),
                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 5,
                        bottom: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 9),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      // article.title!,
                                      "-",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      // article.author ?? "-",
                                      "-",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    // DateFormat('EEEE, dd MMMM yyyy')
                                    //     .format(DateTime.parse(article.publishedAt!)),
                                    "-",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
