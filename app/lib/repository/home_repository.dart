import 'dart:convert';
import 'dart:io';

class HomeRepository {
  late RawDatagramSocket _socket;

  Future<void> init() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  }

  Future<void> sendUdpMessage(
    String message,
    String targetIp,
    int targetPort,
  ) async {
    final data = utf8.encode(message);
    _socket.send(data, InternetAddress(targetIp), targetPort);
  }

  void closeUdp() {
    _socket.close();
  }
}
