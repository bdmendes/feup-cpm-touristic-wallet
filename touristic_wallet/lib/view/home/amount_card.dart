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
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
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
