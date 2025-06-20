# Terminalonphone

🚀 Flutter SSH Client App
A lightweight and responsive mobile app to SSH into your Linux/WSL machines, execute terminal commands, and perform file transfers directly from your phone.
📱 Features
Password and Private Key authentication

Live command execution with terminal-like UI

File upload and download via SFTP

Custom user@host terminal prompt

Background image support

Works on hotspot, LAN, or shared WiFi

⚙️ Prerequisites
Before using the app:

Make sure SSH server is running on your target machine (e.g., WSL, Linux, or remote PC).

For WSL: Install OpenSSH server and run:

sudo service ssh start

Get your WSL/PC IP using:
ip addr | grep inet

🔌 Connecting to Your Machine
Launch the App on your Android device.

Enter the following connection details:

Host: IP address of the remote machine (e.g., 192.168.1.100)

Port: Default is 22 or your custom (e.g., 2222)

Username: Your remote machine username (e.g., root, ubuntu, etc.)

Password: (If using password authentication)

Toggle the switch for "Use Password Authentication".

Tap Connect.

🔥 Firewall Configuration (Important!)
To ensure your device can connect via SSH, you must allow inbound connections on the SSH port (default is 22 or custom like 2222) in your firewall settings.

🪟 Windows (Including WSL)
Open Windows Defender Firewall with Advanced Security.

Go to Inbound Rules → New Rule.

Select Port → Next.

Choose TCP, and specify your SSH port (e.g., 22, 2222).

Allow the connection → Apply to all profiles → Name it SSH Access.

Finish and ensure it's enabled.
