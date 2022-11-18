import 'package:debounce/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ButtonTextSize { small, medium, large }

class Button extends StatefulWidget {
  const Button(
      {super.key,
      required this.text,
      this.onClick,
      this.leftColor,
      this.rightColor,
      this.bgColor,
      this.child,
      this.width,
      this.height,
      this.scale,
      this.fontSize = ButtonTextSize.medium,
      this.disabled = false});

  final String text;
  final Color? leftColor;
  final Color? rightColor;
  final Color? bgColor;
  final Function? onClick;
  final Widget? child;
  final double? width;
  final double? height;
  final bool? scale;
  final ButtonTextSize fontSize;
  final bool disabled;

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isHovering = false;

  Color colorBg() {
    if (widget.disabled) return const Color(0xff838383);

    final color = widget.bgColor ?? blackPrimary;
    return isHovering ? color.withOpacity(0.85) : color;
  }

  TextStyle? get textStyle {
    switch (widget.fontSize) {
      case ButtonTextSize.small:
        return Get.textTheme.bodySmall?.copyWith(color: Colors.white);
      case ButtonTextSize.large:
        return Get.textTheme.bodyLarge?.copyWith(color: Colors.white);
      case ButtonTextSize.medium:
      default:
        return Get.textTheme.bodyMedium?.copyWith(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onClick == null) return _content;

    return InkWell(
      onTap: () {
        if (!widget.disabled) {
          widget.onClick!();
        }
      },
      onHover: (hover) {
        setState(() {
          isHovering = hover;
        });
      },
      child: _content
    );
  }

  Widget get _content {
    return Container(
      width: (widget.width ?? 200),
      height: (widget.height ?? 36),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colorBg(), borderRadius: const BorderRadius.all(Radius.circular(8.0))),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          if (widget.child != null) const SizedBox(width: 4),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}
