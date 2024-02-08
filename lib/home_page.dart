import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _kgInputController = TextEditingController();
  final _nameInputController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  var _sliderValue = 1.0;
  double rm = 1.0;
  TextStyle textStyle = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);
  String excercise = '';

  double _calculate(String text, double value) {
    final kg = double.tryParse(text);
    final rm = kg! / (1.0278 - (0.0278 * value));
    return rm;
  }

  saveToGallery() {
    screenshotController.capture().then((Uint8List? image) {
      saveScreenShot(image!);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Image Added to Gallery')));
  }

  saveScreenShot(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '/');
    final name = 'ScreenShot_$time';
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yy').format(now);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(94, 94, 94, 0.675),
      appBar: AppBar(
        title: const Center(child: Text('RM Calculator')),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(94, 94, 94, 0.675))),
                  label: const Text('Squat'),
                  onPressed: () {
                    setState(() {
                      excercise = 'Squat';
                    });
                  },
                  icon: Image.asset("lib/assets/squat1.png"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(94, 94, 94, 0.675))),
                  label: const Text('Deadlift'),
                  onPressed: () {
                    setState(() {
                      excercise = 'Deadlift';
                    });
                  },
                  icon: Image.asset("lib/assets/deadlift.png"),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: _nameInputController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        focusColor: Colors.pinkAccent,
                        labelStyle: TextStyle(color: Color(0xFFFF4081)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        labelText: 'Name'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    controller: _kgInputController,
                    decoration: const InputDecoration(
                        focusColor: Colors.pinkAccent,
                        labelStyle: TextStyle(color: Colors.pinkAccent),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pinkAccent)),
                        labelText: 'KG (Use "." for decimals)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
                activeColor: Colors.pinkAccent,
                inactiveColor: Colors.pinkAccent,
                value: _sliderValue,
                min: 1,
                max: 12,
                divisions: 11,
                label: _sliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                  });
                }),
            Center(
              child: Text(
                'Number of reps: ${_sliderValue.round()}',
                style: textStyle,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  setState(() {
                    rm =
                        _calculate(_kgInputController.value.text, _sliderValue);
                  });
                },
                child: const Text('Calulate')),
            const SizedBox(
              height: 20,
            ),
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Name: ${_nameInputController.value.text}',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                      Text(
                        'Excercise: $excercise',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                      Text(
                        'Date: $formattedDate',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('1RM: ${rm.round()}', style: textStyle),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '2RM: ${(rm.round() * 0.97).round()}',
                        style: textStyle,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '3RM: ${(rm.round() * 0.946).round()}',
                        style: textStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('4RM: ${(rm.round() * 0.915).round()}',
                          style: textStyle),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '5RM: ${(rm.round() * 0.89).round()}',
                        style: textStyle,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text('6RM: ${(rm.round() * 0.855).round()}',
                          style: textStyle),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('7RM: ${(rm.round() * 0.83).round()}',
                          style: textStyle),
                      const SizedBox(
                        width: 20,
                      ),
                      Text('8RM: ${(rm.round() * 0.8).round()}',
                          style: textStyle),
                      const SizedBox(
                        width: 20,
                      ),
                      Text('9RM: ${(rm.round() * 0.775).round()}',
                          style: textStyle),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('10RM: ${(rm.round() * 0.75).round()}',
                          style: textStyle),
                      const SizedBox(
                        width: 20,
                      ),
                      Text('11RM: ${(rm.round() * 0.72).round()}',
                          style: textStyle),
                      const SizedBox(
                        width: 20,
                      ),
                      Text('12RM: ${(rm.round() * 0.695).round()}',
                          style: textStyle),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent),
                onPressed: saveToGallery,
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
