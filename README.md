# 🏜️ Sand Valley App

Sand Valley is a Flutter-based mobile application designed to manage and display agricultural resources—fertilizers, insecticides, seeds—and provide communication options. It features a secure, role‑based admin login system (admin & master), OTP‑based password reset, beautiful desert‑themed UI, and modular, maintainable routing.

---

## 📂 Project Structure

lib/ <br>
├── main.dart # App entry point (with Provider & Secure Storage setup)<br>
├── routes/<br>
│ └── app_routes.dart # All named routes<br>
├── screens/<br>
│ ├── splash/<br>
│ │ └── splash_screen.dart # Native + in‑app splash<br>
│ ├── home/<br>
│ │ └── home_screen.dart # Landing + auto‑login check<br>
│ ├── admin/<br>
│ │ ├── admin_login_screen.dart # Email/password with secure storage<br>
│ │ ├── admin_page.dart # Admin dashboard<br>
│ │ ├── master_admin_page.dart # Master admin dashboard<br>
│ │ ├── forgot_password_screen.dart # Enter email/username → send OTP<br>
│ │ ├── otp_screen.dart # 6‑digit OTP input + resend + timer<br>
│ │ └── reset_password_screen.dart # Enter new password + confirm<br>
│ ├── Communicate/<br>
│ │ ├── communicate_main.dart<br>
│ │ ├── communicate_eng.dart<br>
│ │ └── communicate_call.dart<br>
│ ├── Fertilizer/<br>
│ │ ├── fertilizer_main.dart<br>
│ │ ├── fertilizer_type_one.dart<br>
│ │ ├── fertilizer_type_two.dart<br>
│ │ └── fertilizer_description.dart<br>
│ ├── Insecticide/<br>
│ │ ├── insecticide_main.dart<br>
│ │ ├── insecticide_type.dart<br>
│ │ └── insecticide_description.dart<br>
│ └── seeds/<br>
│ ├── seed_main.dart<br>
│ ├── seed_type.dart<br>
│ └── seed_description.dart<br>
└── widgets/<br>
└── background_container.dart # Reusable background + theme<br>

---

## 🚀 Features

### 🔐 Secure Admin Login

- **Email & Password** against Node.js API
- **Role‑based** navigation:
  - `master` → Master Admin Dashboard
  - `admin` → Admin Dashboard
- **SecureStorage** for token & user info
- **Password Visibility** toggle & form validation

### 🔁 Forgot Password & OTP

- **Forgot Password** screen: enter email/username → backend sends OTP
- **OTP Verification** screen:
  - 6‑digit inputs with auto‑focus
  - “Resend Code?” button with 1‑minute cooldown & loading spinner
  - Error messages & colored snackbars
- **Reset Password** screen: enter new & confirm password → API call

### 📱 UI / UX

- **Desert‑themed** background images & custom splash
- **Primary Color:** Orange `#F7941D`
- **Font:** Poppins
- **Material 3** styling, elevated buttons, consistent theming

### 📦 Modular Screens

- **Seeds**, **Fertilizer**, **Insecticide**, **Communicate** modules
- Each with Main, Type, Description pages

---

## 📋 Dependencies

dependencies:
flutter:
sdk: flutter
provider: ^6.0.5
flutter_secure_storage: ^8.0.0
http: ^0.13.6

# plus any UI or utility packages you use

🛠️ Setup & Usage<br>

Clone the repo<br>

Run flutter pub get<br>

Configure your backend URL in:<br>

admin_login_screen.dart<br>

forgot_password_screen.dart<br>

otp_screen.dart<br>

reset_password_screen.dart<br>

Launch on device/emulator:<br>

flutter run<br>

git tag v1.0.1
git push origin v1.0.1


👨‍💻 Author
Fares Mohamed
Frontend & Backend Developer (MERN | Flutter | Node.js)
Email: fares.dev.m@gmail.com
GitHub: fares12358
