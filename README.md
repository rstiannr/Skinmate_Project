# 🌸 SkinMate: Your Personalized Skincare Journey

---

**SkinMate** is a beautifully designed Flutter application dedicated to empowering users to take control of their skincare routines, connect with a vibrant community, and manage their personal wellness journey. More than just a tracker, SkinMate fosters a supportive environment where users can share experiences, discover new insights, and achieve their best skin.

---

## ✨ Features

SkinMate offers a comprehensive suite of features crafted to provide an intuitive and engaging user experience:

* **Splash Screen**: A welcoming initial display showcasing the app's identity before seamlessly transitioning to the login experience. ([\`lib/splash_screen.dart\`](lib/splash_screen.dart))
* **Secure Authentication**: Robust user registration, login, and account management functionalities ensure a secure and personalized experience. ([\`lib/auth/login_screen.dart\`](lib/auth/login_screen.dart), [\`lib/auth/register_screen.dart\`](lib/auth/register_screen.dart))
* **Quick Profile Setup**: A guided onboarding process where users answer a few simple questions to tailor their SkinMate experience from the start. ([\`lib/quick/quick_question_page.dart\`](lib/quick/quick_question_page.dart))
* **Personalized Home Screen**: Your daily hub featuring customized routine reminders, helpful skincare tips, and engaging fun facts. ([\`lib/home/home_screen.dart\`](lib/home/home_screen.dart))
* **Intuitive Routine Tracker**: Effortlessly log and manage your morning and evening skincare routines, helping you stay consistent and track progress. ([\`lib/tracker/tracker_screen.dart\`](lib/tracker/tracker\_screen.dart), [\`lib/tracker/edit_tracker_screen.dart\`](lib/tracker/edit_tracker_screen.dart))
* **Engaging Community Hub**: Connect with fellow skincare enthusiasts! Share updates, post questions, and interact with others' content through likes and comments. ([\`lib/comunitas/comunitas_screen.dart\`](lib/comunitas/comunitas_screen.dart), [\`lib/comunitas/comment_screen.dart\`](lib/comunitas/comment_screen.dart))
* **Comprehensive Profile Management**: Easily view and update your personal information and preferences within the app. ([\`lib/Profile/profile_screen.dart\`](lib/Profile/profile_screen.dart))
* **User Control Panel (Admin View)**: A dedicated interface for managing users, demonstrating administrative functionalities. ([\`lib/auth/users_screen.dart\`](lib/auth/users_screen.dart))

---

## 📁 Project Structure

```
├── android/                # Android native project files
├── assets/                 # App images and other assets
├── ios/                    # iOS native project files
├── lib/                    # Main Dart code for the Flutter app
│   ├── auth/               # Authentication screens and logic
│   ├── comunitas/          # Community features (posts, comments)
│   ├── database/           # Database helpers
│   ├── home/               # Home screen
│   ├── Profile/            # User profile screens
│   ├── quick/              # Quick onboarding/questionnaire
│   ├── tracker/            # Tracker and product screens
│   ├── utils/              # Utilities, themes, and routes
│   ├── widgets/            # Custom reusable widgets
│   ├── main.dart           # App entry point
│   └── splash_screen.dart  # Splash screen widget
├── linux/                  # Linux native project files
├── macos/                  # macOS native project files
├── web/                    # Web support files
├── windows/                # Windows native project files
├── pubspec.yaml            # Flutter project configuration
├── README.md               # Project documentation
└── ...                     # Other configuration and

```
---

## 🚀 Navigation Flow

Navigate through SkinMate with this intuitive flow:

1.  **SplashScreen** → Redirects to the `/login` screen.
2.  **Login/Register**
    * Successful **Registration** guides users to `/quick_question` for personalized onboarding.
    * Successful **Login** takes users directly to the `/comunitas` (community) feed.
3.  **Quick Question**
    * Upon completing the onboarding questions, users are seamlessly directed to the `/home` screen.
4.  **Home**
    * Access the **Tracker**, **Profile**, and **Community** sections conveniently via the bottom navigation bar.
5.  **Tracker**
    * Effortlessly track and modify your daily routines.
6.  **Comunitas**
    * Engage with the community: create new posts, like, and comment on existing content.
7.  **Profile**
    * View and update your personal user profile details.

---

## 🗄️ Database

SkinMate leverages **SQLite** for efficient local data storage:

* Utilizes a dedicated database helper class ([\`lib/database/database_helper.dart\`](lib/database/database_helper.dart)) for seamless database interactions.
* Stores essential application data, including user profiles, skincare routines, community posts, comments, and likes.

---

## 💡 Proposal and Presentation

Explore the conceptual foundation and detailed planning behind SkinMate:

* **Project Proposal & Pitch Deck**: Dive deeper into the project's vision, objectives, and proposed solutions.
    * [View Proposal and PPT](https://github.com/rstiannr/Skinmate_Project/tree/main/Proposal)

---

## 🎨 UI/UX Design

Discover the visual aesthetics and user experience design of SkinMate:

* **Figma UI Design**: Explore the complete user interface and interactive prototypes.
    * [Explore UI Design on Figma](https://github.com/rstiannr/Skinmate_Project/tree/main/Prototype_UI_Figma)

---

## 🏁 Getting Started

To run SkinMate locally, follow these simple steps:

1.  **Install Dependencies**:

    ```bash
    flutter pub get
    ```

2.  **Run the App**:

    ```bash
    flutter run
    ```

    Alternatively, use the "Run" button in your preferred IDE (e.g., VS Code, Android Studio).
3.  **Assets**:
    Ensure all images located in the \`assets/images/\` directory are present and correctly declared in your \`pubspec.yaml\` file.

---

## 🛠️ Customization

SkinMate is designed with flexibility in mind:

* **App Theme**: Easily modify the application's visual theme and color palette in ([\`lib/utils/app_theme.dart\`](lib/utils/app_theme.dart)).
* **Route Management**: Add or adjust navigation routes within the app by editing ([\`lib/utils/app_routes.dart\`](lib/utils/app_routes.dart)).
* **Onboarding Questions**: Personalize the quick setup process by modifying the questions in ([\`lib/quick/quick_question_page.dart\`](lib/quick/quick_question_page.dart)).

---

## 💼 My Digital Portfolio

For more of my work and projects, visit my digital portfolio:

* [RSTIANNR's Digital Portfolio](https://spectrum-resolution-3e6.notion.site/Digital-Portfolio-21fd805f6a4a806697b8fa3f1b17b39b)

---
