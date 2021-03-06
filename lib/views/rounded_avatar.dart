import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedAvatar extends StatefulWidget {
  const RoundedAvatar({required this.image}) : assert(image != null);

  final String image;

  @override
  _RoundedAvatarState createState() => _RoundedAvatarState();
}

class _RoundedAvatarState extends State<RoundedAvatar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(
        side: BorderSide(color: const Color(0xFFEEF1F3), width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        widget.image,
        width: 36,
        height: 36,
      ),
    );
  }
}
