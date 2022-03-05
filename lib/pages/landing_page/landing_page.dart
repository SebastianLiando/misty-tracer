import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/pages/landing_page/bloc/bloc.dart';
import 'package:misty_tracer/pages/landing_page/bloc/state.dart';
import 'package:misty_tracer/pages/landing_page/widgets/header.dart';
import 'package:misty_tracer/pages/landing_page/widgets/previous_connection.dart';
import 'package:misty_tracer/theme/icons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ipController = TextEditingController();
  final portController = TextEditingController();

  @override
  void initState() {
    ipController.addListener(() {
      context.read<LandingPageBloc>().onChangedIp(ipController.text);
    });

    portController.addListener(() {
      context.read<LandingPageBloc>().onChangedPortNumber(portController.text);
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
          child: BlocBuilder<LandingPageBloc, LandingPageState>(
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
                  controlsBuilder: _buildStepperControls,
                  onStepContinue: () =>
                      context.read<LandingPageBloc>().onStepperNext(),
                  onStepCancel: () =>
                      context.read<LandingPageBloc>().onStepperPrevious(),
                ),
                _buildFooter(state.showFooter),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperControls(BuildContext context, ControlsDetails details) {
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
              onPressed: () => print('Connect to server'),
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

  Widget _buildFooter(bool show) {
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          PreviousConnection(
            ip: '192.168.0.1',
            port: 400,
            onTap: () {},
          ),
          Row(
            children: [
              Checkbox(value: true, onChanged: (value) {}),
              const Text('Skip tutorial for next sessions')
            ],
          )
        ],
      ),
    );
  }
}
