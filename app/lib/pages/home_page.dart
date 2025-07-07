import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steering_wheel_sim/repository/home_repository.dart';

const String prefIpKey = "ip";
const String prefPortKey = "port";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platformEventChannel = EventChannel('sensorData');
  final HomeRepository _repository = HomeRepository();
  final TextEditingController _ctrlIp = TextEditingController();
  final TextEditingController _ctrlPort = TextEditingController();
  int throttle = 0;
  int brake = 0;
  double angle = 0.0;
  int lastTimestamp = DateTime.now().millisecondsSinceEpoch;
  late SharedPreferences _preferences;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((call) async {
      _preferences = await SharedPreferences.getInstance();
      platformEventChannel.receiveBroadcastStream().listen((data) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final deltaTime = (now - lastTimestamp) / 2000.0;
        lastTimestamp = now;

        double rotationZ = double.parse("${data['gyroscope']['z']}").toDouble();

        double deltaAngle = rotationZ * deltaTime * (180 / pi);

        angle += deltaAngle;

        angle = angle.clamp(-90.0, 90.0);

        String ip = _preferences.getString(prefIpKey) ?? "";
        String port = _preferences.getString(prefPortKey) ?? "";

        if (ip.isEmpty || port.isEmpty) {
          return;
        }

        _repository.sendUdpMessage(
          "angle:${(-angle).toStringAsFixed(2)}|throttle:$throttle|brake:$brake",
          ip,
          port,
        );
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _repository.closeUdp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Form(
                        key: _formKey,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12.0,
                                  children: [
                                    Text(
                                      "Configure connection",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _ctrlIp,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.computer),
                                        hintText: "192.168.1.1",
                                        labelText: "IPv4",
                                        suffixIcon: Icon(
                                          Icons.navigate_next_rounded,
                                        ),
                                      ),
                                      validator: (value) {
                                        if ((value ?? "").isEmpty) {
                                          return "Field required";
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: _ctrlPort,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_tree_rounded,
                                        ),
                                        hintText: "1234",
                                        labelText: "Port",
                                        suffixIcon: Icon(
                                          Icons.navigate_next_rounded,
                                        ),
                                      ),
                                      validator: (value) {
                                        if ((value ?? "").isEmpty) {
                                          return "Field required";
                                        }
                                        return null;
                                      },
                                    ),
                                    FilledButton.icon(
                                      onPressed: () async {
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        await _preferences.setString(prefIpKey, _ctrlIp.text);
                                        await _preferences.setString(prefPortKey, _ctrlPort.text);
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("IP and PORT saved!")));
                                        Navigator.pop(context);
                                      },
                                      label: Text("Configure"),
                                      icon: Icon(Icons.settings),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                label: Text("Set up connection"),
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  brake = 1;
                });
              },
              onTapUp: (_) {
                setState(() {
                  brake = 0;
                });
              },
              onTapCancel: () {
                setState(() {
                  brake = 0;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  children: [const Icon(Icons.block), Text("Breaks")],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  angle = 0;
                });
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  children: [const Icon(Icons.clear), Text("Reset angle")],
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  throttle = 1;
                });
              },
              onTapUp: (_) {
                setState(() {
                  throttle = 0;
                });
              },
              onTapCancel: () {
                setState(() {
                  throttle = 0;
                });
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  children: [const Icon(Icons.whatshot), Text("Throttle")],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
