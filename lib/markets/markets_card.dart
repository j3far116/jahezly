import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/markets_model.dart';

class MarketCard extends StatelessWidget {
  const MarketCard(this.marketInfo, {super.key});

  final Markets marketInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withValues(alpha: 0.3),
                  blurRadius: 10, // soften the shadow
                  spreadRadius: -7, //extend the shadow
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (marketInfo.cover == null)
                      ? Image.asset(
                        'assets/images/cover.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 120,
                      )
                      : CachedNetworkImage(
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: 'https://jahezly.net/admincp/upload/${marketInfo.cover}',
                      ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 5, 110, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${marketInfo.name}',
                          style: const TextStyle(fontSize: 20, fontFamily: 'jahezlyBold'),
                        ),
                        Text(
                          '${marketInfo.disc}',
                          style: TextStyle(fontSize: 14, color: Colors.blueGrey[400]),
                        ),
                        /* Text('${marketInfo.disc}',
                          style: TextStyle(
                              fontSize: 14, color: Colors.blueGrey[400])), */
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  Container(height: 5),
                ],
              ),
            ),
          ),
        ),
        /* Positioned(
          top: 135,
          left: 25,
          child: Container(
            width: 60,
            height: 15,
            color: Colors.green.shade200,
            child: null,
          )),
      Positioned(
          top: 155,
          left: 25,
          child: Container(
            width: 60,
            height: 15,
            color: Colors.deepOrange.shade200,
            child: null,
          )), */
        Positioned(
          bottom: 25,
          right: 30,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade300,
                  blurRadius: 10, // soften the shadow
                  spreadRadius: -7, //extend the shadow
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipOval(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child:
                          (marketInfo.logo == null)
                              ? Image.asset('assets/images/cover.png', fit: BoxFit.cover)
                              : CachedNetworkImage(
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: 'https://jahezly.net/admincp/upload/${marketInfo.logo}',
                              ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        /* const Positioned(top: 15, left: 25, child: Text('Favo')),
      const Positioned(top: 165, left: 25, child: Text('Rate')),
      const Positioned(top: 185, left: 25, child: Text('Dilevry, Address')) */
      ],
    );
  }
}
