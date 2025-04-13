#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Display header
display_header() {
    clear
    echo -e "${CYAN}"
    echo -e "    ${RED}██╗  ██╗ █████╗ ███████╗ █████╗ ███╗   ██╗${NC}"
    echo -e "    ${GREEN}██║  ██║██╔══██╗██╔════╝██╔══██╗████╗  ██║${NC}"
    echo -e "    ${BLUE}███████║███████║███████╗███████║██╔██╗ ██║${NC}"
    echo -e "    ${YELLOW}██╔══██║██╔══██║╚════██║██╔══██║██║╚██╗██║${NC}"
    echo -e "    ${MAGENTA}██║  ██║██║  ██║███████║██║  ██║██║ ╚████║${NC}"
    echo -e "    ${CYAN}╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${GREEN}       ✨ eclipse Miner Setup ✨${NC}"
    echo -e "${BLUE}=======================================================${NC}"
    echo -e "${CYAN} Telegram Channel: CryptoAirdropHindi @CryptoAirdropHindi ${NC}"  
    echo -e "${CYAN} Follow us on social media for updates and more ${NC}"
    echo -e " 📱 Telegram: https://t.me/CryptoAirdropHindi6 "
    echo -e " 🎥 YouTube: https://www.youtube.com/@CryptoAirdropHindi6 "
    echo -e " 💻 GitHub Repo: https://github.com/CryptoAirdropHindi/ "
    echo
}

# Function to install dependencies
install_dependencies() {
    echo -e "${GREEN}Starting dependency installation...${NC}"
    
    # System updates
    echo -e "${YELLOW}Updating system packages...${NC}"
    sudo apt-get update && sudo apt-get upgrade -y
    
    # Basic tools
    echo -e "${YELLOW}Installing basic tools...${NC}"
    sudo apt install screen curl nano git build-essential -y
    
    # Rust installation
    echo -e "${YELLOW}Installing Rust...${NC}"
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
    else
        echo -e "${CYAN}Rust is already installed.${NC}"
    fi
    
    # Solana CLI
    echo -e "${YELLOW}Installing Solana CLI...${NC}"
    if ! command -v solana &> /dev/null; then
        sh -c "$(curl -sSfL https://solana-install.solana.workers.dev)"
        source ~/.bashrc
    else
        echo -e "${CYAN}Solana CLI is already installed.${NC}"
    fi
    
    echo -e "${GREEN}Dependency installation complete!${NC}"
}

# Function to setup wallet
setup_wallet() {
    echo -e "${CYAN}Setting up Solana configuration...${NC}"
    solana config set --url https://eclipse.helius-rpc.com/
    
    echo -e "${CYAN}Creating new wallet...${NC}"
    if [ -f ~/.config/solana/id.json ]; then
        echo -e "${YELLOW}Wallet already exists at ~/.config/solana/id.json${NC}"
        echo -e "Public Key: ${GREEN}$(solana address)${NC}"
        read -p "Do you want to create a new wallet? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    echo -e "${YELLOW}Please save your seed phrase shown below securely!${NC}"
    solana-keygen new --no-bip39-passphrase
    
    echo -e "${GREEN}Wallet created successfully!${NC}"
    echo -e "Public Key: ${GREEN}$(solana address)${NC}"
    echo -e "Keypair path: ${YELLOW}$(solana config get | grep "Keypair Path" | cut -d: -f2)${NC}"
    
    # Export private key
    echo -e "\n${CYAN}To export your private key, run:${NC}"
    echo -e "${YELLOW}cat ~/.config/solana/id.json${NC}"
}

# Function to setup miner
setup_miner() {
    echo -e "${CYAN}Checking for existing miner...${NC}"
    if screen -list | grep -q "bitz"; then
        echo -e "${YELLOW}Miner is already running in a screen session.${NC}"
        echo -e "Attach to it with: ${GREEN}screen -r bitz${NC}"
        read -p "Do you want to restart the miner? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
        screen -XS bitz quit
    fi
    
    echo -e "${YELLOW}Installing Bitz miner...${NC}"
    if ! command -v bitz &> /dev/null; then
        cargo install bitz
    else
        echo -e "${CYAN}Bitz is already installed.${NC}"
    fi
    
    echo -e "${GREEN}Starting miner in screen session...${NC}"
    screen -S bitz -dm bash -c "bitz collect; exec bash"
    
    echo -e "\n${GREEN}Miner setup complete!${NC}"
    echo -e "You can attach to the miner screen with: ${YELLOW}screen -r bitz${NC}"
    echo -e "To detach from screen session: ${YELLOW}Ctrl+A then D${NC}"
}

# Function to remove components
remove_components() {
    echo -e "${RED}WARNING: This will remove installed components${NC}"
    read -p "Are you sure you want to continue? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Removing components...${NC}"
        
        # Remove Rust
        if command -v rustup &> /dev/null; then
            rustup self uninstall -y
        fi
        
        # Remove Solana
        rm -rf ~/.local/share/solana
        
        # Remove Bitz
        if command -v bitz &> /dev/null; then
            cargo uninstall bitz
        fi
        
        # Remove screen sessions
        screen -XS bitz quit
        
        echo -e "${GREEN}Removal complete!${NC}"
    else
        echo -e "${GREEN}Removal canceled.${NC}"
    fi
}

# Main menu function
main_menu() {
    while true; do
        display_header
        echo -e "${BLUE}To exit the script at any time, press Ctrl+C${NC}"
        echo -e "${YELLOW}Main Menu:${NC}"
        echo -e "1) ${GREEN}Install Dependencies${NC}"
        echo -e "2) ${CYAN}Setup Wallet${NC}"
        echo -e "3) ${MAGENTA}Setup Miner${NC}"
        echo -e "4) ${RED}Remove Components${NC}"
        echo -e "5) ${BLUE}Exit script${NC}"
        
        read -p "$(echo -e "${BLUE}Enter your choice [1-5]: ${NC}")" choice

        case $choice in
            1) 
                install_dependencies
                ;;
            2)
                setup_wallet
                ;;
            3)
                setup_miner
                ;;
            4)
                remove_components
                ;;
            5)
                echo -e "${GREEN}Exiting script... Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please choose between 1-5.${NC}"
                sleep 1
                ;;
        esac

        echo -e "${YELLOW}Press any key to return to main menu...${NC}"
        read -n 1 -s
    done
}

# Start the main menu
main_menu
