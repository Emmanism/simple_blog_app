import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/widget/custom_loading_widget.dart';
import 'package:blog_app/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class IndividualPage extends StatefulWidget {
  final String? blogId;

  IndividualPage({this.blogId});

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  var isPressed = true;


  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
  }

  bool isLoading = false;
  
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

  //mainImage
  Widget mainImageWidget(height) => Container(
        height: height / 2,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1498758536662-35b82cd15e29?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 48, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              IconButton(
                icon: (isPressed)
                    ? Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: 28,
                      )
                    : Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 28,
                      ),
                onPressed: () {
                  setState(() {
                    if (isPressed == true) {
                      isPressed = false;
                    } else {
                      isPressed = true;
                    }
                  });
                },
              )
            ],
          ),
        ),
      );

  //Bottom Sheet Content

  Widget bottomContent(BlogModel blogs) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Category
                Text(
                  blogs.subTitle,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),

                SizedBox(
                  height: 12,
                ),

                //Title
                Text(
                  blogs.title,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),

                SizedBox(
                  height: 12,
                ),

                //like and duration
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      blogs.dateCreated,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.thumb_up,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "786",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                //Profile Pic
                Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://images.unsplash.com/photo-1506919258185-6078bba55d2a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      blogs.subTitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),

                //Paragraph
                Text(
                  blogs.body,
                  style: TextStyle(
                      color: Colors.black54, fontSize: 16.5, height: 1.4),
                  textAlign: TextAlign.left,
                  maxLines: 8,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final String fetchIdBlogsQuery = '''
  query getBlog(\$blogId: String!) {
    blogPost(blogId: \$blogId) {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
''';

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Query(
            options: QueryOptions(
              document: gql(fetchIdBlogsQuery),
              variables: {'blogId': widget.blogId},
              fetchPolicy: FetchPolicy.cacheAndNetwork,
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return ResponsiveErrorWidget(
                    errorMessage: result.exception.toString(),
                   onRetry: onRefresh);
              }

              if (result.isLoading) {
                return Center(
                    child: CustomLoadingWidget(
                  animationController: animationController,
                ));
                // child: CircularProgressIndicator());
              }
              final blogPost = result.data?['getBlog']['blogPost'];
                final BlogModel blogs = BlogModel.fromJson(blogPost);
              print('blogTile: $blogPost');
              return Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    mainImageWidget(height),
                    Container(
                        //Bottom Sheet Dimensions
                        margin: EdgeInsets.only(top: height / 2.3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                        ),
                        child: bottomContent(blogs)),
                  ],
                ),
              );
            }));
  }
}
