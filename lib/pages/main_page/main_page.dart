import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/main_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/main_page/cubit/state.dart';
import 'package:misty_tracer/pages/main_page/widgets/disconnect_dialog.dart';
import 'package:misty_tracer/pages/photos_page/photos_page.dart';
import 'package:misty_tracer/pages/robots_page/robots_page.dart';
import 'package:misty_tracer/theme/icons.dart';

class MainPage extends StatelessWidget {
  final WebsocketRepository wsRepo;

  const MainPage({Key? key, required this.wsRepo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        disconnect(context);
        return false;
      },
      child: BlocBuilder<MainPageCubit, MainPageState>(
        builder: (context, data) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).colorScheme.primary,
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
                onPressed: () => disconnect(context),
                child: const Text('DISCONNECT'),
              ),
            ],
          ),
          body: AnimatedCrossFade(
            firstChild: const RobotsPage(),
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
            onDestinationSelected: context.read<MainPageCubit>().onTabChange,
          ),
        ),
      ),
    );
  }

  void disconnect(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return DisconnectDialog(onDisconnect: () => Navigator.pop(context));
      },
    );
  }
}
