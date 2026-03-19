import 'package:flutter/material.dart';

abstract class Guard {
  Future<bool> canActivate(BuildContext context);
  String? get redirectTo;
}