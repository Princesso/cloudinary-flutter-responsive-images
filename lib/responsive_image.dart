import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum DeviceType {
  phone,
  tablet,
  desktop,
  tv,
}

class DeviceConfig {
  final int? width;
  final int? height;

  const DeviceConfig({this.width, this.height});
}

class ResponsiveImageConfig {
  final DeviceConfig? phone;
  final DeviceConfig? tablet;
  final DeviceConfig? desktop;
  final DeviceConfig? tv;

  const ResponsiveImageConfig({
    this.phone,
    this.tablet,
    this.desktop,
    this.tv,
  });
}

class ResponsiveImage extends StatefulWidget {
  final String publicId;
  final int width;
  final int height;
  final ResponsiveImageConfig? deviceConfig;

  const ResponsiveImage({
    Key? key,
    required this.publicId,
    required this.width,
    required this.height,
    this.deviceConfig,
  }) : super(key: key);

  @override
  State<ResponsiveImage> createState() => _ResponsiveImageState();
}

class _ResponsiveImageState extends State<ResponsiveImage> {
  DeviceType? _deviceType;

  @override
  void initState() {
    super.initState();
    _detectDeviceType();
  }

  Future<void> _detectDeviceType() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceType = _getDeviceTypeFromScreenSize();
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        if (iosInfo.model.toLowerCase().contains('ipad')) {
          _deviceType = DeviceType.tablet;
        } else {
          _deviceType = DeviceType.phone;
        }
      } else {
        _deviceType = DeviceType.desktop;
      }
    } catch (e) {
      _deviceType = _getDeviceTypeFromScreenSize();
    }

    if (mounted) {
      setState(() {});
    }
  }

  DeviceType _getDeviceTypeFromScreenSize() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 768) {
      return DeviceType.phone;
    } else if (screenWidth >= 768 && screenWidth < 1024) {
      return DeviceType.tablet;
    } else if (screenWidth >= 1024 && screenWidth < 1920) {
      return DeviceType.desktop;
    } else {
      return DeviceType.tv;
    }
  }

  DeviceType _getEffectiveDeviceType() {
    return _deviceType ?? _getDeviceTypeFromScreenSize();
  }

  DeviceConfig _getDimensions() {
    final effectiveType = _getEffectiveDeviceType();

    if (widget.deviceConfig != null) {
      switch (effectiveType) {
        case DeviceType.phone:
          if (widget.deviceConfig!.phone != null) {
            return DeviceConfig(
              width: widget.deviceConfig!.phone!.width ?? widget.width,
              height: widget.deviceConfig!.phone!.height ?? widget.height,
            );
          }
          break;
        case DeviceType.tablet:
          if (widget.deviceConfig!.tablet != null) {
            return DeviceConfig(
              width: widget.deviceConfig!.tablet!.width ?? widget.width,
              height: widget.deviceConfig!.tablet!.height ?? widget.height,
            );
          }
          break;
        case DeviceType.desktop:
          if (widget.deviceConfig!.desktop != null) {
            return DeviceConfig(
              width: widget.deviceConfig!.desktop!.width ?? widget.width,
              height: widget.deviceConfig!.desktop!.height ?? widget.height,
            );
          }
          break;
        case DeviceType.tv:
          if (widget.deviceConfig!.tv != null) {
            return DeviceConfig(
              width: widget.deviceConfig!.tv!.width ?? widget.width,
              height: widget.deviceConfig!.tv!.height ?? widget.height,
            );
          }
          break;
      }
    }

    return DeviceConfig(width: widget.width, height: widget.height);
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();
    final effectiveWidth = dimensions.width ?? widget.width;
    final effectiveHeight = dimensions.height ?? widget.height;

    return SizedBox(
      width: effectiveWidth.toDouble(),
      height: effectiveHeight.toDouble(),
      child: CldImageWidget(
        publicId: widget.publicId,
        transformation: Transformation()
          ..resize(Resize.fill()
            ..width(effectiveWidth)
            ..height(effectiveHeight))
          ..delivery(Delivery.quality('auto'))
          ..delivery(Delivery.format('auto')),
      ),
    );
  }
}
