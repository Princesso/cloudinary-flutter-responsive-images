import 'package:flutter/material.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'responsive_image.dart';

void main() {
  CloudinaryContext.cloudinary = Cloudinary.fromStringUrl(
    "cloudinary://@dhuoxl63u?analytics=false",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Responsive Cloudinary Images',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('This image adapts to your device type:'),
            SizedBox(height: 20),
            ResponsiveImage(
              publicId: 'sample',
              width: 300,
              height: 200,
              deviceConfig: ResponsiveImageConfig(
                phone: DeviceConfig(width: 200, height: 130),
                tablet: DeviceConfig(width: 600, height: 400),
                desktop: DeviceConfig(width: 500, height: 350),
                tv: DeviceConfig(width: 800, height: 600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
