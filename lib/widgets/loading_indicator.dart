import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;
  const LoadingIndicator({this.color = Colors.blue, this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: color,
        size: size,
      ),
    );
  }
}
