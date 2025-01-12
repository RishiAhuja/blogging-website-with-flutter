# Flutter Web Blog Platform 🚀

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com)
[![State Management](https://img.shields.io/badge/Bloc-8.x-purple.svg)](https://bloclibrary.dev)
[![DI](https://img.shields.io/badge/GetIt-7.x-green.svg)](https://pub.dev/packages/get_it)
[![Storage](https://img.shields.io/badge/Hive-3.x-yellow.svg)](https://pub.dev/packages/hive)
[![Clean Architecture](https://img.shields.io/badge/Clean%20Architecture-Implemented-blue.svg)]()

> ⚠️ **Note**: This project is currently under active development and serves as a learning resource for Clean Architecture and BLoC pattern implementation. Some features might be unstable.

## Table of Contents

- [About The Project](#about-the-project)
- [Features](#features)
- [Visual Overview](#visual-overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Project](#running-the-project)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## About The Project

A web-first blogging platform built with Flutter, demonstrating modern architectural patterns and state management solutions. This project showcases how Flutter can be effectively used for web applications while maintaining clean code principles and scalable architecture.

[Read My Clean Architecture Implementation](https://rishi2220.hashnode.dev/getting-cracked-at-clean-and-bloc-architecture)

## Features

- Web-first design
- Clean Architecture
- BLoC state management
- Firebase integration
- Hive for local storage
- Dependency injection with GetIt

## Visual Overview

![Screenshot 1](/assets/screenshots/1.png)
*Get Started Page*

![Screenshot 2](/assets/screenshots/2.png)
*Blog Preview Page*

![Screenshot 3](/assets/screenshots/3.png)
*Raw Markdown Editor*

![Screenshot 4](/assets/screenshots/4.png)
*Login Page*

![Screenshot 5](/assets/screenshots/5.png)
*Blog List*

![Screenshot 6](/assets/screenshots/6.png)
*Profile Page*

![Screenshot 7](/assets/screenshots/7.png)
*Profile Edit Page*

![Screenshot 8](/assets/screenshots/8.png)
*Following Popup*

![Screenshot 9](/assets/screenshots/9.png)
*Profile Page*


## Getting Started

### Prerequisites

- Flutter 3.x
- Firebase account
- Dart 2.17 or later

### Installation

1. Clone the repo:
   ```sh
   git clone https://github.com/yourusername/yourrepo.git
   ```

2. Install dependencies
```bash
flutter pub get
```

3. Firebase Setup
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

4. Configure environment variables
- Create a `.env` file
- Add necessary Firebase configurations

5. Run the project
```bash
flutter run -d chrome --web-renderer canvaskit
```

## Contributing

This project is ideal for developers looking to understand:
- Clean Architecture implementation in Flutter
- BLoC pattern usage in real applications
- Firebase integration
- Web-first Flutter development

### Areas for Contribution

1. **Feature Improvements**
   - Enhanced markdown editor features
   - Better image handling
   - Social sharing capabilities
   - Comments system

2. **Technical Improvements**
   - Test coverage
   - Performance optimizations
   - Caching strategies
   - SEO improvements

3. **Documentation**
   - Code documentation
   - Wiki pages
   - Architecture diagrams

### Getting Started with Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


⭐ If you found this project helpful, please star it!
