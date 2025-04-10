# FaceMelt

FaceMelt is a privacy-focused iOS application that allows users to add blur filters to faces in their photos. The app processes all images locally on the device, ensuring no data leaves your phone.

## Features

- Select photos from your library
- Automatic face detection
- Manual blur circle placement and adjustment
- Customizable blur intensity
- Privacy-first approach with no data collection
- All processing done on-device

## Technical Details

- Built with Swift and SwiftUI
- Uses Vision framework for face detection
- Implements custom CIFilter for blur effects
- Local-only processing with no network calls
- Metal-accelerated image processing

## Privacy

FaceMelt is designed with privacy as the top priority:
- No data collection
- No analytics
- No network calls
- All processing happens on-device
- No user data is stored or transmitted

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
2. Open the project in Xcode
3. Build and run on your device or simulator

## Architecture

The app follows a clean MVVM architecture:
- Views: SwiftUI views for the user interface
- ViewModels: Handle business logic and state management
- Models: Data structures and image processing components
- Services: Photo library access and image processing utilities

## License

MIT License - See LICENSE file for details 
