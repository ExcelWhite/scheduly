import 'package:flutter/material.dart';

class AnimatePageSlide{
  BuildContext context;

  AnimatePageSlide(this.context);

  void animatedPageSlide (Widget page){
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}
}

class ScaleAnimation extends StatelessWidget{
  final Widget child;
  final Duration duration;

  const ScaleAnimation({
    super.key, 
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context){
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.1, end: 1), 
      duration: duration, 
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

}