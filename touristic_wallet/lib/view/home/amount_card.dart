import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/amount.dart';
import '../../provider/amounts_provider.dart';
import '../../provider/currencies_provider.dart';
import 'amount_dialog.dart';

class AmountCard extends StatefulWidget {
  const AmountCard({super.key, required this.amount});

  final Amount amount;

  @override
  State<StatefulWidget> createState() {
    return AmountCardState();
  }
}

class AmountCardState extends State<AmountCard> {
  @override
  Widget build(BuildContext context) {
    final amountsProvider =
        Provider.of<AmountsProvider>(context, listen: false);
    final currenciesProvider =
        Provider.of<CurrenciesProvider>(context, listen: false);
    return Card(
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              right: -6,
              child: FutureBuilder(
                  future: currenciesProvider.findCurrency(widget.amount.currency),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                            ).createShader(Rect.fromLTRB(0, 0, rect.width*1.5, rect.height));
                          },
                          blendMode: BlendMode.dstIn,
                          child: CachedNetworkImage(
                            height: 100,
                            fit: BoxFit.fill,
                            alignment: Alignment.centerRight,
                            imageUrl: snapshot.data?.icon ?? '',
                            errorWidget: (context, url, error) => const SizedBox(),
                          ),
                      );
                    }
                    return const SizedBox();
                  }
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                width: 10,
                height: 100,
                decoration: BoxDecoration(
                    color: widget.amount.color,
                    shape: BoxShape.rectangle,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30, right: 10, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text('${widget.amount.value} ${widget.amount.currency}', style: const TextStyle(fontSize: 17)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  AmountDialog(savedAmount: widget.amount));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          amountsProvider.removeAmount(widget.amount);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ))
          ]
        ));
  }
}
