import 'package:flutter/material.dart';
import 'package:social_network/styling/styles.dart';

class NoDataTile extends StatelessWidget {
  const NoDataTile({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Styles.animationDuration,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, _) => Opacity(
        opacity: value,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.blur_on,
                size: 200.0,
                color: (Theme.of(context).iconTheme.color == Colors.black) ? Colors.grey : Colors.white,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 100.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
