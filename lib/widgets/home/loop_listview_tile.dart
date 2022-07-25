import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/models/loop.dart';
import 'package:social_network/widgets/main_widgets/main_container.dart';

class LoopListViewTile extends StatefulWidget {
  const LoopListViewTile({Key? key, required this.loop}) : super(key: key);

  final Loop loop;

  @override
  State<LoopListViewTile> createState() => _LoopListViewTileState();
}

class _LoopListViewTileState extends State<LoopListViewTile> {
  bool blurEffect = false;

  @override
  Widget build(BuildContext context) {
    var loop = widget.loop;

    void openLoop() {}

    void onEffect() {
      setState(() {
        blurEffect = !blurEffect;
      });
    }

    void onEffectEnd() {
      setState(() {
        blurEffect = !blurEffect;
      });
    }

    return MainContainer(
      width: 80.0,
      height: 80.0,
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      pressable: true,
      onPressed: openLoop,
      onEffect: onEffect,
      onEffectEnd: onEffectEnd,
      child: Center(
        child: Container(
          width: 70.0,
          height: 70.0,
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("development_assets/images/profile_image.jpg"), fit: BoxFit.cover),
              shape: BoxShape.circle),
          child: GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: (loop.userId == Auth().getUserId())
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                          ),
                          const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 50.0,
                            ),
                          )
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: (blurEffect) ? 5.0 : 0.0),
                          duration: const Duration(milliseconds: 100),
                          builder: (context, value, child) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
