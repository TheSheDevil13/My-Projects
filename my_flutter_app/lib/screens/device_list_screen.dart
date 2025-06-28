import 'package:flutter/material.dart';
import '../models/device.dart';
import '../widgets/device_card.dart';
import '../widgets/custom_app_bar.dart';
import '../services/device_service.dart';
import '../utils/theme.dart';
import 'device_detail_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final DeviceService _deviceService = DeviceService();
  List<Device> devices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      isScanning = true;
    });

    try {
      // TODO: Implement actual device scanning
      final scannedDevices = await _deviceService.scanForDevices();
      setState(() {
        devices = scannedDevices;
      });
    } catch (e) {
      // TODO: Implement proper error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning devices: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _connectToDevice(Device device) async {
    // Show connecting dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
            ),
            const SizedBox(width: 20),
            Text(
              'Connecting to ${device.name}...',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );

    try {
      // TODO: Implement actual device connection
      final success = await _deviceService.connectToDevice(device.id);
      
      // Close the connecting dialog
      Navigator.of(context).pop();
      
      if (success) {
        // Create connected device
        final connectedDevice = Device(
          id: device.id,
          name: device.name,
          type: device.type,
          signalStrength: device.signalStrength,
          isConnected: true,
          lastSeen: device.lastSeen,
          batteryLevel: device.batteryLevel,
          temperature: device.temperature,
          humidity: device.humidity,
        );

        // Update device list
        setState(() {
          final index = devices.indexWhere((d) => d.id == device.id);
          if (index != -1) {
            devices[index] = connectedDevice;
          }
        });
        
        // Navigate directly to device detail screen
        _navigateToDeviceDetail(connectedDevice);
        
      } else {
        // TODO: Handle connection failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to ${device.name}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      // Close the connecting dialog if still open
      Navigator.of(context).pop();
      
      // TODO: Handle connection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
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
        title: 'Available Devices',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isScanning ? AppColors.textHint : Colors.white,
            ),
            onPressed: isScanning ? null : _loadDevices,
          ),
        ],
      ),
      body: Column(
        children: [
          // Scanning Progress
          if (isScanning)
            LinearProgressIndicator(
              backgroundColor: AppColors.primaryBlue,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
            ),
          
          // Device Count Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.devices,
                  color: AppColors.accentCyan,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Found ${devices.length} device${devices.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (isScanning)
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
          ),
          
          // Device List
          Expanded(
            child: devices.isEmpty && !isScanning
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadDevices,
                    color: AppColors.accentCyan,
                    backgroundColor: AppColors.cardBackground,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return DeviceCard(
                          device: device,
                          onTap: device.isConnected 
                              ? () => _navigateToDeviceDetail(device)
                              : null,
                          onConnect: device.isConnected 
                              ? null 
                              : () => _connectToDevice(device),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : _loadDevices,
        backgroundColor: isScanning 
            ? AppColors.textHint 
            : AppColors.accentCyan,
        child: isScanning
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          const Text(
            'No devices found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pull down to refresh or tap the scan button',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadDevices,
            icon: const Icon(Icons.search),
            label: const Text('Scan for Devices'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDeviceDetail(Device device) {
    // TODO: Navigate to device detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailScreen(device: device),
      ),
    );
  }
}
