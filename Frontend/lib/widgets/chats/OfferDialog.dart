import 'package:flutter/material.dart';

class OfferDialog extends StatelessWidget {
  final bool offerMade;
  final Function(bool) onOfferStatusChange;

  const OfferDialog({
    Key? key,
    required this.offerMade,
    required this.onOfferStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(offerMade ? 'Cancel Offer' : 'Make Offer'),
      content: Text(offerMade ? 'Are you sure you want to cancel the offer?' : 'Are you sure you want to make the offer? Keep in mind that there is a 2-week notice period if the renter accepts and you need to terminate the contract early.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back'),
        ),
        ElevatedButton(
          onPressed: () {
            onOfferStatusChange(!offerMade);
            Navigator.pop(context);
          },
          child: Text(offerMade ? 'Cancel Offer' : 'Make Offer'),
        ),
      ],
    );
  }
}