<div align="center">

<img src="assets\branding\presentation\luncher_icon.png" alt="AcademiaX Luncher" width="30%"/>

<br/>

# AcademiaX

### Smart Academic Management System

*A unified, cross-platform Learning Management System built for the modern university.*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.10.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge)](https://bloclibrary.dev/)
[![MVVM](https://img.shields.io/badge/Pattern-MVVM-ff69b4?style=for-the-badge)](https://docs.flutter.dev/app-architecture/guide)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey?style=for-the-badge&logo=flutter)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-All%20Rights%20Reserved-red?style=for-the-badge)](#license)
<a href="https://docs.flutter.dev/app-architecture/guide">
  <img src="https://img.shields.io/badge/Pattern-Repository-4CAF50?style=for-the-badge" alt="Repository Pattern"/>
</a>
<a href="https://pub.dev/packages/go_router">
  <img src="https://img.shields.io/badge/Routing-go__router-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="go_router"/>
</a>
<p align="center">
  <img src="https://img.shields.io/github/stars/mohamed-dev-404/academiax?style=for-the-badge&logo=github&color=DAA520" alt="Stars" />
  <img src="https://img.shields.io/github/forks/mohamed-dev-404/academiax?style=for-the-badge&logo=github&color=E67E22" alt="Forks" />
  <img src="https://img.shields.io/github/issues/mohamed-dev-404/academiax?style=for-the-badge&logo=github&color=E74C3C" alt="Issues" />
  <img src="https://img.shields.io/github/issues-closed/mohamed-dev-404/academiax?style=for-the-badge&logo=github&color=6F42C1" alt="Closed Issues" />
  <img src="https://img.shields.io/github/issues-pr-closed/mohamed-dev-404/academiax?style=for-the-badge&logo=github&color=008080" alt="Closed PRs" />
</p>
<a href="https://github.com/mohamed-dev-404/academiax">
  <img src="https://dynamic-repo-badges.vercel.app/svg/count/2/Repository%20Views/mohamed-dev-404-academiax" alt="Repository Views" />
</a>

<br/>

<p align="center">
  <a href="https://academiax-green.vercel.app/">
    <img src="assets\branding\badges\badge_web.png" width="232"/>
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://drive.google.com/drive/u/1/folders/1vaPCRjFNjgmNSQoGid9K8T1JeghHY9SH">
    <img src="assets\branding\badges\badge_apk.png" width="232"/>
  </a>
</p>


</div>

<br/>

<div align="center">
<img src="assets\branding\presentation\poster.png" alt="AcademiaX Poster" width="80%"/>
</div>

<br/>

---

## 📋 Table of Contents

<br>

**🔷 Overview**

| | Section | |
|:--:|:--|:--|
| 📖 | [About the Project](#-about-the-project) | `Overview` |
| ✨ | [Core Features](#-core-features) | `Highlights` |

<br>

**⚙️ Technical**

| | Section | |
|:--:|:--|:--|
| 🏗 | [Architecture Overview](#-architecture-overview) | `Feature-Driven · MVVM` |
| 📁 | [Project Structure](#-project-structure) | `lib/ tree` |
| ⚒  | [Tech Stack & Dependencies](#-tech-stack--dependencies) | `Packages & Plugins` |
| 🚀 | [Getting Started](#-getting-started) | `Setup Guide` |

<br>

**📦 Resources**

| | Section | |
|:--:|:--|:--|
| 🎬 | [Demo](#-demo) | `Mobile · Web GIFs` |
| 🔗 | [Related Repositories](#-related-repositories) | `Flutter · NestJS · Python` |
| 👥 | [Flutter Team](#-flutter-team) | `4 contributors` |
| 📄 | [License](#-license) | `MIT` |

---

## 📖 About the Project

**AcademiaX** (Smart Academic Management System — SAMS) is an all-in-one, self-contained digital ecosystem designed to streamline, centralize, and modernize university academic operations. Built entirely with Flutter, it delivers a fully unified codebase for both **mobile** (Android & iOS) and **web** platforms.

Unlike fragmented tool combinations that institutions typically rely on — stitching together separate video call software, file hosting services, and external grading systems — AcademiaX operates as a cohesive native platform, eliminating workflow inefficiencies and providing a consistent, purpose-built experience for **Students**, **Instructors**, and **Administrators**.

The system natively unifies:

- Secure authentication with JWT-based session management
- Course material distribution (video & PDF)
- Real-time assignment submission with AI-powered plagiarism detection
- Live video classroom sessions via Agora RTC
- Interactive quizzes with per-question timers
- Instructor grading dashboards with export capabilities
- Announcement feeds with community commenting
- Full administrative user and role management

---

## ✨ Core Features

### 👤 Student Experience
- Secure account registration and OTP-based password recovery (via institutional Outlook email)
- Course enrollment via invitation codes or deep enrollment links
- On-demand access to lecture materials (PDF documents and MP4 video streams)
- Assignment submission with deadline enforcement and plagiarism-aware flow
- Quiz taking with per-question countdown timers
- Live participation in real-time broadcast classrooms
- Private gradebook for viewing published marks
- Announcement feed with interactive comment sections

### 👨‍🏫 Instructor Experience
- Full CRUD control over course profiles (name, code, total grade, final exam weight)
- Dynamic grade schema configuration: Midterms, Assignments, Attendance, Quizzes, and Bonus marks
- Advanced quiz engine: MCQ, True/False, and Written/Short-Answer formats with per-question point assignments and time limits
- Assignment provisioning with an AI plagiarism analysis toggle
- Live classroom hosting with full broadcast moderation tools
- Grading dashboard with offline-first support and Excel export functionality

### 🔑 Administrator Experience
- Global user management with manual account provisioning
- Account activation and deactivation controls
- Role management: student ↔ instructor permission reallocation

---

## 🏗 Architecture Overview

This Flutter application strictly follows a **Feature-Driven Architecture** closely aligned with Clean Architecture principles, combined with the **MVVM (Model-View-ViewModel)** pattern and the **Repository Pattern** for full data-source abstraction and unit testability.

```
                  ┌──────────────────────────────────────────────────────────────────────┐
                  │                      FLUTTER CLIENT (This Repo)                      │
                  │                                                                      │
                  │  ┌─────────────────┐   ┌──────────────────┐   ┌──────────────────┐   │
                  │  │ Feature-Driven  │   │ Cubit/Bloc State │   │   Shared/Secure  │   │
                  │  │  Architecture   │   │   Management     │   │       Storage    │   │
                  │  └─────────────────┘   └──────────────────┘   └──────────────────┘   │
                  │                                                                      │
                  │  ┌─────────────────┐   ┌─────────────────┐   ┌──────────────────┐    │
                  │  │   go_router     │   │   Dio + Custom  │   │    GetIt DI      │    │
                  │  │ Declarative Nav │   │   Interceptors  │   │ Service Locator  │    │
                  │  └─────────────────┘   └─────────────────┘   └──────────────────┘    │
                  └───────────────────────────────┬──────────────────────────────────────┘
                                                  │ REST API (Dio)
                                                  ▼
                                    ┌─────────────────────────────────┐
                                    │        NestJS Backend           │
                                    │  JWT Auth · MongoDB · Redis     │
                                    └──────────────┬──────────────────┘
                                                   │
                                    ┌──────────────┴──────────────────┐
                                    │     Python AI Microservice      │
                                    │  Plagiarism Detection (NLP)     │
                                    └─────────────────────────────────┘
```

### State Management Philosophy

Business logic is fully separated from the UI layer using **Cubit** (from the Bloc ecosystem). Each feature owns its own Cubits/Blocs, ensuring predictable, testable state transitions with no cross-feature coupling.

- `hydrated_bloc` persists critical state across sessions without additional boilerplate.
- `Dartz` (`Either<Failure, Data>`) provides type-safe, functional error handling at the repository layer.

### Navigation

`go_router` handles all declarative routing and deep linking, supporting proper URL synchronization on the web and clean navigation stacks on mobile.

### Dependency Injection

`get_it` (Service Locator pattern) manages all singleton and factory allocations lazily at runtime, keeping features decoupled and independently initializable via `app_initializer.dart`.

---

## 📁 Project Structure

```
lib/
├── app_initializer.dart       # App startup configuration & DI registration
├── main.dart                  # Application entry point
├── my_app.dart                # Root MaterialApp widget & router setup
│
├── core/                      # App-wide shared resources
│   ├── cache/                 # Local caching mechanisms (SharedPrefs, SecureStorage)
│   ├── enums/                 # Shared application enums
│   ├── errors/                # Error models, failures, and exception types
│   ├── extentions/            # Dart extension methods
│   ├── functions/             # Global utility/helper functions
│   ├── helper/                # Helper classes
│   ├── models/                # Shared data models
│   ├── network/               # Network layer: ApiConsumer, Dio config, Interceptors
│   ├── services/              # External services (S3 Upload, File Saver)
│   ├── utils/                 # Constants, App Colors, Text Styles, Themes
│   ├── validators/            # Reusable form validation logic
│   └── widgets/               # Shared UI components (Buttons, TextFields, Dialogs)
│
└── features/                  # Independent, self-contained feature modules
    ├── auth/                  # Login, Registration, OTP, Password Recovery
    ├── home/                  # Main dashboard & navigation hub
    ├── course_details/        # Course overview, enrollment, and syllabus
    ├── materials/             # Lecture content: PDF & video players
    ├── assignments/           # Assignment viewing, submission, and plagiarism flow
    ├── quizzes/               # Quiz engine: creation, taking, and review
    ├── grades/                # Instructor grading dashboard & student gradebook
    ├── announcements/         # Announcement feed with comments
    ├── live_sessions/         # Agora RTC integration for live classes
    ├── profile/               # User profile management
    └── splash/                # App launch screen
```

### Feature Module Pattern

Every feature strictly follows the same internal structure to ensure consistency and discoverability:

```
feature_name/
├── data/
│   ├── models/                # DTOs (Data Transfer Objects) & JSON parsers
│   └── repos/                 # Repository implementations (data source abstraction)
└── presentation/
    ├── view_models/           # Business logic (Cubits / Blocs)
    └── views/                 # UI screens & feature-specific widgets
```

---

## ⚒ Tech Stack & Dependencies

### Core

| Package | Version | Purpose |
|---|---|---|
| `flutter` | `>=3.10.1` | Cross-platform UI framework (iOS, Android, Web) |
| `flutter_bloc` | latest | Bloc/Cubit state management |
| `hydrated_bloc` | latest | Persisted bloc state across sessions |
| `go_router` | latest | Declarative routing & deep linking |
| `get_it` | latest | Dependency injection (Service Locator) |
| `dartz` | latest | Functional programming: `Either<L, R>` types |

### Networking & Authentication

| Package | Purpose |
|---|---|
| `dio` | HTTP client with custom interceptors & error parsing |
| `jwt_decoder` | Parsing and inspecting JSON Web Tokens |

### Storage & Caching

| Package | Purpose |
|---|---|
| `shared_preferences` | Key-value local storage for session data |
| `flutter_secure_storage` | Encrypted storage for sensitive tokens |
| `get_storage` | Fast, lightweight key-value store |
| `cached_network_image` | Efficient network image caching & display |

### UI & UX

| Package | Purpose |
|---|---|
| `flutter_screenutil` | Responsive layouts scaled to any screen size |
| `device_preview` | Multi-device preview tool for development |
| `google_fonts` | Typography (Poppins — Thin to ExtraBold) |
| `flutter_svg` | SVG asset rendering |
| `lottie` | Animated Lottie illustrations |
| `loading_animation_widget` | Rich loading state animations |
| `skeletonizer` | Skeleton/shimmer loading placeholders |
| `fluttertoast` | In-app toast notifications |
| `dotted_border` | Dashed/dotted border UI decoration |
| `data_table_2` | Advanced, scrollable data tables |
| `smooth_page_indicator` | Page indicator dots for carousels/onboarding |
| `percent_indicator` | Circular and linear progress indicators |
| `pinput` | Styled OTP/PIN input field |

### Media & File Handling

| Package | Purpose |
|---|---|
| `video_player` | Native video playback |
| `chewie` | Full-featured video player UI wrapper |
| `audioplayers` | Audio playback support |
| `file_picker` | Cross-platform file selection from device |
| `image_picker` | Camera and gallery image capture |
| `image_cropper` | In-app image cropping |
| `flutter_image_compress` | Image compression before upload |

### Integration & Real-Time

| Package | Purpose |
|---|---|
| `agora_rtc_engine` | Real-time video/audio broadcasting for live sessions |
| `webview_flutter` | Embedded web views within the app |
| `webview_flutter_plus` | Extended WebView capabilities |

### Utilities

| Package | Purpose |
|---|---|
| `permission_handler` | Runtime OS permission requests |
| `url_launcher` | Opening external URLs and deep links |
| `connectivity_plus` | Network state monitoring |
| `logger` | Structured console logging for debugging |
| `cupertino_icons` | iOS-style icon set |

### Assets Configuration

The following asset directories are registered in `pubspec.yaml`:

```
assets/
├── images/       # App illustrations and background assets
├── icons/        # Custom icon assets
├── lottie/       # Lottie animation files
├── audio/        # Audio assets
├── branding/     # Logos, poster, and brand identity assets
└── fonts/
    └── Poppins/  # Poppins font family (Thin → ExtraBold)
```

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.10.1`
- [Dart SDK](https://dart.dev/get-dart) `>=3.x`
- Android Studio / Xcode (for mobile targets)
- A modern web browser (for web target)

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/academiax-flutter.git
cd academiax-flutter
```

**2. Clean any previous build artifacts**

```bash
flutter clean
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
# Run on connected mobile device or emulator
flutter run

# Run specifically on web
flutter run -d chrome

# Build a release APK
flutter build apk --release

# Build for web
flutter build web --release
```

### 🌐 Try It Now — No Setup Required

<p align="center">
  <a href="https://academiax-green.vercel.app/">
    <img src="assets\branding\badges\badge_web.png" width="232"/>
  </a>
  &nbsp;&nbsp;
  <a href="https://drive.google.com/drive/u/1/folders/1vaPCRjFNjgmNSQoGid9K8T1JeghHY9SH">
    <img src="assets\branding\badges\badge_apk.png" width="232"/>
  </a>
</p>

---

## 🎬 Demo

> All demos below are organized by feature and divided into **Mobile** and **Web** walkthroughs.

---

### 1. Authentication & Profile

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets/branding/demo/auth/auth_profile_mobile.gif" height="390" alt="Auth & Profile — Mobile"/>
</td>
<td align="center">
<img src="assets/branding/demo/auth/auth_profile_web.gif" height="390" alt="Auth & Profile — Web"/>
</td>
</tr>
</table>

> **Covers**: Registration, Login, OTP email verification, Password recovery, and Profile management.

---

### 2. Create Course & Join

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets\branding\demo\courses\create_join_course_mobile.gif" height="390" alt="Create Course & Join — Mobile"/>
</td>
<td align="center">
<img src="assets/branding/demo/courses/create_join_course_web.gif" height="390" alt="Create Course & Join — Web"/>
</td>
</tr>
</table>

> **Covers**: Instructor course creation (name, code, grade configuration), student enrollment via invitation code, and course dashboard view.

---

### 3. Material Management

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets\branding\demo\materials\materials_mobile.gif" height="390" alt="Material Management — Mobile"/>
</td>
<td align="center">
<img src="assets\branding\demo\materials\materials_web.gif" height="390" alt="Material Management — Web"/>
</td>
</tr>
</table>

> **Covers**: Instructor uploading PDF and MP4 materials, student browsing, PDF viewing, and video streaming.

---

### 4. Assignment Flow

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets\branding\demo\assignments\assignments_mobile.gif" height="390" alt="Assignment Flow — Mobile"/>
</td>
<td align="center">
<img src="assets\branding\demo\assignments\assignments_web.gif" height="390" alt="Assignment Flow — Web"/>
</td>
</tr>
</table>

> **Covers**: Instructor creating assignments with plagiarism toggle, student viewing guidelines and submitting files, and AI plagiarism analysis result display.

---

### 5. Announcements

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets\branding\demo\announcements\announcements_mobile.gif" height="390" alt="Announcements — Mobile"/>
</td>
<td align="center">
<img src="assets\branding\demo\announcements\announcements_web.gif" height="390" alt="Announcements — Web"/>
</td>
</tr>
</table>

> **Covers**: Instructor posting announcements, student reading feed, and community comment interaction.*

---

### 6. Grades

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets/branding/demo/grades/grades_mobile.gif" height="390" alt="Grades — Mobile"/>
</td>
<td align="center">
<img src="assets/branding/demo/grades/grades_web.gif" height="390" alt="Grades — Web"/>
</td>
</tr>
</table>

> **Covers**: Instructor grading dashboard (data table, score entry, publish controls, Excel export), and student private gradebook view.

---

### 7. Quiz Flow

<table>
<tr>
<th>📱 Mobile</th>
<th>🖥️ Web</th>
</tr>
<tr>
<td align="center">
<img src="assets/branding/demo/quizzes/quizzes_mobile.gif" height="390" alt=" Quiz Flow — Mobile"/>
</td>
<td align="center">
<img src="assets/branding/demo/quizzes/quizzes_web.gif" height="390" alt=" Quiz Flow — Web"/>
</td>
</tr>
</table>

> **Covers**: Instructor quiz creation (MCQ, True/False, Written), student quiz taking with per-question countdown timers, and result review.*

---

## 🔗 Related Repositories

This Flutter app is the client layer of a three-part system:

| Repository | Description | Link |
|---|---|---|
| **Flutter Client** *(this repo)* | Cross-platform mobile & web application (iOS · Android · Web) | Current Repository |
| **Admin Dashboard** | Flutter Web-only admin panel · MVVM · CI/CD pipeline · User & role management | [mohamed-dev-404/academiax-admin-dashboard](https://github.com/mohamed-dev-404/academiax-admin-dashboard) |
| **Backend API** | NestJS REST API · MongoDB · Redis · JWT Auth | [gemmy404/sams-api](https://github.com/gemmy404/sams-api) |
| **AI Plagiarism Engine** | Python NLP microservice · Sentence Transformers | [mohammedeissa7/plagiarism_project](https://github.com/mohammedeissa7/plagiarism_project) |

---

## 👨‍💻 Flutter Team

The following contributors are responsible for the Flutter client application:

<table>
<tr>
<td align="center">
  <a href="https://github.com/mohamed-dev-404">
    <img src="https://github.com/mohamed-dev-404.png" width="80px;" alt="Mohamed Ibrahim"/><br/>
    <sub><b>Mohamed Ibrahim</b></sub>
  </a>
</td>
<td align="center">
  <a href="https://github.com/muhmdxFlutter">
    <img src="https://github.com/muhmdxFlutter.png" width="80px;" alt="Mohamed Mustafa"/><br/>
    <sub><b>Mohamed Mustafa</b></sub>
  </a>
</td>
<td align="center">
  <a href="https://github.com/Yomna-Abdelmegeed">
    <img src="https://github.com/Yomna-Abdelmegeed.png" width="80px;" alt="Yomna Abdelmegeed"/><br/>
    <sub><b>Yomna Abdelmegeed</b></sub>
  </a>
</td>
<td align="center">
  <a href="https://github.com/nadia022">
    <img src="https://github.com/nadia022.png" width="80px;" alt="Nadia Ashraf"/><br/>
    <sub><b>Nadia Ashraf</b></sub>
  </a>
</td>
</tr>
</table>

---

## 📄 License

Copyright © 2026 AcademiaX Team — October 6 University (O6U), Faculty of Information Systems & Computer Science.

**All Rights Reserved.**

This project and all its source code, assets, and documentation are the intellectual property of the AcademiaX development team. No part of this project may be reproduced, distributed, or transmitted in any form or by any means without the prior written permission of the authors.

---

<div align="center">

Made with ❤️ using Flutter

</div>
