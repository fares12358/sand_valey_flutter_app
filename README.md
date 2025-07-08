# 🏜️ Sand Valley App

**Sand Valley** is a Flutter-based mobile application built to manage and display agricultural resources—fertilizers, insecticides, seeds—and provide direct communication options. It features:

- 🔐 Secure, role-based admin login system (`admin` & `master`)
- 🔄 OTP-based password reset
- 🌵 Beautiful desert-themed UI
- 🧩 Modular routing structure for easy maintenance

---

## 📦 Version `v1.0.3` Updates

- ✅ **Master Admin Dashboard UI improvements**
  - Added **4 new navigation buttons**:
    - `Users`, `Admins`, `Logs`, `Settings`
    - Each button routes to a matching named route (e.g., `/users`)
- ✅ Buttons are styled to match the app’s orange theme
- ✅ Enhanced code structure using keys & callback to refresh users list
- ✅ Better separation of widget logic for cleaner state management

---

## 📂 Project Structure

lib/<br>
├── main.dart # App entry point with Provider & SecureStorage<br>
├── routes/<br>
│ └── app_routes.dart # All named route paths<br>
├── screens/<br>
│ ├── splash/<br>
│ │ └── splash_screen.dart<br>
│ ├── home/<br>
│ │ └── home_screen.dart<br>
│ ├── admin/<br>
│ │ ├── admin_login_screen.dart<br>
│ │ ├── admin_page.dart<br>
│ │ ├── master_admin_page.dart # 🆕 Updated with 4 routing buttons<br>
│ │ ├── forgot_password_screen.dart<br>
│ │ ├── otp_screen.dart<br>
│ │ └── reset_password_screen.dart<br>
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
├── components/<br>
│ ├── account_settings_section.dart<br>
│ ├── add_account_section.dart<br>
│ └── view_users_section.dart<br>
└── widgets/<br>
└── background_container.dart # Reusable background container + theme<br>


---

## 🚀 Features

### 🔐 Secure Admin Login

- Email/password authentication via secure Node.js backend
- `admin` → Admin Dashboard
- `master` → Master Admin Dashboard (with advanced controls)
- SecureStorage for tokens and role
- Password visibility toggle and form validation

### 🔁 OTP-Based Password Reset

- Enter email/username → API sends OTP
- OTP screen with:
  - 6-digit smart input
  - Resend button with loading and 60s cooldown
- Reset password securely with validation

### 📱 UI & UX Design

- Orange theme: `#F7941D`
- Poppins font
- Material 3 widgets and styling
- Responsive and clean layout
- Reusable background containers

### 📦 Modular Screens

- Communicate: phone and text support
- Fertilizer, Insecticide, Seeds: type + description
- Dashboard components separated for reusability

---

## 🔧 Dependencies

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  flutter_secure_storage: ^8.0.0
  http: ^0.13.6


## 🛠️ Setup & Usage

# Clone the repository
git clone https://github.com/your-username/sand-valley.git
cd sand-valley

# Get packages
flutter pub get

# Update your backend URLs in:
# - admin_login_screen.dart
# - forgot_password_screen.dart
# - otp_screen.dart
# - reset_password_screen.dart

# Run on device or emulator
flutter run

## 🚀 Git Versioning

# Commit your changes
git add .
git commit -m "Update Master Admin Page with 4 new routing buttons"

# Push to origin main branch
git push origin main

# Tag the new version
git tag v1.0.3
git push origin v1.0.3

👨‍💻 Author
Fares Mohamed
Frontend & Backend Developer (MERN | Flutter | Node.js)
📧 fares.dev.m@gmail.com
🔗 GitHub: fares12358