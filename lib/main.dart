import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ESP32App(),
    );
  }
}

class ESP32App extends StatefulWidget {
  const ESP32App({super.key});

  @override
  ESP32AppState createState() => ESP32AppState();
}

class ESP32AppState extends State<ESP32App> {
  List<WiFiAccessPoint> networks = [];
  String esp32NetworkSSID =
      'ESP32_AS7341'; // Replace with your ESP32 network's SSID
  bool isConnected = false;
  List<double> receivedData = [];
  String connectionStatus = "Not connected";

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndScan();
  }

  Future<void> _checkPermissionsAndScan() async {
    // Request necessary permissions
    if (await Permission.location.isGranted == false) {
      await Permission.location.request();
    }

    // Initialize wifi_scan plugin
    final initialized = await WiFiScan.instance.startScan();
    if (!initialized) {
      print("Failed to initialize WiFi scan");
      return;
    }

    // Scan for networks
    _scanForNetworks();
  }

  Future<void> _scanForNetworks() async {
    try {
      final results = await WiFiScan.instance.getScannedResults();
      setState(() {
        networks = results;
      });
    } catch (e) {
      print("Error scanning networks: $e");
    }
  }

  Future<void> _connectToESP32(String ssid, String password) async {
    try {
      // Enable Wi-Fi if not already enabled
      if (!await WiFiForIoTPlugin.isEnabled()) {
        await WiFiForIoTPlugin.setEnabled(true);
      }

      // Connect to the ESP32 Wi-Fi network
      bool isConnected = await WiFiForIoTPlugin.connect(
        ssid, // ESP32 network SSID
        password: password, // Password for the ESP32 network
        joinOnce: true, // Connect only temporarily
        security:
            NetworkSecurity.WPA, // Update based on your ESP32 security type
      );

      if (isConnected) {
        setState(() {
          this.isConnected = true;
          connectionStatus = "Connected to $ssid";
        });
        print("Successfully connected to $ssid.");

        // Fetch data after successful connection
        await _fetchDataFromESP32();
      } else {
        setState(() {
          connectionStatus = "Failed to connect to $ssid";
        });
        print("Failed to connect to $ssid.");
      }
    } catch (e) {
      setState(() {
        connectionStatus = "Error: $e";
      });
      print("Error connecting to ESP32: $e");
    }
  }

  Future<void> _fetchDataFromESP32() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/test'));
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          receivedData = (data).map((e) => (e as num).toDouble()).toList();
        });
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Connection Status:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              connectionStatus,
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            if (!isConnected)
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: () => _connectToESP32("ESP32_AS7341", "12345678"),
                child: const Text('Connect to ESP32'),
              ),
            if (isConnected)
              ElevatedButton(
                onPressed: _fetchDataFromESP32,
                child: const Text('Fetch Data from ESP32'),
              ),
            if (isConnected)
              Expanded(
                child: receivedData.isNotEmpty
                    ? LineGraph(data: receivedData)
                    : const Center(child: CircularProgressIndicator()),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: networks.length,
                itemBuilder: (context, index) {
                  final network = networks[index];
                  return ListTile(
                    title: Text(network.ssid),
                    subtitle: Text("Signal strength: ${network.level}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineGraph extends StatelessWidget {
  final List<double> data;

  LineGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index]),
            ),
            belowBarData: BarAreaData(show: false),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
