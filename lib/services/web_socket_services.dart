import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late final WebSocketChannel channel;

  // Initialize WebSocket connection
  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  // Listen for incoming messages
  void listen(Function(String) onMessageReceived) {
    channel.stream.listen(
          (message) {
        onMessageReceived(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  // Send a message
  void sendMessage(String message) {
    channel.sink.add(message);
  }

  // Close the connection
  void close() {
    channel.sink.close();
  }
}
