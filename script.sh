#!/bin/bash
set -e

# ================================
#  Helper Functions
# ================================
print_section() {
    echo
    echo "============================================================"
    echo "  $1"
    echo "============================================================"
    echo
}

print_step() {
    echo "👉 $1"
}


install_utils() {
    print_section "🛠 Installing Utilities"

    sudo apt update && sudo apt upgrade -y

    sudo apt install -y curl nano wget git zip \
        neofetch colortest tldr zsh        \
        fzf rng-tools
    
    tldr --update
}


# ================================
#  ✨ Oh My Posh Prompt & Fonts
# ================================
install_oh_my_posh() {
    print_section "✨ Installing Oh My Posh & Nerd Fonts"

    mkdir -p ~/.local/bin/
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
    echo "✅ Oh My Posh installed!"
}

# ================================
#  🔑 GPG Key Setup for Git
# ================================
gen_gpg_key_for_git() {
    print_section "🔑 Generating GPG Key for GitHub commit signing"

    read -p "Enter your GitHub name:  " NAME
    read -p "Enter your GitHub email: " EMAIL

    KEY_CONF=$(mktemp)
    cat > "$KEY_CONF" <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Key-Usage: sign
Expire-Date: 0
Name-Real: $NAME
Name-Email: $EMAIL
%commit
%echo done
EOF

    gpg --batch --generate-key "$KEY_CONF"
    rm -f "$KEY_CONF"

    # Get full fingerprint (GitHub requires full fingerprint, not short key ID)
    FPR=$(gpg --list-secret-keys --with-colons "$EMAIL" | awk -F: '/^fpr:/ {print $10; exit}')

    # Configure git
    git config --global user.name "$NAME"
    git config --global user.email "$EMAIL"
    git config --global user.signingkey "$FPR"
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true

    echo
    echo "✅ Your GPG key details:"
    gpg --list-keys --keyid-format=long "$EMAIL" | awk '/^pub/ || /^uid/ {print}'
    echo

    if command -v clip.exe >/dev/null 2>&1; then
        # `clip.exe` is installed and available in PATH
        gpg --armor --export "$FPR" | clip.exe
        echo "✅ GPG public key copied to Windows clipboard. Paste it into GitHub!"
    else
        echo "⚠️ Could not find clip.exe — here’s your GPG public key:"
        gpg --armor --export "$FPR"
    fi
    echo "🔑 Add your GPG key here: https://github.com/settings/gpg/new"
    echo
    read -p "⏸️ Press Enter after you’ve added the GPG key to GitHub to continue..."
}



export_github_ssh_pub_key() {
    if command -v clip.exe >/dev/null 2>&1; then
        cat ~/.ssh/github.pub | clip.exe
        echo "✅ SSH public key copied to clipboard. Add it to GitHub!"
    else
        echo "⚠️ Could not find clip.exe — here’s your SSH public key:"
        cat ~/.ssh/github.pub
        echo
    fi


    echo "🔑 Add your SSH key here: https://github.com/settings/ssh/new"
    echo
    read -p "⏸️ Press Enter after you’ve added the SSH key to GitHub to continue..."
}

setup_github_ssh() {
    print_section "🔐 Setting up GitHub SSH Key"

    rm -f ~/.ssh/github ~/.ssh/github.pub
    ssh-keygen -t ed25519 -f ~/.ssh/github -N ""

    touch ~/.ssh/config
    curl -s https://raw.githubusercontent.com/TrifanBogdan24/WSL-Setup/refs/heads/main/.dotfiles/.ssh-config > ~/.ssh/config
    echo
    
    export_github_ssh_pub_key

    EXIT_CODE_SSH_FAILED=255
    EXIT_CODE_SSH_SUCCESSFULL=1

    print_section "👨‍💻 Testing your SSH connection"
    local exit_code
    exit_code=0
    ssh -T git@github.com || exit_code=$?

    while [[ $exit_code -ne $EXIT_CODE_SSH_SUCCESSFULL ]]
    do
        echo "⚠️⚠️⚠️ You forgot to add SSH pub key on GitHub! ⚠️⚠️⚠️"
        export_github_ssh_pub_key

        print_section "👨‍💻 Testing your SSH connection (again)"
        exit_code=0
        ssh -T git@github.com || exit_code=$?
    done

    unset exit_code
}

# ================================
#  ✨ Oh My Posh Prompt
# ================================
install_oh_my_posh() {
    print_section "✨ Installing Oh My Posh (Prompt)"

    mkdir -p ~/.local/bin/
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
    export PATH=$PATH:$HOME/.local/bin
    echo "✅ Oh My Posh installed!"
}



config_bash() {
    curl -s https://raw.githubusercontent.com/TrifanBogdan24/WSL-Setup/refs/heads/main/.dotfiles/.bashrc > ~/.bashrc
}

config_zsh() {
    curl -s https://raw.githubusercontent.com/TrifanBogdan24/WSL-Setup/refs/heads/main/.dotfiles/.zshrc > ~/.zshrc
}



# ================================
#  🔄 Change default shell to Zsh
# ================================
change_shell_to_zsh() {
    print_section "🔄 Changing default shell to Zsh"
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        echo "✅ Default shell changed to Zsh. Log out and log back in to apply."
    else
        echo "ℹ️ Zsh is already the default shell."
    fi
}


# ================================
#  ▶️ Run Everything
# ================================
main() {
    install_utils

    install_oh_my_posh
    config_bash
    config_zsh
    print_section "✨ Shell config complete!"
    source ~/.bashrc

    setup_github_ssh
    gen_gpg_key_for_git

    print_section "✨ Setup Complete!"
    change_shell_to_zsh
}

main
