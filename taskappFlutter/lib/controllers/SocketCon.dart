import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:taskapp/controllers/Petitions.dart';

class SocketCon {
  WebSocketChannel _socket;

  SocketCon(Function initCallBack) {
    _initializeSocket(initCallBack);
  }

  void _initializeSocket(Function initCallBack) async {
    this._socket =
        // ignore: await_only_futures
        await IOWebSocketChannel.connect("ws://${Petitions().ip}:3000");
    this._socket.stream.listen((event) {
      if (event == 'makeChange') {
        initCallBack();
      }
    });
  }

  void changeMaked() {
    this._socket.sink.add('true');
  }
}
