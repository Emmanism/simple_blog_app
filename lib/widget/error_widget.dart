import 'package:flutter/material.dart';

class ResponsiveErrorWidget extends StatelessWidget {
  final String errorMessage;
  final String buttonText;
  final VoidCallback onRetry;
  final bool fullPage;

  ResponsiveErrorWidget({
    required this.errorMessage,
    required this.onRetry,
    this.fullPage = false,
    this.buttonText = 'Try Again',
  });

  

  @override
  Widget build(BuildContext context) {
    bool isServerError = errorMessage.contains('HttpException');
    return SafeArea(
      child: Center(
        child: Container(
          width: fullPage
              ? MediaQuery.of(context).size.width 
              : MediaQuery.of(context).size.width ,
          height: fullPage
              ? MediaQuery.of(context).size.height 
              : MediaQuery.of(context).size.height , 
          color: Colors.red.withOpacity(0.1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                   isServerError ? 'Server Error' : 'An error occurred: $errorMessage',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16), 
                ),
                SizedBox(height: 20), 
                ElevatedButton(
                  onPressed: onRetry,
                  child: Text(buttonText,
                      style: TextStyle(fontSize: 14)), 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
