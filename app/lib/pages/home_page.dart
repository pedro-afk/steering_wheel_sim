import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steering_wheel_sim/repository/home_repository.dart';

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

  @override
  void initState() {
    _repository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: platformEventChannel.receiveBroadcastStream(),
          builder: (context, snapshot) {
            return Center(
              child: Column(
                children: [
                  Text(
                    "Gyroscope",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (snapshot.data["gyroscope"] != null) ...[
                    Text("x: ${snapshot.data['gyroscope']['x'] ?? '0.0'}"),
                    Text("y: ${snapshot.data['gyroscope']['y'] ?? '0.0'}"),
                    Text("z: ${snapshot.data['gyroscope']['z'] ?? '0.0'}"),
                  ],
                  FilledButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    spacing: 12.0,
                                    children: [
                                      Text(
                                        "Configure connection",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextField(
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
                                      ),
                                      TextField(
                                        controller: _ctrlPort,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.account_tree_rounded),
                                          hintText: "1234",
                                          labelText: "Port",
                                          suffixIcon: Icon(
                                            Icons.navigate_next_rounded,
                                          ),
                                        ),
                                      ),
                                      FilledButton.icon(
                                        onPressed: () {
                                          _repository.sendUdpMessage("Hello World", _ctrlIp.text, int.parse(_ctrlPort.text));
                                        },
                                        label: Text("Configure"),
                                        icon: Icon(Icons.settings),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).then((value) {
                        _repository.closeUdp();
                      });
                    },
                    label: Text("Set up connection"),
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              onPressed: () {},
              tooltip: 'Breaks',
              label: Row(
                spacing: 8.0,
                children: [const Icon(Icons.block), Text("Breaks")],
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () {},
              tooltip: 'Throttle',
              label: Row(
                spacing: 8.0,
                children: [const Icon(Icons.whatshot), Text("Throttle")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
