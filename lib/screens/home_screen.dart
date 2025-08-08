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
import 'package:todo_with_resfulapi/widgets/dialog_widget_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Initialize data when widget is first built
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
              // Connectivity Status Indicator
              _buildConnectivityIndicator(taskProvider),

              // Refresh Button
              IconButton(
                icon: Icon(Icons.refresh, color: AppColorsPath.white),
                onPressed: () => taskProvider.refreshTasks(),
              ),

              // Calendar Icon
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
                  // Connectivity Status Banner
                  _buildConnectivityBanner(taskProvider),

                  // Body Content
                  // Case 1: Loading
                  if (taskProvider.isLoading)
                    Expanded(
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  // Case 2: Error
                  else if (taskProvider.errorMessage.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              title: 'Error loading tasks',
                              style: AppTextStyle.textFont24W600.copyWith(
                                color: AppColorsPath.errorRed,
                              ),
                            ),
                            SizedBox(height: 8),
                            AppText(
                              title: taskProvider.errorMessage,
                              style: AppTextStyle.textFontR10W400.copyWith(
                                color: AppColorsPath.errorRed,
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
                  // Case 3: Empty Data
                  else if (taskProvider.pendingTasks.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_outlined,
                              size: 80,
                              color: AppColorsPath.grey,
                            ),
                            SizedBox(height: 16),
                            AppText(
                              title: 'No pending tasks',
                              style: AppTextStyle.textFont24W600.copyWith(
                                color: AppColorsPath.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            AppText(
                              title: 'Tap + to add your first task',
                              style: AppTextStyle.textFontR10W400.copyWith(
                                color: AppColorsPath.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Case 4: Has Data
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

  // Build connectivity status indicator in AppBar
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
  }

  // Build connectivity status banner
  Widget _buildConnectivityBanner(TaskProvider taskProvider) {
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
                      Icon(Icons.sync, color: AppColorsPath.white, size: 12),
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
  }

  Widget _buildTaskItemWidget({required Task task}) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColorsPath.white,
            boxShadow: [
              BoxShadow(
                color: AppColorsPath.shadowGrey,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Task Status Indicator (for local tasks or tasks with pending sync)
              FutureBuilder<bool>(
                future:
                    task.id?.startsWith('local_') == true
                        ? Future.value(true)
                        : taskProvider.taskHasPendingSync(task.id ?? ''),
                builder: (context, snapshot) {
                  final hasPendingSync = snapshot.data ?? false;

                  if (hasPendingSync) {
                    return Container(
                      width: 4,
                      height: 40,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColorsPath.warningOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
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

                    // Pending sync indicator
                    FutureBuilder<bool>(
                      future:
                          task.id?.startsWith('local_') == true
                              ? Future.value(true)
                              : taskProvider.taskHasPendingSync(task.id ?? ''),
                      builder: (context, snapshot) {
                        final hasPendingSync = snapshot.data ?? false;

                        if (hasPendingSync) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: AppColorsPath.warningOrange.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColorsPath.warningOrange,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              'Pending sync',
                              style: TextStyle(
                                color: AppColorsPath.warningOrange,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              // Action Buttons
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
                color: AppColorsPath.errorRed,
                onPressed: () => _showDeleteConfirmDialog(task),
              ),

              _buildActionButton(
                icon: Icons.check_circle_outlined,
                color: AppColorsPath.successGreen,
                onPressed: () => _showCompleteConfirmDialog(task),
              ),
            ],
          ),
        );
      },
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

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmDialog(Task task) async {
    final confirmed = await DialogWidgetHomeScreen.showDeleteConfirmDialog(
      context,
      task,
    );

    if (confirmed == true) {
      context.read<TaskProvider>().deleteTask(task.id ?? '');
    }
  }

  // Show complete confirmation dialog
  Future<void> _showCompleteConfirmDialog(Task task) async {
    final confirmed = await DialogWidgetHomeScreen.showCompleteConfirmDialog(
      context,
      task,
    );

    if (confirmed == true) {
      context.read<TaskProvider>().toggleTaskCompletion(task);
    }
  }
}
