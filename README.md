<h1 align="center">🎮 Kinetix (Human Joystick)</h1>

<p align="center">
  <strong>An AI-powered fitness game where YOUR body is the controller!</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Machine%20Learning-Google%20ML%20Kit-FF6F00?style=for-the-badge" />
</p>

<p align="center">
  <!-- TODO: Replace 'demo.gif' with the actual name of your GIF file -->
  <img src="demo.gif" alt="Kinetix Gameplay" width="300"/>
</p>

---

## 🚀 About The Project

**Kinetix** (formerly Human Joystick) is a highly interactive, 2D endless-runner game built using Flutter. Instead of tapping the screen to play, the app uses your phone's front camera and **Google ML Kit Pose Detection** to track your physical body movements in real-time. 

To make your character jump over obstacles, you have to physically **JUMP**. To dodge high obstacles, you have to physically **SQUAT**. It's a fun, engaging way to bridge the gap between gaming and physical fitness!

### ✨ Key Features
* 🏃 **Real-time Body Tracking:** Uses advanced machine learning to track your nose and shoulder coordinates with zero lag.
* 🚫 **No Screen-Tapping:** 100% controlled by physical human movement.
* 🎨 **Premium Glassmorphism UI:** Features beautiful frosted-glass overlays and smooth Flutter animations.
* 🔋 **Highly Optimized:** Runs perfectly on budget Android devices with low RAM by utilizing native camera processing instead of heavy game engines.

---

## 🛠️ Built With

* **[Flutter](https://flutter.dev/)** - The UI framework.
* **[Google ML Kit](https://developers.google.com/ml-kit)** - Used specifically for the on-device Pose Detection Vision API.
* **[Camera Package](https://pub.dev/packages/camera)** - For raw NV21 frame extraction.

---

## 🕹️ How To Play

1. Prop your Android phone vertically against a wall or object.
2. Step back so the front camera can see your upper body.
3. **Dodge the Pink Obstacles!**
   * **JUMP** in real life to make your avatar jump over low obstacles.
   * **SQUAT** down in real life to make your avatar duck under high obstacles.
4. Survive as long as you can to get the highest score!

---

## 💻 Getting Started (Local Development)

Because this app relies heavily on the physical camera and hardware ML processing, **it cannot be tested on an emulator.**

### Prerequisites
* Flutter SDK installed on your machine.
* A physical Android device with **USB Debugging** and **Install via USB** enabled in Developer Options.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/kinetix.git
   ```
2. Navigate to the project directory:
   ```bash
   cd kinetix
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Connect your Android device via USB and run:
   ```bash
   flutter run
   ```

---

<p align="center">
  <i>If you liked this project, don't forget to give it a ⭐ on GitHub!</i>
</p>
