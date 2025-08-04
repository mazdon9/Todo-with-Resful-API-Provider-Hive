import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';
import 'package:todo_with_resfulapi/constants/app_data.dart';
import 'package:todo_with_resfulapi/models/task.dart';
import 'package:todo_with_resfulapi/providers/task_provider.dart';
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
      context.read<TaskProvider>().loadTasks();
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                /// Body
                /// Case 1: Loading
                if (taskProvider.isLoading)
                  Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                /// Case 2: No data
                if (!taskProvider.isLoading && taskProvider.hasError)
                  Expanded(
                    child: Center(
                      child: AppText(
                        title: 'Error loading tasks ${taskProvider.error}',
                        style: AppTextStyle.textFont24W600.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                /// Case 3: Empty Data
                if (!taskProvider.isLoading &&
                    taskProvider.pendingTasks.isEmpty)
                  Expanded(
                    child: Center(
                      child: AppText(
                        title: 'There is no pending tasks, please add new task',
                        style: AppTextStyle.textFont24W600.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                /// Case 4: Has Data
                if (!taskProvider.isLoading &&
                    taskProvider.pendingTasks.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: taskProvider.pendingTasks.length,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 21),
                      itemBuilder: (context, index) {
                        final task = taskProvider.pendingTasks[index];
                        return _buildTaskItemWidget(task: task);
                      },
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 63, right: 22),
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
                  onPressed: () async {},
                  shape: const CircleBorder(),
                  child: Icon(Icons.add, color: AppColorsPath.white, size: 36),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container _buildTaskItemWidget({required Task task}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColorsPath.white,
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
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
                AppText(
                  title: task.description,
                  style: AppTextStyle.textFontR10W400.copyWith(
                    color: AppColorsPath.black,
                  ),
                ),
              ],
            ),
          ),

          /// TODO: Implemement Edit Flow later
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),

          /// TODO: Implemement Delete Flow later
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),

          /// TODO: Implemement Completed Flow later
          IconButton(onPressed: () {}, icon: Icon(Icons.check_circle_outlined)),
        ],
      ),
    );
  }
}
