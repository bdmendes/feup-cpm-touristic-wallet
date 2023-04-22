import 'package:flutter/cupertino.dart';

import '../../model/amount.dart';

class AmountDialog extends StatefulWidget {
  const AmountDialog({super.key, this.savedAmount});

  final Amount? savedAmount;

  @override
  State<StatefulWidget> createState() {
    return AmountDialogState();
  }
}

class AmountDialogState extends State<AmountDialog> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Amount Dialog'));
  }
}