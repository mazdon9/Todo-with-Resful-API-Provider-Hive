import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/constants/app_data.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
import 'package:todo_with_resfulapi/routes/app_routes.dart';
import 'package:todo_with_resfulapi/widgets/bottom_nav_bar_widget_home_screen.dart';
import 'package:todo_with_resfulapi/widgets/connectivity_widget.dart';
import 'package:todo_with_resfulapi/widgets/empty_state_widget.dart';
import 'package:todo_with_resfulapi/widgets/error_state_widget.dart';
import 'package:todo_with_resfulapi/widgets/home_task_item_widget.dart';

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
              ConnectivityWidget.buildConnectivityIndicator(taskProvider),

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
                  ConnectivityWidget.buildConnectivityBanner(taskProvider),

                  // Body Content
                  // Case 1: Loading
                  if (taskProvider.isLoading)
                    Expanded(
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  // Case 2: Error
                  else if (taskProvider.errorMessage.isNotEmpty)
                    Expanded(
                      child: ErrorStateWidget(
                        title: 'Error loading tasks',
                        message: taskProvider.errorMessage,
                        onRetry: () => taskProvider.getAllTasks(),
                      ),
                    )
                  // Case 3: Empty Data
                  else if (taskProvider.pendingTasks.isEmpty)
                    Expanded(
                      child: EmptyStateWidget(
                        icon: Icons.task_outlined,
                        title: 'No pending tasks',
                        subtitle: 'Tap + to add your first task',
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
                          return HomeTaskItemWidget(task: task);
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
}
