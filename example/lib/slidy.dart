import 'package:flutter/material.dart';

class Slidy extends StatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;
  final Widget? leading;
  final Widget? trailing;
  final String Function(double) label;

  const Slidy(
      {super.key,
      this.leading,
      this.trailing,
      required this.label,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.step,
      required this.onChanged});

  @override
  State<Slidy> createState() => _SlidyState();
}

class _SlidyState extends State<Slidy> {
  late double value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: widget.leading,
        title: Text(widget.label(value)),
        trailing: widget.trailing,
        subtitle: Slider(
          min: widget.min,
          max: widget.max,
          activeColor: ColorTween(
                  begin: ColorTween(
                          begin: Theme.of(context).colorScheme.secondary,
                          end: ColorTween(
                            begin: Theme.of(context).colorScheme.onSurface,
                            end: Theme.of(context).colorScheme.surface,
                          ).lerp(0.6))
                      .lerp(0.6),
                  end: Theme.of(context).colorScheme.secondary)
              .lerp(value / widget.max),
          value: value,
          onChanged: (v) => setState(() {
            value = v;
          }),
          onChangeEnd: (v) => setState(() {
            value = v;
            widget.onChanged(v);
          }),
        ),
      );
}
