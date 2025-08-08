import 'package:flutter/material.dart';
import 'package:todo_with_resfulapi/components/app_text.dart';
import 'package:todo_with_resfulapi/components/app_text_style.dart';
import 'package:todo_with_resfulapi/constants/app_color_path.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;

  const ErrorStateWidget({
    super.key,
    this.title = 'Error loading data',
    required this.message,
    this.onRetry,
    this.retryButtonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            title: title,
            style: AppTextStyle.textFont24W600.copyWith(
              color: AppColorsPath.errorRed,
            ),
          ),
          SizedBox(height: 8),
          AppText(
            title: message,
            style: AppTextStyle.textFontR10W400.copyWith(
              color: AppColorsPath.errorRed,
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(retryButtonText)),
          ],
        ],
      ),
    );
  }
}
