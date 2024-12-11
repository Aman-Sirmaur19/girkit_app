import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/water_samples.dart';
import '../models/water_sample_model.dart';
import '../services/web_socket_services.dart';
import '../widgets/wavelength_graph.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final List<WaterSampleModel> samples = WaterSamples.samples;
  final WebSocketService _webSocketService = WebSocketService();
  String _receivedData = ''; // To store received data
  List<double> _graphData = []; // For graphical representation

  List<FlSpot> getChlorineData() {
    return samples.asMap().entries.map((entry) {
      int index = entry.key;
      double wavelength = entry.value.chlorineWavelength.toDouble();
      return FlSpot(index.toDouble(), wavelength);
    }).toList();
  }

  List<FlSpot> getSilverData() {
    return samples.asMap().entries.map((entry) {
      int index = entry.key;
      double wavelength = entry.value.silverWavelength.toDouble();
      return FlSpot(index.toDouble(), wavelength);
    }).toList();
  }

  void _connectToESP32() {
    const String esp32WebSocketUrl = 'ws://192.168.4.1:80'; // Replace with your ESP32 WebSocket URL
    _webSocketService.connect(esp32WebSocketUrl);
    _webSocketService.listen((message) {
      setState(() {
        _receivedData = message;
        _updateGraphData(message); // Parse and update graph data
      });
    });
  }

  void _updateGraphData(String message) {
    // Assume the message is a comma-separated list of values
    final values = message.split(',').map(double.parse).toList();
    setState(() {
      _graphData = values;
    });
  }

  @override
  void initState() {
    super.initState();
    // _connectToESP32();
  }

  @override
  void dispose() {
    super.dispose();
    _webSocketService.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Girkit')),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          WavelengthGraph(
            spots: getChlorineData(),
            title: "Chlorine Wavelengths",
            lineColor: Colors.blue,
            minY: 500,
            maxY: 600,
          ),
          WavelengthGraph(
            spots: getSilverData(),
            title: "Silver Wavelengths",
            lineColor: Colors.orange,
            minY: 400,
            maxY: 500,
          ),
        ],
      ),
    );
  }
}
