# Cloudinary Responsive Images for Flutter

A Flutter application that demonstrates how to serve responsive, device-aware images using [Cloudinary](https://cloudinary.com/). Images are automatically resized and optimized based on the detected device type (phone, tablet, desktop, or TV).

## Features

- **Device detection** — automatically identifies the device type using `device_info_plus` (iOS model check, Android) with a screen-width fallback
- **Per-device image sizing** — configure different width/height dimensions for each device type
- **Cloudinary transformations** — applies `c_fill` crop, `q_auto` quality, and `f_auto` format for optimal delivery
- **Reusable widget** — the `ResponsiveImage` widget can be dropped into any Flutter layout

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.12.1)
- A [Cloudinary account](https://cloudinary.com/users/register/free) (free tier works)
- Your Cloudinary **cloud name** (found on the Cloudinary dashboard)

## Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd responsive_images
   ```

2. **Set your Cloudinary cloud name**

   Open `lib/main.dart` and replace the cloud name in the connection string:

   ```dart
   CloudinaryContext.cloudinary = Cloudinary.fromStringUrl(
     "cloudinary://@YOUR_CLOUD_NAME?analytics=false",
   );
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

   Use `-d` to target a specific device:

   ```bash
   flutter run -d chrome    # Web
   flutter run -d macos     # macOS desktop
   flutter run -d ios       # iOS simulator
   flutter run -d android   # Android emulator
   ```

## Project Structure

```
lib/
├── main.dart              # App entry point and Cloudinary configuration
└── responsive_image.dart  # ResponsiveImage widget and device detection logic
```

## Usage

### Basic usage

```dart
ResponsiveImage(
  publicId: 'sample',
  width: 300,
  height: 200,
)
```

### With per-device configuration

```dart
ResponsiveImage(
  publicId: 'sample',
  width: 300,   // default fallback
  height: 200,  // default fallback
  deviceConfig: ResponsiveImageConfig(
    phone:   DeviceConfig(width: 200, height: 130),
    tablet:  DeviceConfig(width: 600, height: 400),
    desktop: DeviceConfig(width: 500, height: 350),
    tv:      DeviceConfig(width: 800, height: 600),
  ),
)
```

If a device type has no config, the widget falls back to the default `width` and `height`.

### Device detection breakpoints

| Device  | Screen width       |
|---------|--------------------|
| Phone   | < 768px            |
| Tablet  | 768px – 1023px     |
| Desktop | 1024px – 1919px    |
| TV      | ≥ 1920px           |

On iOS, iPads are detected by model name regardless of screen width.

## Dependencies

| Package                                                                 | Purpose                          |
|-------------------------------------------------------------------------|----------------------------------|
| [cloudinary_flutter](https://pub.dev/packages/cloudinary_flutter)       | Cloudinary image widget          |
| [cloudinary_url_gen](https://pub.dev/packages/cloudinary_url_gen)       | URL generation & transformations |
| [device_info_plus](https://pub.dev/packages/device_info_plus)           | Native device type detection     |

## How It Works

1. On startup, `CloudinaryContext` is initialized with your cloud name
2. `ResponsiveImage` detects the device type via `device_info_plus` and screen-width breakpoints
3. The appropriate `DeviceConfig` dimensions are selected
4. A Cloudinary URL is generated with `c_fill` resize, `q_auto`, and `f_auto` transformations
5. The image is fetched and cached via `CldImageWidget`

## License

This project is for demonstration purposes.
