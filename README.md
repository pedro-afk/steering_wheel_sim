# 📱🕹️ Mobile Steering Wheel Simulator

Transform your smartphone into a **wireless racing wheel** to control PC games using real-time motion data.
This project allows you to tilt and rotate your phone like a physical steering wheel and control racing games on your Windows machine — **no physical joystick required**.

---

## 🚀 Overview

This project simulates a virtual racing wheel by combining:

* 📲 **Mobile App** (Flutter): Uses the phone's gyroscope to capture steering angle.
* 🌐 **UDP Communication**: Sends motion data over Wi-Fi to the PC in real time.
* 🖥️ **Node.js UDP Server**: Receives data from the mobile app.
* 🧠 **Python + pyvjoy**: Maps the received angle data to a virtual joystick using [vJoy](https://github.com/jshafer817/vJoy).

The result: your favorite PC racing games can be played with nothing more than your phone and Wi-Fi.

---

## 📦 Features

* 📡 Real-time steering input over local Wi-Fi
* 🎮 Emulates a **virtual racing wheel** using `vJoy`
* 🔧 Adjustable steering sensitivity
* 💡 Modular architecture (easy to expand with brake/throttle/buttons)
* 💻 Cross-platform (mobile app works on Android/iOS)

---

## 🧰 Technologies Used

| Component               | Tech Stack                                 |
| ----------------------- | ------------------------------------------ |
| Mobile App              | Flutter + Platform Chanels + UDP           |
| Server                  | Node.js (receives sensor data)             |
| Controller Interface    | Python + `pyvjoy` (Windows only)           |
| Virtual Joystick Driver | [vJoy](https://github.com/jshafer817/vJoy) |

---

## 🛠️ How It Works

1. Phone captures gyroscope rotation around the Z-axis.
2. Data is streamed via UDP to the PC.
3. Node.js forwards the data to a local Python service.
4. Python interprets and normalizes the angle.
5. The angle is sent to `vJoy`, which emulates a real racing wheel.
6. Any game that supports a joystick will receive steering input from your phone.

---

## ⚙️ Setup Instructions

### ✅ Prerequisites

* Windows PC
* Python 3
* Node.js
* [vJoy installed](https://github.com/jshafer817/vJoy/releases)

### 📲 Mobile App

1. Clone and run the Flutter app on your phone.
2. Ensure the phone is connected to the same Wi-Fi network as the PC.

### 🖥️ PC Setup

1. Install `vJoy` and configure at least 1 axis (X).
2. Run the Node.js UDP server (`npm run dev`).
3. Run the Python UDP-to-vJoy bridge (`python vjoy_controller.py`).

---

## 🛣️ Roadmap

* [ ] Add throttle and brake via tilt or on-screen controls
* [ ] Add haptic feedback on oversteering
* [ ] Add UI calibration panel for sensitivity and deadzone
* [ ] Add multi-platform gamepad emulation (ViGEm support)