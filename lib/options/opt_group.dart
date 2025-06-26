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
| Options Group
| Make List Options With Group
|
|--------------------------------------------------------------------------
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/models/products_model.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import '../models/options_model.dart';
import '../provider/orders.dart';

class OptGroups extends StatefulWidget {
  const OptGroups({super.key, required this.provider, required this.productInfo});

  final OrderConfig provider;
  final Products productInfo;

  @override
  State<OptGroups> createState() => _OptGroupsState();
}

class _OptGroupsState extends State<OptGroups> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OptGroup>>(
      future: fetchOptions('${widget.productInfo.id}'),
      builder: (context, snapshot) {
        //if (!snapshot.hasData) return Center(child: Text('Loading...'));
        if (!snapshot.hasData) return Container();
        //
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            // .. Init GroupInfo
            // إعادة ترتيب وفرز القائمة لجعل المطلوب تظهر آعلى القائمة
            snapshot.data!.sort((a, b) => b.require!.compareTo(a.require!));
            //
            OptGroup groupInfo = snapshot.data![index];
            // .. Add Requierd Group To Provider
            Future.delayed(Duration.zero, () async {
              if (groupInfo.require == '1' && groupInfo.opt.isNotEmpty) {
                widget.provider.setOptRequired(groupInfo.id.toString());
              }
            });
            // .. Build List
            return Column(
              children: [
                // .. View Group Info Section
                (groupInfo.opt.isNotEmpty)
                    ? Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color:
                          (widget.provider.optIgnored.contains(groupInfo.id))
                              ? Colors.red
                              : Colors.blueGrey[50],
                      child: Text('${groupInfo.name!}  ->   ${groupInfo.id}'),
                    )
                    : Container(),
                // .. View List Opt
                BB(widget.productInfo.price!, groupInfo),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<OptGroup>> fetchOptions(String productId) async {
    String linkUrl = J3Config.linkApi('options');
    final response = await http.get(Uri.parse('$linkUrl?productId=$productId'));
    final data = json.decode(response.body) as List<dynamic>;
    return data.map((json) => OptGroup.fromJson(json)).toList();
  }
}

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
| **
|
|--------------------------------------------------------------------------
*/

//
//
//
//
//
class BB extends StatefulWidget {
  const BB(this.productPrice, this.optGroup, {super.key});

  final OptGroup optGroup;
  final double productPrice;

  @override
  State<BB> createState() => _BBState();
}

class _BBState extends State<BB> {
  //
  List<String> selected = [];

  //List<double> priceSelected = [];
  @override
  Widget build(BuildContext context) {
    //
    OrderConfig provider = Provider.of<OrderConfig>(context);
    //

    //
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.optGroup.opt.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  '${widget.optGroup.opt[index]['name']}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(width: 50),
              Text(widget.optGroup.opt[index]['price'].toString()),
            ],
          ),
          value: (selected.contains(widget.optGroup.opt[index]['id'])) ? true : false,
          onChanged: (value) {
            //debugPrint(selected.length.toString());
            //debugPrint(widget.optGroup.require!);
            //
            if (selected.contains(widget.optGroup.opt[index]['id'])) {
              selected.remove(widget.optGroup.opt[index]['id']);
              provider.removeTotalOpt(widget.productPrice, double.parse(widget.optGroup.opt[index]['price']));
            } else {
              if (selected.length < int.parse(widget.optGroup.max!)) {
                selected.add(widget.optGroup.opt[index]['id']);
                provider.setTotalOpt(widget.productPrice, double.parse(widget.optGroup.opt[index]['price']));
              }
            }
            provider.setOptSelected('${widget.optGroup.id}', selected);
          },
        );
      },
    );
  }
}
