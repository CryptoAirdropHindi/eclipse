#!/bin/bash

# 1️⃣ Password input variable
read -s -p "Enter your Solana wallet password (for keypair generation): " password
echo ""

# 2️⃣ Install Rust
echo "🛠️ Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# 3️⃣ Install Solana CLI
echo "🛠️ Installing Solana CLI..."
curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# 4️⃣ Install expect (if not exists)
if ! command -v expect &>/dev/null; then
  echo "🔧 expect not found, installing..."
  sudo apt update && sudo apt install -y expect
else
  echo "✅ expect already installed"
fi

# 5️⃣ Auto-generate keypair with password
mkdir -p "$HOME/.config/solana"

expect <<EOF
spawn solana-keygen new --force
expect "Enter same passphrase again:"
send "$password\r"
expect "Enter same passphrase again:"
send "$password\r"
expect eof
EOF

# 6️⃣ Output private key
echo ""
echo "✅ Your Solana private key has been generated below. Please copy and import to Backpack wallet:"
echo ""
cat $HOME/.config/solana/id.json
echo ""
echo "⚠️ This is an array-formatted private key. Please store it securely before importing to bp wallet"

# 7️⃣ Confirmation prompt (default y)
read -p "Have you sent 0.005 ETH to this wallet on Eclipse network? [Y/n]: " confirm
confirm=${confirm:-y}

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "🚀 Starting bitz installation and deployment..."

  # Install bitz
  cargo install bitz

  # Set RPC endpoint
  solana config set --url https://mainnetbeta-rpc.eclipse.xyz/

  # Run bitz collect (foreground mode)
  echo ""
  echo "🚀 Running bitz collect..."
  echo "📌 For background execution, press Ctrl+C then use pm2/screen/tmux manually"
  echo ""

  bitz collect




# CryptoAirdropHindi ASCII art
echo " "
echo " "
echo " "
echo " "
echo -e "${CYAN}"
echo -e "    ${RED}██╗  ██╗ █████╗ ███████╗ █████╗ ███╗   ██╗${NC}"
echo -e "    ${GREEN}██║  ██║██╔══██╗██╔════╝██╔══██╗████╗  ██║${NC}"
echo -e "    ${BLUE}███████║███████║███████╗███████║██╔██╗ ██║${NC}"
echo -e "    ${YELLOW}██╔══██║██╔══██║╚════██║██╔══██║██║╚██╗██║${NC}"
echo -e "    ${MAGENTA}██║  ██║██║  ██║███████║██║  ██║██║ ╚████║${NC}"
echo -e "    ${CYAN}╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "${GREEN} 🚀 eclipse One-Click Setup Script 🚀 ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "${CYAN}    🌐  Telegram: @CryptoAirdropHindi${NC}"
echo -e "${CYAN}    📺  YouTube:  @CryptoAirdropHindi6${NC}"
echo -e "${CYAN}    💻  GitHub:   github.com/CryptoAirdropHindi${NC}"
echo -e "${BLUE}=======================================================${NC}"

else
  echo "❌ Operation cancelled, exiting."
fi
