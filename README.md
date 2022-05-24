# Misty Tracer

[![Link to Report](https://img.shields.io/badge/Report-DR%20NTU-blueviolet)](https://hdl.handle.net/10356/157337) ![Supported platforms: Android, iOS, and Google Chrome](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20google%20chrome%20%7C%20windows-lightgrey)

Dashboard app for TraceTogether check-in certificate verification using Misty robots.

| Landing Page | Robots Tab | Photos Tab |
| --- | --- | --- |
| ![](/docs/connect.gif) | ![](/docs/robot.gif) | ![](/docs/photos.gif) |

This app is the GUI component for my final year project for my Bachelors in Computer Science in Nanyang Technological University. There are 2 other components: [the server](https://github.com/SebastianLiando/misty-skills/tree/main/trace-together-checker/server) and [the robot](https://github.com/SebastianLiando/misty-skills/tree/main/trace-together-checker/skill). Please find the detailed report [here](https://hdl.handle.net/10356/157337).

## Features

### Realtime Updates

The user can se realtime changes to the robot or verifications. The app connects to the server via web socket. Depending on the tab the user is on, the app subscribes to robot or verification updates.

### Misty robot dashboard

User can see robot states and edit the robot's assigned location. New robots are highlighted and pinned to the top of the list so that it is configured quickly.

### Verification dashboard

User can see verification results, grouped by the location of check-in. User can also see the intermediate image processing results.

## How to Install

Import all the dependencies and assets.

```
flutter pub get
```

Generate library-generated code.

```
flutter pub run build_runner build
```

Run the Flutter application in release mode.

```
flutter run --release
```
