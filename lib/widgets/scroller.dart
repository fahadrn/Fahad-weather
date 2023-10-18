// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Scroller extends StatelessWidget {
  Widget child;
  Scroller({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: child);
  }
}
