import 'package:flutter/material.dart';

const lightIndigo = Color(0xFF353982);
final darkIndigo = Colors.indigo.shade800;
const lightError = Color(0xFFFF7660);
final darkError = Colors.red.shade300;

const offlineChip = Colors.grey;
const pendingChip = Color(0xFFFFCE50);
const idleChip = Color(0xFFCAE7C1);
const engagingChip = Color(0xFF03D8AE);
const capturingChip = Color(0xFFBBDEFB);
const verifyingChip = Color(0xFF79D2E6);
const acceptChip = Color(0xFF71D05E);
const rejectChip = lightError;

final lightScheme =
    ColorScheme.fromSeed(seedColor: lightIndigo, error: lightError);
final darkScheme =
    ColorScheme.fromSeed(seedColor: darkIndigo, error: darkError);
