import 'package:blog_app/utils/size_utils.dart';
import 'package:blog_app/widget/custom_image_view.dart';
import 'package:blog_app/widget/custom_search_view.dart';
import 'package:blog_app/widget/image_constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppbarSearchview extends StatelessWidget {
  AppbarSearchview({
    Key? key,
    this.hintText,
    this.controller,
    this.margin,
    this.onSubmitted,
    this.onTap

  }) : super(
          key: key,
        );

  String? hintText;

  TextEditingController? controller;

  EdgeInsetsGeometry? margin;

  Function(String)? onSubmitted;

  final VoidCallback? onTap; 

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomSearchView(
          width: getHorizontalSize(
            340,
          ),
          height: getVerticalSize(300),
        //  onTap: onTap,
          focusNode: FocusNode(),
          autofocus: true,
          controller: controller,
          hintText: hintText,
          prefix: Container(
            margin: getMargin(
              left: 19,
              top: 9,
              right: 10,
              bottom: 9,
            ),
            child: CustomImageView(
              svgPath: ImageConstant.imgSearch,
            ),
          ),
          prefixConstraints: BoxConstraints(
            maxHeight: getVerticalSize(
              33,
            ),
          ),
          suffix: Container(
            margin: getMargin(
              left: 30,
              top: 6,
              right: 12,
              bottom: 6,
            ),
            child: CustomImageView(
              svgPath: ImageConstant.imgSignal,
            ),
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: getVerticalSize(
              37,
            ),
          ),
        ),
      ),
    );
  }
}
