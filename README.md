# 🏜️ Sand Valley App

Sand Valley is a Flutter-based mobile application designed to manage and display agricultural resources like fertilizers, insecticides, seeds, and communication options. It includes a secure admin login system with role-based access (admin & master), beautiful UI with a desert theme, and modular routing.

---

## 📂 Project Structure

lib/<br>
│
├── main.dart                   # Entry point<br>
│<br>
├── routes/<br>
│   └── app_routes.dart         # Application routes<br>
│<br>
├── screens/<br>
│   ├── splash/                 # Splash screen<br>
│   │   └── splash_screen.dart<br>
│   │<br>
│   ├── home/                   # Home screen<br>
│   │   └── home_screen.dart<br>
│   │<br>
│   ├── admin/<br>
│   │   ├── admin_login_screen.dart<br>
│   │   ├── admin_page.dart<br>
│   │   ├── master_admin_page.dart<br>
│   │<br>
│   │   ├── Communicate/<br>
│   │   │   ├── Communicate-main.dart<br>
│   │   │   ├── Communicate-eng.dart<br>
│   │   │   └── Communicate-call.dart<br>
│   │<br>
│   │   ├── Fertilizer/<br>
│   │   │   ├── Fertilizer-main.dart<br>
│   │   │   ├── Fertilizer-type-one.dart<br>
│   │   │   ├── Fertilizer-type-two.dart<br>
│   │   │   └── Fertilizer.description.dart<br>
│   │<br>
│   │   ├── Insecticide/<br>
│   │   │   ├── Insecticide-main.dart<br>
│   │   │   ├── Insecticide-type.dart<br>
│   │   │   └── Insecticide-description.dart<br>
│   │<br>
│   │   ├── seeds/<br>
│   │       ├── seed-main.dart<br>
│   │       ├── seed-type.dart<br>
│   │       └── seed-description.dart<br>
│<br>
└── widgets/                    # Reusable UI components<br>


---

## 🚀 Features

### ✅ Admin Login
- Email/password login using a Node.js backend.
- Roles:
  - `master` → MasterAdminPage
  - `admin` → AdminPage
- Snackbar alerts for feedback.
- Password visibility toggle.

### ✅ Modular Screens
- **Seeds:** Main, Type, and Description screens.
- **Fertilizer:** Type One, Type Two, Description, Main screen.
- **Insecticide:** Type, Description, Main screen.
- **Communicate:** Call, English Instructions, Main screen.

### ✅ Theming
- **Primary Color:** Orange `#F7941D`
- **Font:** Poppins
- **Splash-free** elevated buttons.
- Background image on login screen.

---

## 🔗 Routing

All routes are defined in `lib/routes/app_routes.dart`.

--- 

## Dependencies

dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.6


##👨‍💻 Author

Fares Mohamed
Frontend + Backend Developer
MERN | Flutter | Node.js | MongoDB | Express
Email: fares.dev.m@gmail.com
GitHub: https://github.com/fares12358


