import 'package:example/slidy.dart';
import 'package:flutter/material.dart';
import 'package:opal/util/controller.dart';
import 'package:opal/widget/opal_wrapper.dart';
import 'package:toxic/toxic.dart';

void main() => runApp(const OpalExampleApp());

class OpalExampleApp extends StatelessWidget {
  const OpalExampleApp({super.key});

  @override
  Widget build(BuildContext context) => OpalWrapper(
          themeMods: [
            (t) => t.copyWith(
                  colorScheme: t.colorScheme.copyWith(
                    primary: Color(0xFF003b6f),
                  ),
                )
          ],
          builder: (context, light, dark, mode) => MaterialApp(
                title: 'Opal Example',
                theme: light,
                darkTheme: dark,
                themeMode: mode,
                home: const OpalTestScreen(),
              ));
}

class OpalTestScreen extends StatefulWidget {
  const OpalTestScreen({super.key});

  @override
  State<OpalTestScreen> createState() => _OpalTestScreenState();
}

class _OpalTestScreenState extends State<OpalTestScreen> {
  @override
  Widget build(BuildContext context) {
    Opal o = Opal.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opal Test Screen'),
      ),
      body: ListView(
        children: [
          Slidy(
              label: (d) => "Opacity: ${(d * 100).round()}%",
              initialValue: o.backgroundOpacity.value,
              min: 0,
              max: 1,
              step: 100,
              onChanged: (v) => o.backgroundOpacity.value = v),
          o.backgroundSeedStream.build((v) => Slidy(
              label: (d) => "Seed: ${(d * 100).round()}%",
              initialValue: double.tryParse(v) ?? 0,
              min: 0,
              max: 1,
              step: 100,
              onChanged: (v) => o.setBackgroundSeed(v.toString()))),
          Slidy(
              label: (d) => "Blend Amount: ${(d * 100).round()}%",
              initialValue: o.themeColorMixture.value,
              min: 0,
              max: 1,
              step: 100,
              onChanged: (v) => o.themeColorMixture.value = v),
        ],
      ),
    );
  }
}
