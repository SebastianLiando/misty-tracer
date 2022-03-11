import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/main_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/main_page/cubit/state.dart';
import 'package:misty_tracer/pages/main_page/widgets/disconnect_dialog.dart';
import 'package:misty_tracer/pages/photos_page/photos_page.dart';
import 'package:misty_tracer/pages/robots_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/robots_page/robots_page.dart';
import 'package:misty_tracer/theme/icons.dart';

class MainPage extends StatefulWidget {
  final WebsocketRepository wsRepo;

  const MainPage({Key? key, required this.wsRepo}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainPageState>(
      builder: (ctx, data) => WillPopScope(
        onWillPop: () async {
          disconnect();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
            foregroundColor: Theme.of(ctx).colorScheme.primary,
            elevation: 0,
            title: data.tabIndex == 0
                ? const Text('Misty Robots')
                : const TextField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Search Location',
                      hintText: 'NTU',
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () => disconnect(),
                child: const Text('DISCONNECT'),
              ),
            ],
          ),
          body: AnimatedCrossFade(
            firstChild: BlocProvider(
              create: (context) => RobotsPageCubit(widget.wsRepo),
              child: const RobotsPage(),
            ),
            secondChild: const PhotosPage(),
            crossFadeState: data.tabIndex == 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: data.tabIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(CustomIcon.robot),
                label: 'Robots',
              ),
              NavigationDestination(
                icon: Icon(Icons.photo),
                label: 'Photos',
              ),
            ],
            onDestinationSelected: ctx.read<MainPageCubit>().onTabChange,
          ),
        ),
      ),
    );
  }

  void disconnect() {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return DisconnectDialog(onDisconnect: () => Navigator.pop(context));
      },
    );
  }

  @override
  void dispose() {
    widget.wsRepo.disconnect();
    log('Disconnected from server');
    super.dispose();
  }
}
