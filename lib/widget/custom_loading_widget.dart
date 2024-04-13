import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  final AnimationController animationController;

  CustomLoadingWidget({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 500,
          color: Colors.white,
          child: Center(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animationController.value * 2 * 3.14159265,
                  child: child,
                );
              },
              child: Image.asset('assets/images/logo.png', height: 100),
            ),
          ),
        ),
      ),
    );
  }
}
