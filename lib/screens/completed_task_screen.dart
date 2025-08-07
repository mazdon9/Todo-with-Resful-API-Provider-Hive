// lib/screens/completed_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';

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
              /// Connectivity Status Indicator
              _buildConnectivityIndicator(taskProvider),

              /// Refresh Button
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
                  /// Connectivity Status Banner
                  _buildConnectivityBanner(taskProvider),

                  /// Body
                  Expanded(
                    child:
                        taskProvider.completedTasks.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  AppText(
                                    title: 'No completed tasks yet',
                                    style: AppTextStyle.textFont24W600.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  AppText(
                                    title:
                                        'Complete some tasks to see them here',
                                    style: AppTextStyle.textFontR10W400
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                            : ListView.separated(
                              itemCount: taskProvider.completedTasks.length,
                              separatorBuilder:
                                  (context, index) =>
                                      const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final task = taskProvider.completedTasks[index];
                                return _buildCompletedTaskItem(
                                  context,
                                  task,
                                  taskProvider,
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

  /// Build connectivity status indicator in AppBar
  Widget _buildConnectivityIndicator(TaskProvider taskProvider) {
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
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${taskProvider.pendingSyncCount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build connectivity status banner
  Widget _buildConnectivityBanner(TaskProvider taskProvider) {
    if (taskProvider.isOnline && taskProvider.pendingSyncCount == 0) {
      return SizedBox.shrink();
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
                          ? Colors.grey
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
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      Icon(Icons.sync, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      taskProvider.isSyncing ? 'Syncing...' : 'Sync Now',
                      style: TextStyle(
                        color: Colors.white,
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
  }

  Container _buildCompletedTaskItem(
    BuildContext context,
    Task task,
    TaskProvider taskProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColorsPath.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          /// Task Status Indicator (cho local tasks)
          if (task.id?.startsWith('local_') == true)
            Container(
              width: 4,
              height: 40,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title: task.title,
                  style: AppTextStyle.textFontSM13W600.copyWith(
                    color: AppColorsPath.lavender,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                if (task.description.isNotEmpty)
                  AppText(
                    title: task.description,
                    style: AppTextStyle.textFontR10W400.copyWith(
                      color: AppColorsPath.black,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),

                /// Local task indicator
                if (task.id?.startsWith('local_') == true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange, width: 0.5),
                    ),
                    child: Text(
                      'Pending sync',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// Action Buttons
          IconButton(
            onPressed:
                () => _showUndoConfirmDialog(context, task, taskProvider),
            icon: Icon(Icons.undo, color: Colors.orange),
            visualDensity: VisualDensity.compact,
          ),

          IconButton(
            onPressed:
                () => _showDeleteConfirmDialog(context, task, taskProvider),
            icon: Icon(Icons.delete, color: Colors.red),
            visualDensity: VisualDensity.compact,
          ),

          Icon(Icons.check_circle, color: Colors.green, size: 30),
        ],
      ),
    );
  }

  /// Show undo confirmation dialog
  Future<void> _showUndoConfirmDialog(
    BuildContext context,
    Task task,
    TaskProvider taskProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Undo Task Completion'),
            content: Text('Mark "${task.title}" as pending again?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Undo', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      taskProvider.toggleTaskCompletion(task);
    }
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    Task task,
    TaskProvider taskProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Task'),
            content: Text(
              'Are you sure you want to permanently delete "${task.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      taskProvider.deleteTask(task.id ?? '');
    }
  }
}
