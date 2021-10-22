import 'package:flutter/material.dart';
import 'dart:math' as math;

class RandomImage extends StatelessWidget {
  final rand = new math.Random();
  Widget build(BuildContext context) {
    return [
      Image.asset(
        'images/01.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/02.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/03.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/04.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/05.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/06.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/07.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/08.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/09.jpeg',
        fit: BoxFit.cover,
      ),
      Image.asset(
        'images/10.jpeg',
        fit: BoxFit.cover,
      ),
    ][rand.nextInt(10)];
  }
}
