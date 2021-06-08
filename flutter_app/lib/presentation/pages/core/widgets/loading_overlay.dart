
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

/// this class is meant to be the main loading overlay
class LoadingOverlay extends StatelessWidget{

  final Widget child;
  final bool isLoading;
  final String? text;

  /// take child widget as input, as well as an boolean, to decide whether
  /// to show the loading overlay or the child widget
  LoadingOverlay({Key? key, required this.child, required this.isLoading, this.text}): super(key: key);

  @override
  Widget build(BuildContext context) {

    ///use stack to put the overlay above
    return Stack(
        children: <Widget>[
            child,
            LoadingIndicator(isLoading: isLoading)
        ]
    );
  }


}








class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final String text;

  const LoadingIndicator({
    Key? key,
    required this.isLoading,
    String this.text = "loading"
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isLoading,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isLoading ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: isLoading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}