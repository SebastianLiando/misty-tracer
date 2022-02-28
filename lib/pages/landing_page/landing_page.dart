import 'package:flutter/material.dart';
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

  Step _buildConnectServerStep() {
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
            decoration: const InputDecoration(
              prefixIcon: Icon(CustomIcon.worldwide),
              border: OutlineInputBorder(),
              hintText: "e.g. 192.168.0.1",
              labelText: "IP Address",
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: portController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(CustomIcon.ethernet),
              border: OutlineInputBorder(),
              hintText: "e.g. 8000",
              labelText: "Port Number",
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
          child: Column(
            children: [
              const Center(child: Header()),
              Stepper(
                currentStep: 2,
                physics: const NeverScrollableScrollPhysics(),
                steps: [
                  startServerStep,
                  onMistyStep,
                  _buildConnectServerStep(),
                ],
                controlsBuilder: _buildStepperControls,
                onStepContinue: () => print('Continue'),
                onStepCancel: () => print('Cancel'),
              ),
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
              onPressed: () => details.onStepContinue?.call(),
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
}
