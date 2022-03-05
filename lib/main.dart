import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/pages/landing_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/landing_page/landing_page.dart';
import 'package:misty_tracer/theme/theme.dart';

void main() {
  runApp(const MistyTracer());
}

class MistyTracer extends StatelessWidget {
  const MistyTracer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Misty Tracer',
      theme: buildTheme(false),
      darkTheme: buildTheme(true),
      home: BlocProvider(
        create: (ctx) => LandingPageCubit(),
        child: const LandingPage(),
      ),
    );
  }
}
