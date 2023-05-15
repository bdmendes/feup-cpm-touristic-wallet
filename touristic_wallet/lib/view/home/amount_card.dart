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
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              right: -15,
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
                            height: 120,
                            width: 200,
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
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: widget.amount.color,
                      shape: BoxShape.circle
                      ),
                    ),
                    Text('${widget.amount.value} ${widget.amount.currency}'),
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
