import 'package:blog_app/pages/home_page/home_page.dart';
import 'package:blog_app/theme/app_decoration.dart';
import 'package:blog_app/theme/app_style.dart';
import 'package:blog_app/utils/size_utils.dart';
import 'package:blog_app/widget/bar_button.dart';
import 'package:blog_app/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreatePage extends StatelessWidget {
  String subTitle;
  String body;
  String title;

  CreatePage(
      {Key? key,
      required this.body,
      required this.title,
      required this.subTitle})
      : super(key: key);

  final formKeyMain = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  void createBlogPost(
      BuildContext context, String title, String subTitle, String? body) {
    final GraphQLClient client = GraphQLProvider.of(context).value;

    final String createBlogPostMutation = '''
    mutation CreateBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
      createBlog(title: \$title, subTitle: \$subTitle, body: \$body) {
        success
        blogPost {
          id
          title
          subTitle
          body
          dateCreated
        }
      }
    }
  ''';

    client
        .mutate(
      MutationOptions(
        document: gql(createBlogPostMutation),
        variables: {'title': title, 'subTitle': subTitle, 'body': body},
      ),
    )
        .then((result) {
      if (result.hasException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error creating blog post: ${result.exception.toString()}'),
          ),
        );
      } else if (result.data?['createBlog']['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Blog post created successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create blog post'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating blog post: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: getPadding(
              top: 35,
            ),
            child: Column(
              children: [
                Form(
                  key: formKeyMain,
                  child: Padding(
                    padding: getPadding(
                      left: 20,
                      right: 19,
                      bottom: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(
                            top: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Title",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtSatoshiLight13Gray900
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              CustomTextFormField(
                                width: getHorizontalSize(
                                  160,
                                ),
                                focusNode: FocusNode(),
                                autofocus: true,
                                controller: titleController,
                                hintText: "title",
                                margin: getMargin(
                                  top: 7,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 29,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "SubTitie",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtSatoshiLight13Gray900
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              CustomTextFormField(
                                width: getHorizontalSize(160),
                                focusNode: FocusNode(),
                                autofocus: true,
                                controller: subTitleController,
                                hintText: "title",
                                margin: getMargin(
                                  top: 7,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 29,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "body",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtSatoshiLight13Gray900
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              CustomTextFormField(
                                maxLines: 4,
                                focusNode: FocusNode(),
                                autofocus: true,
                                controller: bodyController,
                                hintText: "content",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a content';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                margin: getMargin(
                                  top: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BarButton(
                  margin: getMargin(
                    left: 21,
                    top: 13,
                    right: 21,
                    bottom: 12,
                  ),
                  onTap: () {
                    createBlogPost(context, title, subTitle, body);
                  },
                  text: 'Post',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
