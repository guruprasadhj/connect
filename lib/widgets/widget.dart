import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class bgWidget extends StatefulWidget {
  const bgWidget({Key? key}) : super(key: key);

  @override
  State<bgWidget> createState() => _bgWidgetState();
}

class _bgWidgetState extends State<bgWidget>
    with SingleTickerProviderStateMixin {
  final Tween<double> _tween1 = Tween(begin: 0.3, end: 0.5);
  final Tween<double> _tween2 = Tween(begin: 0.3, end: 0.5);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        (currentWidth > 600)
            ? Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff7bd5f5),
                      Color(0xff787ff6),
                    ],
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xff7bd5f5),
                      Color.fromARGB(255, 213, 244, 255),
                      Color(0xff787ff6),
                    ],
                  ),
                ),
              ),
        if (currentWidth > 600)
          Positioned(
            right: 0,
            top: 0,
            child: ScaleTransition(
              scale: _tween1.animate(_animation),
              child: Container(
                width: currentHeight / 2,
                height: currentHeight / 2,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        if (currentWidth > 600)
          Positioned(
            left: currentWidth / 3,
            top: currentHeight / 1.7,
            child: ScaleTransition(
              scale: _tween2.animate(_animation),
              child: Container(
                width: currentHeight / 2,
                height: currentHeight / 2,
                //height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        if (currentWidth > 600)
          Positioned(
            left: 0,
            top: 0,
            child: ScaleTransition(
              scale: _tween2.animate(_animation),
              child: Container(
                width: currentHeight / 1.5,
                height: currentHeight / 1.5,
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        if (currentWidth > 600)
          Positioned(
            right: currentWidth / 7,
            top: currentHeight / 1.6,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: currentHeight / 4,
                height: currentHeight / 4,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        SafeArea(
          child: Center(
            child: Padding(
              padding:
                  currentWidth < 600 ? EdgeInsets.all(0) : EdgeInsets.all(8.0),
              child: currentWidth < 600
                  ? Container(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)),
                        ),
                      ),
                    )
                  : GlassmorphicContainer(
                      width: 1190,
                      height: 600,
                      borderRadius: 50,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.3),
                            const Color(0xFFFFFFFF).withOpacity(0.3),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(0.5),
                          const Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
