import 'package:flutter/material.dart';
import '../models/device.dart';
import '../widgets/custom_app_bar.dart';
import '../services/device_service.dart';
import '../utils/theme.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailScreen({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final DeviceService _deviceService = DeviceService();
  Map<String, dynamic>? deviceData;
  bool isLoading = false;
  bool isConnected = true; // Device is connected when we reach this screen

  @override
  void initState() {
    super.initState();
    _loadDeviceData();
  }

  Future<void> _loadDeviceData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Implement actual device data fetching
      final data = await _deviceService.getDeviceData(widget.device.id);
      setState(() {
        deviceData = data;
      });
    } catch (e) {
      // TODO: Handle data loading error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load data: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _disconnectDevice() async {
    // TODO: Implement device disconnection
    try {
      final success = await _deviceService.disconnectFromDevice(widget.device.id);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnected from ${widget.device.name}'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disconnect error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: CustomAppBar(
        title: widget.device.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadDeviceData,
          ),
          IconButton(
            icon: const Icon(Icons.bluetooth_disabled),
            onPressed: _disconnectDevice,
          ),
        ],
      ),
      body: isLoading && deviceData == null
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current readings at the top
                  if (deviceData != null) _buildCurrentReadings(),
                  const SizedBox(height: 24),

                  // Historical data table
                  const Text(
                    'Historical Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (deviceData != null)
                    _buildHistoricalDataTable()
                  else
                    _buildNoDataState(),
                ],
              ),
            ),
    );
  }

  Widget _buildCurrentReadings() {
    final currentData = deviceData!['currentData'];
    final temperature = currentData['temperature'];
    final humidity = currentData['humidity'];
    final battery = currentData['battery'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Readings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildReadingCard(
                'Temperature',
                '${temperature.toStringAsFixed(1)}°C',
                Icons.thermostat,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildReadingCard(
                'Humidity',
                '${humidity.toStringAsFixed(1)}%',
                Icons.water_drop,
                AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildReadingCard(
                'Battery',
                '${battery}%',
                Icons.battery_full,
                _getBatteryColor(battery),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadingCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalDataTable() {
    final historicalData = deviceData!['historicalData'] as List<Map<String, dynamic>>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Last 30 Minutes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 50,
                dataRowMinHeight: 45,
                dataRowMaxHeight: 45,
                columnSpacing: 40,
                headingTextStyle: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                dataTextStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                columns: const [
                  DataColumn(
                    label: Text('Time'),
                  ),
                  DataColumn(
                    label: Text('Temperature'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Humidity'),
                    numeric: true,
                  ),
                ],
                rows: historicalData.map<DataRow>((data) {
                  final time = data['time'] as DateTime;
                  final temperature = data['temperature'] as double;
                  final humidity = data['humidity'] as double;
                  
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(_formatTime(time)),
                      ),
                      DataCell(
                        Text('${temperature.toStringAsFixed(1)}°C'),
                      ),
                      DataCell(
                        Text('${humidity.toStringAsFixed(1)}%'),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _loadDeviceData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
          ),
          SizedBox(height: 16),
          Text(
            'Loading device data...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.data_usage_outlined,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          const Text(
            'No data available',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadDeviceData,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getBatteryColor(int battery) {
    if (battery > 60) return AppColors.success;
    if (battery > 30) return AppColors.warning;
    return AppColors.error;
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
