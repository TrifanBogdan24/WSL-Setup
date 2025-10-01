# 🚀 WSL with Ubuntu Developer Setup Script


This script automates the setup of a fresh **Ubuntu** installation
inside **WSL** (Windows Subsystem for Linux),
giving you a ready-to-go development environment that’s **minimal**, **functional** and **beautiful**.

It handles everything from enabling WSL and installing Ubuntu
to ricing your terminal with themes and essential developer tools.


## 🛠 Features

### 📥 1. Install Basic Tools
- Updates system packages (`apt update` & `upgrade`)
- Installs essential tools: `wget`, `curl`, `git`, `zsh`

### 🔑 2. Git & GitHub Setup 
- Generate SSH key for GitHub and copy to clipboard
- Generate GPG key for signing Git commits & tags
- Sets global Git username, email, and signing key

### 🎨 3. Theming & Fonts
- **Oh My Posh prompt**

## 💻 WSL & Ubuntu Setup

Follow these steps to get WSL and Ubuntu ready before running the script.


Open **PowerShell** and **Run as Administrator** the following commands:

### 1. Enable WSL and Virtual Machine Platform
```sh
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

### 2. Set WSL 2 as the default version
```sh
wsl --set-default-version 2
```

### 3. Install Ubuntu (latest LTS by default)
```sh
wsl --install -d Ubuntu
```

### 4. Launch Ubuntu in WSL
```
wsl
```
or
```
wsl -d Ubuntu
```

---

### ▶️ 5. Run the Automated Setup Script

Once Ubuntu is ready, execute the script to install tools, configure Git, and rice your environment:

```sh
curl -s -o script.sh https://raw.githubusercontent.com/TrifanBogdan24/WSL-Setup/refs/heads/main/script.sh && \
    chmod +x script.sh && \
    ./script.sh
```

> ⚠️ Make sure `curl` is arleady installed in Ubuntu WSL by running: `which curl || sudo apt install -y curl`


Now you’ll have a fully configured, stylish,
and productive Ubuntu environment inside WSL—ready for development!
