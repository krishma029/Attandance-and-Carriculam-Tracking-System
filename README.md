# 📘 TrackAcademy – Attendance & Curriculum Tracking System

The Attendance and Curriculum Tracking System is a smart solution designed for schools, colleges, and coaching institutes to digitize attendance management and track curriculum progress efficiently.  
It enables transparent communication between students, teachers, and parents while providing insights into learning outcomes.

---

## 🚀 Features
- **Student Module**
  - Sign up & login with enrollment number
  - Track attendance & curriculum progress
  - View performance reports

- **Parent Module**
  - Monitor child’s attendance and curriculum progress
  - Receive notifications and performance reports

- **Teacher Module**
  - Mark attendance quickly
  - Update curriculum status
  - Generate weekly/monthly reports

---

## 🛠️ Tech Stack
- **Frontend:** Flutter (Mobile App)  
- **Backend:** PHP (API services)  
- **Database:** PostgreSQL (pgAdmin)  

---

## ⚡ Setup Instructions
⚙️ Installation & Setup
🔹 1. Database Setup (PostgreSQL)

Open pgAdmin or terminal.

Create new database:

CREATE DATABASE trackademy_db;


🔹 2. Backend Setup (PHP + PostgreSQL)

Install XAMPP / WAMP / Laragon (or any PHP server).

Copy the trackademy/ folder into:

htdocs/ (XAMPP)


🔹 3. Frontend Setup (Flutter)

Install Flutter SDK and Android Studio / VS Code.

Navigate to the frontend folder:
cd Frontend
Install dependencies:

flutter pub get

Run the app:
flutter run
Make sure emulator/physical device is connected.
