// lib/screens/completed_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/widgets/connectivity_banner_widget.dart';
import 'package:todo_with_resfulapi/widgets/connectivity_indicator_widget.dart';
import 'package:todo_with_resfulapi/widgets/empty_state_widget.dart';
import 'package:todo_with_resfulapi/widgets/task_item_widget_completed_screen.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (_, taskProvider, __) {
        return Scaffold(
          backgroundColor: AppColorsPath.lavenderLight,
          appBar: AppBar(
            backgroundColor: AppColorsPath.lavender,
            title: AppText(
              title: 'Completed Tasks',
              style: AppTextStyle.textFont24W600.copyWith(
                color: AppColorsPath.white,
              ),
            ),
            actions: [
              // Connectivity Status Indicator
              ConnectivityIndicatorWidget(),

              // Refresh Button
              IconButton(
                icon: Icon(Icons.refresh, color: AppColorsPath.white),
                onPressed: () => taskProvider.refreshTasks(),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => taskProvider.refreshTasks(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Connectivity Status Banner
                  ConnectivityBannerWidget(),
                  // Body
                  Expanded(
                    child:
                        taskProvider.completedTasks.isEmpty
                            ? EmptyStateWidget(
                              icon: Icons.check_circle_outline,
                              title: 'No completed tasks yet',
                              subtitle: 'Complete some tasks to see them here',
                            )
                            : ListView.separated(
                              itemCount: taskProvider.completedTasks.length,
                              separatorBuilder:
                                  (context, index) =>
                                      const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final task = taskProvider.completedTasks[index];
                                return CompletedTaskItemWidget(
                                  task: task,
                                  taskProvider: taskProvider,
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
