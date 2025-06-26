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
|  Tabs Markets Type
|
|--------------------------------------------------------------------------
*/

class TabsMarketsType extends StatelessWidget {
  const TabsMarketsType({
    super.key,
    required this.typeInfo,
    required this.typeActivetd,
  });
  final dynamic typeInfo;
  final String typeActivetd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width:
          (typeInfo.id == '0' || typeInfo.id == null)
              ? 60
              : (MediaQuery.of(context).size.width / 2) - 7 - 45,
      decoration: BoxDecoration(
        //shape: BoxShape.circle,
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(50),
      ),
      child:
          (typeInfo.id == '0')
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'الكل',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          (typeInfo.id == typeActivetd)
                              ? Colors.deepOrange
                              : Colors.black,
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Image(image: AssetImage('${typeInfo.img}')),
                  ),
                  Text(
                    '${typeInfo.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          (typeInfo.id == typeActivetd)
                              ? Colors.deepOrange
                              : Colors.black,
                    ),
                  ),
                ],
              ),
    );
  }
}
