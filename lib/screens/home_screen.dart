import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/constants/app_data.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';
import 'package:todo_with_resfulapi/widgets/bottom_nav_bar_widget_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    /// Get data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (_, taskProvider, __) {
        return Scaffold(
          backgroundColor: AppColorsPath.lavenderLight,
          appBar: AppBar(
            backgroundColor: AppColorsPath.lavender,
            elevation: 0,
            title: AppText(
              title: AppData.appName,
              style: AppTextStyle.textFont24W600,
            ),
            actions: [
              /// Connectivity Status Indicator
              _buildConnectivityIndicator(taskProvider),

              /// Refresh Button
              IconButton(
                icon: Icon(Icons.refresh, color: AppColorsPath.white),
                onPressed: () => taskProvider.refreshTasks(),
              ),

              /// Calendar Icon
              IconButton(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: AppColorsPath.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBarWidget(),
          body: RefreshIndicator(
            onRefresh: () => taskProvider.refreshTasks(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  /// Connectivity Status Banner
                  _buildConnectivityBanner(taskProvider),

                  /// Body
                  /// Case 1: Loading
                  if (taskProvider.isLoading)
                    Expanded(
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  /// Case 2: Error
                  else if (taskProvider.errorMessage.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              title: 'Error loading tasks',
                              style: AppTextStyle.textFont24W600.copyWith(
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 8),
                            AppText(
                              title: taskProvider.errorMessage,
                              style: AppTextStyle.textFontR10W400.copyWith(
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => taskProvider.getAllTasks(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  /// Case 3: Empty Data
                  else if (taskProvider.pendingTasks.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            AppText(
                              title: 'No pending tasks',
                              style: AppTextStyle.textFont24W600.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            AppText(
                              title: 'Tap + to add your first task',
                              style: AppTextStyle.textFontR10W400.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  /// Case 4: Has Data
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: taskProvider.pendingTasks.length,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = taskProvider.pendingTasks[index];
                          return _buildTaskItemWidget(task: task);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80, right: 22),
            child: PhysicalModel(
              color: AppColorsPath.lavender,
              elevation: 6,
              shape: BoxShape.circle,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  backgroundColor: AppColorsPath.lavender,
                  elevation: 0,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addTodoScreeRouter);
                  },
                  shape: const CircleBorder(),
                  child: Icon(Icons.add, color: AppColorsPath.white, size: 40),
                ),
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
      return SizedBox.shrink(); // Không hiển thị gì khi online và đã sync
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

  Container _buildTaskItemWidget({required Task task}) {
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
      padding: EdgeInsets.all(12),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title: task.title,
                  style: AppTextStyle.textFontSM13W600.copyWith(
                    color: AppColorsPath.lavender,
                  ),
                ),
                if (task.description.isNotEmpty)
                  AppText(
                    title: task.description,
                    style: AppTextStyle.textFontR10W400.copyWith(
                      color: AppColorsPath.black,
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
          _buildActionButton(
            icon: Icons.edit,
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editTodoScreenRouter,
                arguments: task,
              );
            },
          ),

          _buildActionButton(
            icon: Icons.delete,
            color: Colors.red,
            onPressed: () => _showDeleteConfirmDialog(task),
          ),

          _buildActionButton(
            icon: Icons.check_circle_outlined,
            color: Colors.green,
            onPressed: () => _showCompleteConfirmDialog(task),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      visualDensity: VisualDensity.compact,
    );
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmDialog(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
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
      context.read<TaskProvider>().deleteTask(task.id ?? '');
    }
  }

  /// Show complete confirmation dialog
  Future<void> _showCompleteConfirmDialog(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Complete Task'),
            content: Text('Mark "${task.title}" as completed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Complete', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      context.read<TaskProvider>().toggleTaskCompletion(task);
    }
  }
}
