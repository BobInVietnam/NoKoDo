import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/modules/test/test_screen.dart';

class TestDetailScreen extends StatelessWidget {
  final int? testId; // Optional: To know which Test this is for

  const TestDetailScreen({super.key, this.testId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Expanded widget to push the content to the center and bottom
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
              child: Text(
                'Bài kiểm tra',
                style: textTheme.displayLarge?.copyWith(
                  color: colorTheme.primary
                )
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget> [
                  Expanded(
                    flex: 4,
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                            margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                            child: Column(
                              children: <Widget> [
                                Text("Tên bài:"),
                                Text("Thời gian:"),
                                Text("Số lần thử:"),
                                Text("Điểm:"),
                              ]
                            )
                          )
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TestScreen()),
                            );
                          },
                          child: Text("BẮT ĐẦU")
                        )
                      ]
                    )
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                      margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                    )
                  )
                ],
              )
            ),
            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Return Button
                  ReturnButton(),
                  SettingButton(),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}
