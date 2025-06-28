import 'package:flutter/material.dart';
import 'screens/device_list_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Device Scanner',
      theme: AppTheme.darkTheme,
      home: const DeviceListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
//     );
//   }
// }
