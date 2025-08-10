import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';

/// Build connectivity status indicator in AppBar
class ConnectivityIndicatorWidget extends StatelessWidget {
  const ConnectivityIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (_, taskProvider, __) {
        return Container(
          margin: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                taskProvider.isOnline ? Icons.wifi : Icons.wifi_off,
                color: taskProvider.connectivityStatusColor,
                size: 20,
              ),
              if (taskProvider.pendingSyncCount > 0)
                Container(
                  margin: EdgeInsets.only(left: 4),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColorsPath.warningOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${taskProvider.pendingSyncCount}',
                    style: TextStyle(
                      color: AppColorsPath.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
