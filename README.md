# 📱🕹️ Mobile Steering Wheel Simulator

Transform your smartphone into a **wireless racing wheel** to control PC games using real-time motion data.
This project allows you to tilt and rotate your phone like a physical steering wheel and control racing games on your Windows machine **no physical joystick required**.

---

## 🚀 Overview

This project simulates a virtual racing wheel by combining:

* 📲 **Mobile App** (Flutter): Uses the phone's gyroscope to capture steering angle.
* 🌐 **UDP Communication**: Sends motion data over Wi-Fi to the PC in real time.
* 🧠 **Python UDP Server + pyvjoy**: Receives data from the mobile app and maps the received angle data and buttons to a virtual joystick using [vJoy](https://github.com/jshafer817/vJoy).

The result: your favorite PC racing games can be played with nothing more than your phone and Wi-Fi.

<video width="480" height="848" controls>
  <source src="https://github.com/user-attachments/assets/37bf3a63-b9f7-4d57-8e6d-92e49ffe99e9" type="video/mp4">
</video>

---

## 📦 Features

* 📡 Real-time steering input over local Wi-Fi
* 🎮 Emulates a **virtual racing wheel** using `vJoy`

---

## 🧰 Technologies Used

| Component               | Tech Stack                                 |
| ----------------------- | ------------------------------------------ |
| Mobile App              | Flutter + Platform Chanels + UDP           |
| Server                  | Python (receives sensor data)             |
| Controller Interface    | Python + `pyvjoy` (Windows only)           |
| Virtual Joystick Driver | [vJoy](https://github.com/jshafer817/vJoy) |

---

## 🛠️ How It Works

1. Phone captures gyroscope rotation around the Z-axis.
2. Data is streamed via UDP to the PC.
3. Python server interprets and normalizes the angle.
4. The angle is sent to `vJoy`, which emulates a real racing wheel.
5. Any game that supports a joystick will receive steering input from your phone.

---

## ⚙️ Setup Instructions

### ✅ Prerequisites

* Windows PC
* Python 3
* [vJoy installed](https://github.com/jshafer817/vJoy/releases)

### 📲 Mobile App

1. Clone and run the Flutter app on your phone.
2. Ensure the phone is connected to the same Wi-Fi network as the PC.

### 🖥️ PC Setup

1. Install `vJoy` and configure at least 1 axis (X).
2. Run the Python UDP server + vJoy bridge (`python server.py`).
