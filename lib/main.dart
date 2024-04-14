import 'package:blog_app/pages/home_page/home_page.dart';
import 'package:blog_app/pages/query_document_provider.dart';
import 'package:blog_app/queries/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


void main(){
  runApp( MyBlog());
}


class MyBlog extends StatefulWidget {


  @override
  _MyBlogState createState() => _MyBlogState();
}

class _MyBlogState extends State<MyBlog> {
  final GraphQLClient client = GraphQLClient(
    link: HttpLink( 'https://uat-api.vmodel.app/graphql/'),
    cache: GraphQLCache(),
  );

  late final ValueNotifier<GraphQLClient> clientNotifier =
      ValueNotifier<GraphQLClient>(client);

  final queries = GraphQLQueries();


  @override
  Widget build(BuildContext context) {
    return QueriesDocumentProvider(
      queries: queries,
      child: GraphQLProvider(
        client: clientNotifier,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Montserrat',
            primaryColor: Colors.deepOrange
            ),
          title: 'Simple Blog App',
          home: HomeContainer()
        ),
      ),
    );
  }
}



class HomeContainer extends StatefulWidget {
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: (){}),
            IconButton(icon: Icon(Icons.search), onPressed: null),
            IconButton(icon: Icon(Icons.bookmark_border), onPressed: null),
            IconButton(icon: Icon(Icons.person_outline), onPressed: null),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:40.0,left: 24,right: 24,bottom: 12),
        child: SingleChildScrollView(child:  HomePage()),
      ),
    );
  }
}
