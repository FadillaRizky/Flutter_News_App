import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/news_web_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> future;
  late Future<List<Article>> futureCarousel;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY",
  ];

  int pageSize = 10;
  bool loading = true;
  RefreshController refreshC = RefreshController();
  List<Article> result = [];

  late String selectedCategory;

  refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    pageSize = 10;
    future = getNewsData();
    setState(() {});
    refreshC.refreshCompleted();
  }

  void loadData() async {
    pageSize += 10;
    future = getNewsData();
    setState(() {});
    refreshC.loadComplete();
  }

  @override
  void initState() {
    selectedCategory = categoryItems[0];
    future = getNewsCarousel();
    futureCarousel = getNewsData();

    super.initState();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI("b8474ae85c144fca86976e628d46626d");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: selectedCategory,
      pageSize: pageSize,
    );
  }

  Future<List<Article>> getNewsCarousel() async {
    NewsAPI newsAPI = NewsAPI("b8474ae85c144fca86976e628d46626d");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: "GENERAL",
      pageSize: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? searchAppBar() : appBar(),
      body: SafeArea(
          child: Column(
        children: [
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error loading the news"),
                );
              } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return _buildNewsCarousel(snapshot.data as List<Article>);
                } else {
                  return const Center(
                    child: Text("No news available"),
                  );
                }
              }
            },
            future: futureCarousel,
          ),
          _buildCategories(),
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading the news"),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return _buildNewsListView(snapshot.data as List<Article>);
                  } else {
                    return const Center(
                      child: Text("No news available"),
                    );
                  }
                }
              },
              future: future,
            ),
          )
        ],
      )),
    );
  }

  searchAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
            future = getNewsData();
          });
        },
      ),
      title: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                searchTerm = searchController.text;
                future = getNewsData();
              });
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      title: const Text("News App",style: TextStyle(color: Colors.white),),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearching = true;
              });
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  Widget _buildNewsCarousel(List<Article> articleList) {
    return CarouselSlider(
      items: articleList.map((i) {
        return Builder(
          builder: (BuildContext context) {

            return GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsWebView(url: i.url!),
                    ));
              },
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        "${i.urlToImage}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment(0, 1),
                          colors: <Color>[
                            Color(0x494949),
                            Color(0xFF505050),
                          ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5,
                    bottom: 7,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 9),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${i.title}",style: TextStyle(color: Colors.white,fontSize: 18),maxLines: 1,),
                          Text(
                              "${i.description}",style: TextStyle(color: Colors.white,fontSize: 12),maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,

      ),
    );
  }

  Widget _buildNewsListView(List<Article> articleList) {
    return SmartRefresher(
      controller: refreshC,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: refreshData,
      onLoading: loadData,
      child: ListView.builder(
        itemBuilder: (context, index) {
          Article article = articleList[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(seconds: 1),
            child: SlideAnimation(
              verticalOffset: 44.0,
              child: FadeInAnimation(child: _buildNewsItem(article)),
            ),
          );
        },
        itemCount: articleList.length,
      ),
    );
  }

  Widget _buildNewsItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsWebView(url: article.url!),
            ));
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(
                  article.urlToImage ?? "",
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title!,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    article.source.name!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCategory = categoryItems[index];
                  future = getNewsData();
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                categoryItems[index] == selectedCategory
                    ? Colors.green.withOpacity(0.5)
                    : Colors.green,
              )),
              child: Text(categoryItems[index]),
            ),
          );
        },
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
