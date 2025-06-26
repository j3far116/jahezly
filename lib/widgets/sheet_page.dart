import 'package:flutter/material.dart';

/*
|--------------------------------------------------------------------------
| ***********************************************************************
|
|
|
|
|
|
|
|
| Shet Page Modal
|

|--------------------------------------------------------------------------
*/

class J3SheetPage extends StatelessWidget {
  const J3SheetPage({super.key, this.height, required this.child});

  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}
