import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:opal/widget/opal_wrapper.dart';
import 'package:rxdart/rxdart.dart';

typedef ThemeMod = ThemeData Function(ThemeData theme);

class Opal {
  late ValueNotifier<ThemeData> lightThemeData;
  late ValueNotifier<ThemeData> darkThemeData;
  late ValueNotifier<ThemeMode> themeMode;
  late ValueNotifier<List<ThemeMod>> themeMods;
  late ValueNotifier<double> backgroundOpacity;
  late ValueNotifier<double> themeColorMixture;
  late BehaviorSubject<String> _backgroundSeed;

  Opal({
    required ThemeData lightThemeData,
    required ThemeData darkThemeData,
    required ThemeMode themeMode,
    double themeColorMixture = 0.25,
    double backgroundOpacity = 0.85,
    List<ThemeMod> themeMods = const [],
    required VoidCallback listener,
  }) {
    this.lightThemeData = ValueNotifier(lightThemeData)..addListener(listener);
    this.darkThemeData = ValueNotifier(darkThemeData)..addListener(listener);
    this.themeMode = ValueNotifier(themeMode)..addListener(listener);
    this.themeMods = ValueNotifier(themeMods)..addListener(listener);
    this.themeColorMixture = ValueNotifier(themeColorMixture)
      ..addListener(listener);
    this.backgroundOpacity = ValueNotifier(backgroundOpacity)
      ..addListener(listener);
    _backgroundSeed = BehaviorSubject.seeded("/");
  }

  static Opal of(BuildContext context) => OpalWrapper.of(context).controller;

  void setBackgroundSeed(String seed) => _backgroundSeed.add(seed);

  Stream<String> get backgroundSeedStream => _backgroundSeed.stream;

  ThemeData modifyTheme(ThemeData theme) {
    ThemeData t = theme;

    for (final mod in themeMods.value) {
      t = mod(t);
    }

    return t.copyWith(
        colorScheme: t.colorScheme.copyWith(
          background: Colors.transparent,
          surface: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent);
  }

  ThemeData get light => modifyTheme(lightThemeData.value);

  ThemeData get dark => modifyTheme(darkThemeData.value);

  ThemeData get theme =>
      modifyTheme(isDark() ? darkThemeData.value : lightThemeData.value);

  bool isDark() =>
      themeMode.value == ThemeMode.dark ||
      (themeMode.value == ThemeMode.system && isPlatformDark());

  bool isPlatformDark() =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
}
