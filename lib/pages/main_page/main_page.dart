import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/attendance_page/attendance_page.dart';
import 'package:misty_tracer/pages/attendance_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/main_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/main_page/cubit/state.dart';
import 'package:misty_tracer/pages/main_page/widgets/disconnect_dialog.dart';
import 'package:misty_tracer/pages/photos_page/cubit/cubit.dart';
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
  final locationController = TextEditingController();
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    _sub = widget.wsRepo.dataStream.listen(
      (event) {},
      onDone: () {
        log("Disconnected from server! Returning");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sorry, you have been disconnected :('),
          ),
        );
        Navigator.pop(context);
      },
    );
  }

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
            title: _buildAppBarTitle(data.tabIndex),
            actions: [
              TextButton(
                onPressed: () => disconnect(),
                child: const Text('DISCONNECT'),
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildContent(data.tabIndex),
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
              NavigationDestination(
                icon: Icon(Icons.email),
                label: 'Attendance',
              )
            ],
            onDestinationSelected: ctx.read<MainPageCubit>().onTabChange,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const Text('Misty Robots');
      case 1:
        return TextField(
          controller: locationController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Search Location',
            hintText: 'NTU',
          ),
        );
      case 2:
        return const Text('Attendance');
      default:
        throw ArgumentError("Tab index $tabIndex not supported!");
    }
  }

  Widget _buildContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return BlocProvider(
          create: (context) => RobotsPageCubit(widget.wsRepo),
          child: const RobotsPage(),
        );
      case 1:
        return BlocProvider(
          create: (context) => PhotosPageCubit(
            locationController: locationController,
            wsRepo: widget.wsRepo,
          ),
          child: const PhotosPage(),
        );
      case 2:
        return BlocProvider(
          create: (context) => AttendancePageCubit(widget.wsRepo),
          child: const AttendancePage(),
        );
      default:
        throw ArgumentError("Tab index $tabIndex not supported!");
    }
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
    _sub?.cancel();
    locationController.dispose();

    // Disconnect from WebSocket
    widget.wsRepo.disconnect();
    log('Disconnected from server');

    super.dispose();
  }
}
