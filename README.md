# F1AI Companion

## Overview
### Introduction to the F1AI App
This app is designed for racing enthusiasts and professionals to manage and analyze their racing telemetry data, car setups, and performance metrics. Provides a user-friendly interface to record, display, and interpret various data points critical to improving race performance.

### Purpose and Target Audience
Purpose:
- To oﬀer detailed telemetry analysis and car setup management.
- To help users optimize their racing performance through data-driven insights.
Target Audience:
- E-Sport professionals seeking to fine-tune their performance.
- E-Sport teams needing comprehensive data analysis tools.
- Amateur racers aiming to improve their skills and understand their telemetry data.

### Telemetry Data Analysis
- *Real-time Data Collection*: Captures data from various sensors during racing sessions.
- *Comprehensive Metrics*: Includes speed, throttle position, brake pressure, and more.
- *Data Visualization*: Graphs and charts for easy interpretation of performance.
- *Comparative Analysis*: Compare diﬀerent laps and sessions to identify performance trends and areas for improvement.

### Car Setup Management
- *Setup Configurations*: Manage various car setups including suspension, aerodynamics, tire pressure, etc.
- *Setup Storage*: Save and retrieve multiple configurations for diﬀerent tracks and conditions.
- *Setup Comparison*: Compare diﬀerent setups to see which configurations yield the best performance.

### User Profile Customization
- *Profile Information*: Manage personal information and racing preferences.
- *Customization Options*: Customize the user interface and data display settings.
- *Performance Tracking*: Track personal bests and historical performance data.

### Session Management and Review
- *Session Recording*: Automatically record all racing sessions with detailed telemetry data.
- *Session Overview*: Summary of key metrics for each session.
- *Detailed Review*: In-depth analysis of individual sessions, including lap-by-lap breakdowns.

### Detailed Lap Insights
- *Lap Timing*: Accurate lap timing with sector splits.
- *Performance Metrics*: Detailed metrics for each lap to analyze driving technique.
- *Comparative Insights*: Compare laps within the same session or across diﬀerent sessions.
- *Visual Analysis*: Graphical representation of lap data to identify optimal racing lines and techniques.

## File Breakdown
### [home_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/home_page.dart)
- _Purpose_: Main dashboard of the app.
- _Key Responsibilities_:
  - Aggregates and displays an overview of recent sessions.
  - Provides quick links to diﬀerent sections of the app.
  - Displays summary statistics and key performance indicators.
 
### [profile_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/profile_page.dart)
- *Purpose*: Manages user profile functionalities.
- *Key Responsibilities*:
  - Displays user information and preferences.
  - Allows access to profile customization options.

### [edit_profile_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/edit_profile_page.dart)
- *Purpose*: Facilitates editing of user profile details.
- *Key Responsibilities*:
  - Provides form fields for updating user information.
  - Ensures data validation and integrity.

### [sessions_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/sessions_page.dart)
- *Purpose*: Lists all recorded racing sessions.
- *Key Responsibilities*:
  - Allows users to browse through their sessions.
  - Provides session summaries and key metrics.
  - Enables selection of individual sessions for detailed analysis.

### [last_session_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/last_session_page.dart)
- *Purpose*: Displays details of the most recent session.
- *Key Responsibilities*:
  - Highlights key performance metrics.
  - Provides a summary and in-depth data for the latest session.

### [lap_details_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/lap_details_page.dart)
- *Purpose*: Analyzes individual laps in detail.
- *Key Responsibilities*:
  - Oﬀers telemetry data for each lap, such as speed and throttle position.
  - Helps users understand their performance on a lap-by-lap basis.
 
### [telemetry_data_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/telemetry_data_page.dart)
- *Purpose*: Displays comprehensive telemetry data.
- *Key Responsibilities*:
  - Visualizes performance metrics through various charts and graphs.
  - Allows users to identify trends and areas for improvement.

### [car_setup_detail_page.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/car_setup_detail_page.dart)
- *Purpose*: Manages detailed car setup configurations.
- *Key Responsibilities*:
  - Handles parameters like tire pressure, suspension settings, and aerodynamics.
  - Allows users to save and retrieve diﬀerent setups.

### [setup_info.dart](https://github.com/ilaario/FlutterApplication/blob/main/lib/setup_info.dart)
- *Purpose*: Supports car setup management.
- *Key Responsibilities*:
  - Contains data structures and logic for managing setup information.
  - Ensures accurate storage and retrieval of configurations.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
