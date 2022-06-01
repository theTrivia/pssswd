import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidgetForPage {
  static final loadingWidget = Text('Loading');
  static const spinkit = SpinKitThreeBounce(
    color: Colors.black,
    size: 40.0,
  );
}
