import 'package:flutter/material.dart';

/*
|--------------------------------------------------------------------------
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|  AppBar In Products Screen
|
|--------------------------------------------------------------------------
*/
class ProdectsNavBar extends StatelessWidget {
  const ProdectsNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
          decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
          child: Container(
            width: 100,
            height: 120,
            color: Colors.red,
            child: Transform.translate(
              offset: Offset(0, -30), // تحريك العنصر خارج حدود الأب
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
