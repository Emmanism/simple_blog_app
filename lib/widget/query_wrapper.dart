import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/model/error.dart';
import 'package:blog_app/queries/queries.dart';
import 'package:blog_app/widget/custom_loading_widget.dart';
import 'package:blog_app/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class QueryWrapper<T> extends StatefulWidget {
  const QueryWrapper({
    Key? key,
    required this.queryString,
    required this.contentBuilder,
    required this.dataParser,
    this.variables,
  }) : super(key: key);
  final Map<String, dynamic>? variables;
  final String queryString;
  final Widget Function(List<BlogList> data) contentBuilder;
  final List<BlogList> Function(List<dynamic> data) dataParser;

  @override
  State<QueryWrapper<T>> createState() => _QueryWrapperState<T>();
}

class _QueryWrapperState<T> extends State<QueryWrapper<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

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

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          document: gql(widget.queryString),
          variables: widget.variables ?? const {},
          parserFn: (response) {
            final dataMap = response['allBlogPosts'];
            return widget.dataParser(dataMap);
          },
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                height: 500,
                child: Center(
                  child: CustomLoadingWidget(
                    animationController: animationController,
                  ),
                ),
              ),
            );
          }

          if (result.hasException) {
            print('Error message: ${result.exception.toString()}');
            return ResponsiveErrorWidget(
              errorMessage: ErrorModel.fromString(
                result.exception.toString(),
              ).error,
              onRetry: GraphQLQueries().fetchAllBlogs,
              fullPage: true,
            );
          }
          final dataMap = result.data?['allBlogPosts'];
          print(dataMap);

          if (dataMap != null) {
            final parsedData = widget.dataParser(dataMap);
            return widget.contentBuilder(parsedData);
          }

          return const SizedBox(); // Placeholder for empty data case
        });
  }
}
