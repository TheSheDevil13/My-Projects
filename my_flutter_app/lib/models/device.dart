class Device {
  final String id;
  final String name;
  final String type;
  final double signalStrength;
  final bool isConnected;
  final DateTime lastSeen;
  final int batteryLevel;
  final double temperature;
  final double humidity;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.signalStrength,
    this.isConnected = false,
    required this.lastSeen,
    this.batteryLevel = 100,
    this.temperature = 0.0,
    this.humidity = 0.0,
  });

  // Convert to/from JSON for API calls or local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'signalStrength': signalStrength,
      'isConnected': isConnected,
      'lastSeen': lastSeen.toIso8601String(),
      'batteryLevel': batteryLevel,
      'temperature': temperature,
      'humidity': humidity,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      signalStrength: json['signalStrength'],
      isConnected: json['isConnected'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen']),
      batteryLevel: json['batteryLevel'] ?? 100,
      temperature: json['temperature'] ?? 0.0,
      humidity: json['humidity'] ?? 0.0,
    );
  }
}
