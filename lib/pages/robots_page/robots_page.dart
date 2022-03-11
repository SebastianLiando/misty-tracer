import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/common/widgets/divider_with_item.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';
import 'package:misty_tracer/pages/robots_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/robots_page/cubit/state.dart';
import 'package:misty_tracer/pages/robots_page/widgets/robot_list_tile.dart';

class RobotsPage extends StatelessWidget {
  const RobotsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final robots = [
    //   Robot(
    //       id: '',
    //       serial: '2022513230',
    //       currentState: RobotState.offline,
    //       stateUpdatedAt: DateTime(2022, 3, 9, 14, 15)),
    //   Robot(
    //       id: '',
    //       serial: '2022513231',
    //       currentState: RobotState.pending,
    //       stateUpdatedAt: DateTime(2022, 3, 9, 14, 15)),
    //   Robot(
    //       id: '',
    //       serial: '2022513232',
    //       location: "Hello",
    //       currentState: RobotState.idle,
    //       stateUpdatedAt: DateTime(2022, 3, 9, 14, 15)),
    //   Robot(
    //       id: '',
    //       serial: '2022513233',
    //       location: "Bye",
    //       currentState: RobotState.offline,
    //       stateUpdatedAt: DateTime(2022, 3, 9, 14, 14)),
    // ];

    return BlocBuilder<RobotsPageCubit, RobotsPageState>(
      builder: (context, data) {
        final cubit = context.read<RobotsPageCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                children: [
                  FilterChip(
                    selected: data.showOnline,
                    label: const Text('Show Online'),
                    onSelected: cubit.onChangeShowOnline,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    selected: data.showOffline,
                    label: const Text('Show Offline'),
                    onSelected: cubit.onChangeShowOffline,
                  ),
                ],
              ),
            ),
            Flexible(
              child: _buildRobotsList(data.robotsFiltered),
            )
          ],
        );
      },
    );
  }

  Widget _buildRobotsList(List<Robot> robots) {
    if (robots.isEmpty) {
      return Container();
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        final robot = robots[index];
        final robotTile = RobotListTile(
          online: robot.currentState != RobotState.offline,
          serial: robot.serial,
          location: robot.location,
          state: robot.currentState.name,
          updatedAt: robot.stateUpdatedAt,
          onTap: () {},
        );

        if (index == 0 && !robot.isConfigured) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DividerWithItem(
                  color: Theme.of(context).colorScheme.error,
                  item: Text(
                    "New Robot(s)",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
              robotTile,
            ],
          );
        }

        return robotTile;
      },
      separatorBuilder: (context, index) {
        // Separator only appears between items
        final current = robots[index];
        final next = robots[index + 1];

        var divider = const Divider();

        // Use error color to separate configured robots and non-configured robots
        if (!current.isConfigured && next.isConfigured) {
          divider = Divider(color: Theme.of(context).colorScheme.error);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: divider,
        );
      },
      itemCount: robots.length,
    );
  }
}
