import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'all_themes.dart';

class ThemeSelectorPage extends StatelessWidget {
  const ThemeSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Theme')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.6, // taller for screenshot feel
          ),
          itemCount: allThemes.length,
          itemBuilder: (context, index) {
            String themeName = allThemes.keys.elementAt(index);
            ThemeData themeData = allThemes.values.elementAt(index);

            return GestureDetector(
              onTap: () {
                themeNotifier.setTheme(themeData);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: themeNotifier.currentTheme == themeData
                            ? const BorderSide(color: Colors.green, width: 3)
                            : BorderSide.none,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Theme(
                          data: themeData,
                          child: Container(
                            color: themeData.scaffoldBackgroundColor,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  color: themeData.appBarTheme.backgroundColor,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'AppBar',
                                    style: themeData.textTheme.headlineSmall,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 20,
                                          color: themeData.colorScheme.surface,
                                        ),
                                        Container(
                                          height: 20,
                                          width: double.infinity,
                                          color: themeData.colorScheme.surface,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: const Text('Button'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    themeName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
