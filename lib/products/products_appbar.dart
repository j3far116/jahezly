import 'package:flutter/material.dart';
import '../models/markets_model.dart';

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
class ProdectsAppBar extends StatelessWidget {
  const ProdectsAppBar(this.marketInfo, {super.key});

  final Markets marketInfo;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (BuildContext context, constraints) {
        //final scrolled = constraints.scrollOffset > 170;
        var expandedHeight = 0;
        var aa = (expandedHeight - constraints.scrollOffset);
        var aa2 = (expandedHeight / 2 - (aa - constraints.scrollOffset)) / 100;

        var aa3 = 0.0;
        if (aa2 < 0) {
          aa3 = 0.0;
        } else if (aa2 > 1) {
          aa3 = ((aa2 - 1) > 1.0) ? 1.0 : aa2 - 1;
        }

        //
        //debugPrint('$aa2 -> $aa3');
        //if (scrolled) {
        return SliverAppBar(
          expandedHeight: 100,
          toolbarHeight: 50,
          collapsedHeight: 50,
          title: Opacity(opacity: aa3, child: Text('${marketInfo.name}')),

          surfaceTintColor: Color.fromRGBO(255, 255, 255, aa3),
          backgroundColor: Color.fromRGBO(255, 255, 255, aa3),
          pinned: true,
        );
      },
    );
  }
}
