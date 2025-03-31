import 'package:flame/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/hud.dart';
import 'game/dino_run.dart';
import 'models/settings.dart';
import 'widgets/main_menu.dart';
import 'models/player_data.dart';
import 'widgets/pause_menu.dart';
import 'widgets/settings_menu.dart';
import 'widgets/game_over_menu.dart';

Future<void> main() async {
  // Ensure all bindings are initialized before calling any platform-specific code.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register Hive adapters.
  await initHive();

  runApp(const DinoRunApp());
}

/// Initializes Hive with the app's documents directory (if needed)
/// and registers the Hive adapters, with error handling.
Future<void> initHive() async {
  try {
    // For web, Hive initialization is not required.
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
  } catch (e, stackTrace) {
    debugPrint("Error during Hive initialization: $e\n$stackTrace");
  }

  try {
    Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
    Hive.registerAdapter<Settings>(SettingsAdapter());
  } catch (e, stackTrace) {
    debugPrint("Error registering Hive adapters: $e\n$stackTrace");
  }
}

/// The main widget for this game.
class DinoRunApp extends StatelessWidget {
  const DinoRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Setting a default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget<DinoRun>.controlled(
          // Displays a loading bar until [DinoRun]'s onLoad method completes.
          loadingBuilder: (context) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          // Registering all the overlays used by this game.
          overlayBuilderMap: {
            MainMenu.id: (_, game) => MainMenu(game),
            PauseMenu.id: (_, game) => PauseMenu(game),
            Hud.id: (_, game) => Hud(game: game),
            GameOverMenu.id: (_, game) => GameOverMenu(game),
            SettingsMenu.id: (_, game) => SettingsMenu(game),
          },
          // The MainMenu overlay is active by default.
          initialActiveOverlays: const [MainMenu.id],
          gameFactory: () => DinoRun(
            // Use a fixed resolution camera to simplify scaling across different screen sizes.
            camera: CameraComponent.withFixedResolution(
              width: 360,
              height: 180,
            ),
          ),
        ),
      ),
    );
  }
}
