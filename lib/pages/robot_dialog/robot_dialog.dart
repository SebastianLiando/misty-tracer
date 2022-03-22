import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/common/widgets/form_field.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';
import 'package:misty_tracer/pages/robot_dialog/cubit/cubit.dart';
import 'package:misty_tracer/pages/robot_dialog/cubit/state.dart';
import 'package:misty_tracer/pages/robots_page/widgets/robot_indicator.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_badge.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_updated_text.dart';

class RobotDialog extends StatefulWidget {
  const RobotDialog({Key? key}) : super(key: key);

  @override
  State<RobotDialog> createState() => _RobotDialogState();
}

class _RobotDialogState extends State<RobotDialog> {
  RobotDialogCubit get cubit => context.read();

  final locationController = TextEditingController();

  @override
  void initState() {
    locationController.addListener(() {
      cubit.onRobotLocationChanged(locationController.text);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    locationController.text = cubit.state.current.location;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotDialogCubit, RobotDialogState>(
      builder: (context, state) => AlertDialog(
        title: const Text('Edit Robot Configuration'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  RobotIndicator(
                    online: state.initial.isOnline,
                    width: 70,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        FieldValue(
                          label: 'SERIAL',
                          value: Text(state.initial.serial),
                        ),
                        FieldValue(
                          label: 'STATUS',
                          value: StateBadge.fromState(
                              state.initial.currentState.name),
                        ),
                        StateUpdatedText(
                          updatedAt: state.initial.stateUpdatedAt,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g. BLK 202',
                  border: const OutlineInputBorder(),
                  errorText: state.locationError,
                  suffixIcon: state.current.location.isNotEmpty
                      ? IconButton(
                          onPressed: _onClearLocation,
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        actions: state.isSaving
            ? const [LinearProgressIndicator()]
            : [
                ElevatedButton(
                  onPressed: state.canSave ? () => _saveChanges() : null,
                  child: const Text('SAVE CHANGES'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
              ],
      ),
    );
  }

  void _onClearLocation() {
    locationController.text = "";
  }

  void _saveChanges() {
    cubit.onSaveChanges();
  }
}
