import 'package:flutter/material.dart';
import 'package:opal/util/controller.dart';
import 'package:opal/widget/opal_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toxic/extensions/stream.dart';

Widget _passthroughBuilder(BuildContext context, Widget child) => child;

class OpalWrapper extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData lightTheme,
      ThemeData darkTheme, ThemeMode themeMode) builder;
  final TextDirection directionality;
  final Widget Function(BuildContext context, Widget child) backgroundBuilder;
  final Widget Function(BuildContext context, Widget child) foregroundBuilder;
  final Widget? background;
  final List<ThemeMod> themeMods;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;

  static OpalWrapperState of(BuildContext context) =>
      context.findAncestorStateOfType<OpalWrapperState>()!;

  const OpalWrapper(
      {super.key,
      required this.builder,
      this.themeMods = const [],
      this.lightTheme,
      this.darkTheme,
      this.themeMode = ThemeMode.system,
      this.directionality = TextDirection.ltr,
      this.backgroundBuilder = _passthroughBuilder,
      this.foregroundBuilder = _passthroughBuilder,
      this.background});

  @override
  State<OpalWrapper> createState() => OpalWrapperState();
}

class OpalWrapperState extends State<OpalWrapper> {
  late Opal controller;
  late BehaviorSubject<Opal> _controllerStream;

  @override
  void initState() {
    controller = Opal(
      lightThemeData: widget.lightTheme ?? ThemeData.light(),
      darkThemeData: widget.darkTheme ?? ThemeData.dark(),
      themeMode: widget.themeMode,
      themeMods: widget.themeMods,
      listener: () => _controllerStream.add(controller),
    );
    _controllerStream = BehaviorSubject.seeded(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      _controllerStream.build((controller) => Directionality(
          textDirection: widget.directionality,
          child: Theme(
              data: controller.theme,
              child: widget.backgroundBuilder(
                  context,
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.background ??
                          OpalBackground(controller: controller),
                      widget.foregroundBuilder(
                          context,
                          widget.builder(context, controller.light,
                              controller.dark, controller.themeMode.value)),
                    ],
                  )))));
}
