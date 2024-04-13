import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQClient {
  
  static final HttpLink httpLink = HttpLink(
     'https://uat-api.vmodel.app/graphql/api/v1/'
  );

  static final _authLink = AuthLink(
    getToken: () async => 'Bearer $token',
  );

  static String token = '';

   static final Link link = _authLink.concat(httpLink);


    ValueNotifier<GraphQLClient> initializeClient() {
    final policies = Policies(
      fetch: FetchPolicy.networkOnly,
    );

   final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(
        //  store: HiveStore(box: Box()'blog_posts')
        ),
        link: link,
        defaultPolicies: DefaultPolicies(
          watchQuery: policies,
          query: policies,
          mutate: policies,
        ),
    )
     
    );
    return client;
   }
 
}

/* 

class ApiClient {
  final HttpLink _httpLink = HttpLink('https://uat-api.vmodel.app/graphql/api/v1/');

  final GraphQLClient client;

  ApiClient() : 
    client = GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(),
    );
} */