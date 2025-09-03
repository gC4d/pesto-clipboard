# Pesto Clipboard - Flutter Frontend

A modern, clean Flutter desktop application for Linux that serves as a UI frontend for the Rust-based clipboard manager backend.

## Features

- View clipboard history with real-time updates
- Filter clipboard items by type (text, image, code)
- Search clipboard content
- Apply clipboard items with a single click
- Save current clipboard content
- Modern Material Design 3 UI with light and dark themes
- Offline mode indicators and graceful error handling
- Apply clipboard entries with a single click
- Real-time clipboard monitoring

## Architecture

The application follows a clean architecture pattern with:

- **Models**: Data structures that represent clipboard items
- **Services**: API interaction with backend and clipboard management
- **Providers**: State management using Provider pattern
- **Screens**: UI pages and navigation
- **Widgets**: Reusable UI components

## Backend Integration

The frontend integrates with a Rust backend through REST API endpoints:

- `POST /clipboard` – Save new clipboard item
- `GET /clipboard` – List all items
- `POST /clipboard/{id}/apply` – Apply an item as current
- `GET /clipboard/current` – Get currently applied clipboard item

## Development

### Prerequisites

- Flutter SDK (latest stable version)
- Linux development environment

### Setup

1. Make sure you have Flutter installed and set up for Linux desktop development
2. Ensure the Rust backend is running
3. Run the following commands:

```bash
cd frontend
flutter pub get
flutter run -d linux
```

### Configuration

The backend API URL and other settings can be modified in `lib/config/app_config.dart`
