import 'package:blog_app/pages/home_page/home_page.dart';
import 'package:blog_app/utils/size_utils.dart';
import 'package:blog_app/widget/custom_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BarButton extends StatelessWidget {
  BarButton({
    Key? key,
    this.margin,
    this.text,
    required this.onTap,
  }) : super(
          key: key,
        );

  EdgeInsetsGeometry? margin;

  String? text;

  Function onTap;

 static  bool  homepage = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomButton(
          height: getVerticalSize(
            32,
          ),
          width: getHorizontalSize(
            70,
          ),
          text:  text,
          variant: ButtonVariant.FillCyan300,
          padding: ButtonPadding.PaddingAll4,
        ),
      ),
    );
  }
}
