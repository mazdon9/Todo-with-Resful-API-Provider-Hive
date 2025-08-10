import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';

/// Build connectivity status banner
class ConnectivityBannerWidget extends StatelessWidget {
  const ConnectivityBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (_, taskProvider, __) {
        if (taskProvider.isOnline && taskProvider.pendingSyncCount == 0) {
          return SizedBox.shrink(); // Hide banner when online and synced
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: taskProvider.connectivityStatusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: taskProvider.connectivityStatusColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                taskProvider.isOnline ? Icons.sync_problem : Icons.wifi_off,
                color: taskProvider.connectivityStatusColor,
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  taskProvider.connectivityStatusText,
                  style: TextStyle(
                    color: taskProvider.connectivityStatusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (taskProvider.isOnline && taskProvider.pendingSyncCount > 0)
                GestureDetector(
                  onTap:
                      taskProvider.isSyncing
                          ? null
                          : () => taskProvider.syncPendingOperations(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          taskProvider.isSyncing
                              ? AppColorsPath.grey
                              : taskProvider.connectivityStatusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (taskProvider.isSyncing)
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColorsPath.white,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.sync,
                            color: AppColorsPath.white,
                            size: 12,
                          ),
                        SizedBox(width: 4),
                        Text(
                          taskProvider.isSyncing ? 'Syncing...' : 'Sync Now',
                          style: TextStyle(
                            color: AppColorsPath.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
