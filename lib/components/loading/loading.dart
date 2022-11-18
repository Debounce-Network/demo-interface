import 'package:debounce/styles.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  final double? radius;
  final Color? color;

  const Loading({super.key, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: radius ?? 16.0, color: color ?? blackHover);
  }
}
