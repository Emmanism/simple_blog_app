import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/pages/createPage/create_page.dart';
import 'package:blog_app/pages/individual_page/individual_page.dart';
import 'package:blog_app/pages/query_document_provider.dart';
import 'package:blog_app/pages/update/update_page.dart';
import 'package:blog_app/queries/queries.dart';
import 'package:blog_app/utils/size_utils.dart';
import 'package:blog_app/widget/app_search_bar.dart';
import 'package:blog_app/widget/bar_button.dart';
import 'package:blog_app/widget/custom_loading_widget.dart';
import 'package:blog_app/widget/error_widget.dart';
import 'package:blog_app/widget/helpers.dart';
import 'package:blog_app/widget/query_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isLoading = false;
  var error = '';

  String? subTitle;
  String? body;
  String? title;
  String? blogId;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  Widget getDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat.yMMMMd().format(now);
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        formattedDate,
        style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 19,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  void deleteBlogPost(BuildContext context, String blogId) {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    final String deleteBlogPostMutation = '''
      mutation DeleteBlogPost(\$blogId: String!) {
        deleteBlog(blogId: \$blogId) {
          success
        }
      }
    ''';

    client
        .mutate(
      MutationOptions(
        document: gql(deleteBlogPostMutation),
        variables: {'blogId': blogId},
      ),
    )
        .then((result) {
      if (result.hasException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error deleting blog post: ${result.exception.toString()}'),
          ),
        );
      } else if (result.data?['deleteBlog']['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Blog post deleted successfully'),
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Blog post was not deleted'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting blog post: $error'),
        ),
      );
    });
  }

  Widget getImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Blog",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
          ),
          BarButton(
            margin: getMargin(
              left: 21,
              top: 13,
              //  right: 21,
              bottom: 12,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatePage(
                    title: title ?? '',
                    subTitle: subTitle ?? '',
                    body: body ?? '',
                  )));
            },
            text: 'Create',
          ),
        ],
      );

  Widget getListItem(BlogModel blog) {
    return Container(
      margin: EdgeInsets.only(right: 30),
      height: 350,
      width: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
        image: DecorationImage(
            image: NetworkImage(Helpers.randomPictureUrl()), fit: BoxFit.cover),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdatePage(
                               title: title ?? '',
                               subTitle: subTitle ?? '',
                               body: body ?? '',
                               blogId: blogId ?? '',
                                )));
                      },
                      child: Icon(
                        Icons.create,
                        color: Colors.white,
                        size: 28,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        deleteBlogPost(context, blog.id);
                      },
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 28,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Container(
                  width: 300,
                  child: Text(
                    blog.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 10),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(12, 12)),
                            image: DecorationImage(
                                image: NetworkImage(Helpers.randomPictureUrl()),
                                fit: BoxFit.cover)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        width: 200,
                        child: Text(blog.subTitle,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          timeago.format(DateTime.parse(blog.dateCreated)),
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget popularWidget(BlogModel blog) => Container(
        child: Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(12, 12)),
                    image: DecorationImage(
                      image: NetworkImage(Helpers.randomPictureUrl()),
                    ))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      blog.title,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      blog.subTitle,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.access_time, size: 18),
                              onPressed: null),
                          Text(
                            timeago.format(DateTime.parse(blog.dateCreated)),
                            style: TextStyle(fontSize: 14),
                          ),
                          Padding(padding: EdgeInsets.only(left: 12)),
                          Icon(
                            Icons.thumb_up,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                          Padding(padding: EdgeInsets.only(left: 12)),
                          Text(
                            '786',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final String fetchAllBlogsQuery = '''
    query {
      allBlogPosts {
        id
        title
        subTitle
        body
        dateCreated
      }
    }
  ''';
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: SafeArea(
          child: Query(
              options: QueryOptions(
                document: gql(fetchAllBlogsQuery),
                fetchPolicy: FetchPolicy.cacheAndNetwork,
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return ResponsiveErrorWidget(
                      errorMessage: result.hasException.toString(),
                      onRetry: onRefresh);
                }

                if (result.isLoading) {
                  return Center(
                    child: CustomLoadingWidget(
                      animationController: animationController,
                    ),
                  );
                }
                final List<dynamic> data = result.data?['allBlogPosts'] ?? [];
                final List<BlogModel> blogs =
                    data.map((json) => BlogModel.fromJson(json)).toList();
                return Container(
                    height: 800,
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                          getImage(),
                          SizedBox(height: 2),
                          getDate(),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              child: AppbarSearchview(hintText: "Search"),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                              width: 510,
                              height: 380,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: blogs.length,
                                      itemBuilder: (context, index) {
                                        final BlogModel blog = blogs[index];
                                        return SingleChildScrollView(
                                            child: InkWell(
                                                hoverColor: Colors.white70,
                                                enableFeedback: true,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              IndividualPage()));
                                                },
                                                child: getListItem(blog)));
                                      }))),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Popular",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                "Show all",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.deepOrange),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 500,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: blogs.length,
                                        itemBuilder: (context, index) {
                                          final BlogModel blog = blogs[index];
                                          return InkWell(
                                              hoverColor: Colors.white70,
                                              enableFeedback: true,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            IndividualPage()));
                                              },
                                              child: popularWidget(blog));
                                        }))),
                          ]),
                        ])));
              }),
        ));
  }
}
