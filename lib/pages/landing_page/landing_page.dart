import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/landing_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/landing_page/cubit/state.dart';
import 'package:misty_tracer/pages/landing_page/widgets/header.dart';
import 'package:misty_tracer/pages/landing_page/widgets/previous_connection.dart';
import 'package:misty_tracer/pages/main_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/main_page/main_page.dart';
import 'package:misty_tracer/theme/icons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ipController = TextEditingController();
  final portController = TextEditingController();

  LandingPageCubit get pageCubit => context.read();

  @override
  void initState() {
    ipController.addListener(() {
      pageCubit.onChangedIp(ipController.text);
    });

    portController.addListener(() {
      pageCubit.onChangedPortNumber(portController.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();

    super.dispose();
  }

  static const startServerStep = Step(
    title: Text('Start the Server'),
    content: Text(
      'Please make sure that the server is running before continuing.',
    ),
  );

  static const onMistyStep = Step(
    title: Text('(Optional) Power on Misty robots'),
    content: Text(
      'This app shows the state of each robot in realtime, but you may choose to do this later.'
      '\n\nYou can still view photos of TraceTogether verifications regardless.',
    ),
  );

  Step _buildConnectServerStep(LandingPageState state) {
    return Step(
      title: const Text('Connect to Server'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter the server’s IP address and port number.'),
          const SizedBox(height: 12),
          TextField(
            controller: ipController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(CustomIcon.worldwide),
              border: const OutlineInputBorder(),
              hintText: "e.g. 192.168.0.1",
              labelText: "IP Address",
              errorText: state.ipError,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: portController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,5}$'),
                replacementString: state.port,
              ),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(CustomIcon.ethernet),
              border: const OutlineInputBorder(),
              hintText: "e.g. 8000",
              labelText: "Port Number",
              errorText: state.portError,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: BlocBuilder<LandingPageCubit, LandingPageState>(
            builder: (context, state) => Column(
              children: [
                const Center(child: Header()),
                Stepper(
                  currentStep: state.stepperIndex,
                  physics: const NeverScrollableScrollPhysics(),
                  steps: [
                    startServerStep,
                    onMistyStep,
                    _buildConnectServerStep(state),
                  ],
                  controlsBuilder: (_, details) =>
                      _buildStepperControls(state, details),
                  onStepContinue: () => pageCubit.onStepperNext(),
                  onStepCancel: () => pageCubit.onStepperPrevious(),
                ),
                _buildFooter(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperControls(
    LandingPageState state,
    ControlsDetails details,
  ) {
    final currentStep = details.currentStep;

    switch (currentStep) {
      case 0:
        return Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () => details.onStepContinue?.call(),
            child: const Text('SERVER IS RUNNING'),
          ),
        );
      case 1:
        return Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => details.onStepContinue?.call(),
                child: const Text('NEXT'),
              ),
              TextButton(
                onPressed: () => details.onStepCancel?.call(),
                child: const Text('PREVIOUS'),
              ),
            ],
          ),
        );
      case 2:
        return Row(
          children: [
            ElevatedButton(
              onPressed: state.canConnectToServer
                  ? () => connectToServer(state.ip, state.portNumber)
                  : null,
              child: const Text('CONNECT'),
            ),
            TextButton(
              onPressed: () => details.onStepCancel?.call(),
              child: const Text('PREVIOUS'),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildFooter(LandingPageState state) {
    return AnimatedOpacity(
      // Display footer only on the last step
      opacity: state.showFooter ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          // Show previous connection card only if there is a previous connection
          if (state.hasPreviousSession)
            PreviousConnection(
              ip: state.previousIp ?? '',
              port: state.previousPort ?? -1,
              onTap: () =>
                  connectToServer(state.previousIp!, state.previousPort!),
            ),
          Row(
            children: [
              Checkbox(
                value: state.skipTutorial,
                onChanged: (skip) =>
                    pageCubit.onCheckedChangeSkipTutorial(skip ?? false),
              ),
              const Text('Skip tutorial for next sessions'),
            ],
          )
        ],
      ),
    );
  }

  void connectToServer(String ip, int port) async {
    final wsRepo = WebsocketRepository();

    // Connect
    wsRepo.connect(ip, port);

    try {
      await wsRepo.connected;

      // Save to previous session
      pageCubit.onSaveServerAddress(ip, port);

      // Navigate
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => MainPageCubit(),
              child: MainPage(wsRepo: wsRepo),
            );
          },
        ),
      );
    } on WebSocketChannelException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to server: ${err.message}'),
        ),
      );
    }
  }
}
