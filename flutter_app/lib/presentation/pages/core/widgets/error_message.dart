import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/core/failures.dart';

class ErrorMessage extends StatelessWidget {
  /// a text to show as error
  final String? errorText;

  /// we can have fun working with failures
  final NetWorkFailure? netWorkFailure;

  const ErrorMessage({this.errorText, this.netWorkFailure});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorText ?? 'error'));
  }
}
