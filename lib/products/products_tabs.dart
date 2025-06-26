import 'package:flutter/material.dart';
import '../widgets/colors.dart';

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

class ProductsTabs extends SliverPersistentHeaderDelegate {
  ProductsTabs({required this.controller, required this.data});

  final TabController controller;
  final List<dynamic> data;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TabBar(
            controller: controller,
            isScrollable: true,
            labelPadding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
            indicatorWeight: 4,
            tabAlignment: TabAlignment.start,
            indicatorColor: J3Colors('Orange').color,
            onTap: (index) {
              GlobalKey globalKey = data[index]['key'];
              Scrollable.ensureVisible(
                globalKey.currentContext!,
                duration: const Duration(milliseconds: 250),
              );
            },
            tabs: List.generate(
              data.length,
              (index) => SizedBox(
                height: constraints.maxHeight,
                child: Text(
                  '${data[index]['label']}',
                  textAlign: TextAlign.end,
                  style: TextStyle(color: J3Colors('Orange').color),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
