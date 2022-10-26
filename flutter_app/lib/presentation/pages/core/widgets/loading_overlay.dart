import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/style.dart';

/// this class is meant to be the main loading overlay
@Deprecated("User [BasicContentContainer] instead")
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? text;
  final bool sliver;

  /// take child widget as input, as well as an boolean, to decide whether
  /// to show the loading overlay or the child widget
  LoadingOverlay(
      {Key? key, required this.child, required this.isLoading, this.text, this.sliver = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(sliver)
      return SliverToBoxAdapter(child: buildStack(),);

    ///use stack to put the overlay above
    return buildStack();
  }

  Stack buildStack() {
    return Stack(
      children: <Widget>[child, LoadingIndicator(isLoading: isLoading)]);
  }
}

class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final String text;

  const LoadingIndicator(
      {Key? key, required this.isLoading, String this.text = "loading"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isLoading,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isLoading ? AppColors.black : Colors.transparent,
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
                      color: AppColors.white,
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
