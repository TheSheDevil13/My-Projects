import 'package:flutter/material.dart';
import '../models/device.dart';
import '../utils/theme.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;

  const DeviceCard({
    Key? key,
    required this.device,
    this.onTap,
    this.onConnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Device Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: device.isConnected 
                      ? AppColors.connected 
                      : AppColors.accentCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.devices,
                  color: device.isConnected 
                      ? Colors.white 
                      : AppColors.accentCyan,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Device Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Signal: ${device.signalStrength.toStringAsFixed(0)} dBm',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          device.isConnected 
                              ? Icons.bluetooth_connected 
                              : Icons.bluetooth,
                          size: 16,
                          color: device.isConnected 
                              ? AppColors.connected 
                              : AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          device.isConnected ? 'Connected' : 'Available',
                          style: TextStyle(
                            fontSize: 12,
                            color: device.isConnected 
                                ? AppColors.connected 
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Connect Button or Status
              if (!device.isConnected)
                ElevatedButton(
                  onPressed: onConnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 8,
                    ),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, 
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.connected.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.connected,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.connected,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
