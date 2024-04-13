import 'package:blog_app/model/error.dart';
import 'package:blog_app/queries/queries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class QueriesDocumentProvider extends InheritedWidget {
  const QueriesDocumentProvider(
      {Key? key, required this.queries, required Widget child})
      : super(key: key, child: child);

  final GraphQLQueries queries;

  static  GraphQLQueries of(BuildContext context) {
    final InheritedElement? element = context
        .getElementForInheritedWidgetOfExactType<QueriesDocumentProvider>();
    assert(element != null, 'No BlogQueries found in context');
    return (element!.widget as QueriesDocumentProvider).queries;
  }

  @override
  bool updateShouldNotify(QueriesDocumentProvider oldWidget) =>
      queries != oldWidget.queries;
}

extension BuildContextExtension on BuildContext {
  GraphQLQueries get queries => QueriesDocumentProvider.of(this);

  GraphQLClient get graphQlClient => GraphQLProvider.of(this).value;

  void cacheGoogleId(String googleId) {
    graphQlClient.cache.writeNormalized('AppData', {'googleId': googleId});
  }

 String get retrieveGoogleId =>
      graphQlClient.cache.store.get('AppData')!['googleId'];

  void showError(ErrorModel error) {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      var theme = Theme.of(this);
      ScaffoldMessenger.of(this).showMaterialBanner(
        MaterialBanner(
          backgroundColor: theme.colorScheme.primary,
          contentTextStyle:
              theme.textTheme.headline5!.copyWith(color: Colors.white),
          content: Text(error.error),
          actions: [
            InkWell(
              onTap: () => ScaffoldMessenger.of(this).clearMaterialBanners(),
              child: const Icon(Icons.close, color: Colors.white),
            )
          ],
        ),
      );
    });
  }
}
