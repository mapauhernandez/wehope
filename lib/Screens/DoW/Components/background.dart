import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 20,
            left: 0,
            child: Image.asset(
              "assets/images/wehope_logo.jpg",
              width: size.width * 0.6,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
