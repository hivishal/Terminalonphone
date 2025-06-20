# SSH Terminal Flutter App

A fully functional **SSH Terminal App** built using **Flutter**, allowing users to connect to **Linux/WSL/PC servers via SSH**, execute terminal commands, and transfer files using SFTP from an Android device.

---

## 🚀 Features

- Connect to any SSH server (Linux, WSL, Raspberry Pi, remote PC)
- Real terminal-like interface with styled output
- Support for password and key-based authentication
- Real-time session display with auto-scrolling
- Command input with full UTF-8 support
- Upload local files to the SSH server via SFTP
- Download remote files to local device via SFTP
- Minimal and responsive UI using Flutter Material Widgets

---

## 📱 App Setup (Android)

### ✅ Prerequisites

- Flutter SDK 3.10+
- Dart SDK
- Android Studio with:
  - Android SDK (API 24+)
  - NDK Version `27.0.12077973` (required for `path_provider`)
- Physical device or emulator (Android x64)

---

## 🧩 Dependencies

Install dependencies by running:

```bash
flutter pub add dartssh2
flutter pub add file_selector
flutter pub add path_provider

💻 SSH Server Setup on PC
This app requires the remote machine (your PC/WSL/Linux server) to have an SSH server running and reachable on the local network.

🔹 On Windows (PowerShell)
# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start SSH service
Start-Service sshd

# Enable on boot
Set-Service -Name sshd -StartupType 'Automatic'

# Get your PC's IP address
ipconfig
Make sure port 22 is not blocked by your firewall.

On WSL/Linux (Ubuntu/Debian)
sudo apt update
sudo apt install openssh-server
sudo service ssh start
ip a  # Note the IP address (usually under eth0)
sudo ufw allow ssh

🔐 Permissions Required (on Android)
INTERNET – for SSH connections

READ_EXTERNAL_STORAGE – for file uploads

WRITE_EXTERNAL_STORAGE – for file downloads

Make sure to request these permissions properly if using Android SDK ≥ 30.

📂 Directory Structure (Key Files)
lib/
├── main.dart              # Entry point
├── terminal_widgets.dart  # UI Builder
├── ssh_manager.dart       # SSH/SFTP logic


Usage Instructions
Launch the app

Enter:

Host IP address (from PC or WSL)

Port (usually 22)

Username (root, or your PC username)

Password (or use key-based auth)

Tap Connect

Type your commands and press send

Use the upload/download icons to transfer files

⚠️ Notes & Warnings
Ensure PC and phone are on the same network

On some Android devices, access to /storage/emulated/0/Download may require additional permission dialogs

Key-based authentication expects id_rsa to be located in the app documents directory (e.g., created manually or downloaded beforehand)

try out the app_release.apk
