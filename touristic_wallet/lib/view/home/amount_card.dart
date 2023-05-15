import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/amount.dart';
import '../../provider/amounts_provider.dart';
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
    return Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
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
            )));
  }
}
