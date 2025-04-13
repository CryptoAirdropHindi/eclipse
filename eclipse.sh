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
    echo -e "${YELLOW}Updating system packages...${NC}"
    sudo apt-get update && sudo apt-get upgrade -y
    
    echo -e "${YELLOW}Installing basic tools...${NC}"
    sudo apt install screen curl nano git build-essential -y
    
    echo -e "${YELLOW}Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    
    echo -e "${YELLOW}Installing Solana CLI...${NC}"
    sh -c "$(curl -sSfL https://solana-install.solana.workers.dev)"
    source ~/.bashrc
    
    echo -e "${GREEN}Dependency installation complete!${NC}"
}

# Function to setup wallet and miner
setup_wallet_miner() {
    echo -e "${CYAN}Setting up Solana configuration...${NC}"
    solana config set --url https://eclipse.helius-rpc.com/
    
    echo -e "${CYAN}Creating new wallet...${NC}"
    echo -e "${YELLOW}Please save your seed phrase shown below securely!${NC}"
    solana-keygen new --no-bip39-passphrase
    
    echo -e "${CYAN}Wallet information:${NC}"
    echo -e "Public Key: ${GREEN}$(solana address)${NC}"
    echo -e "Keypair path: ${YELLOW}$(solana config get | grep "Keypair Path" | cut -d: -f2)${NC}"
    
    echo -e "${CYAN}Installing Bitz miner...${NC}"
    cargo install bitz
    
    echo -e "${GREEN}Starting miner in screen session...${NC}"
    screen -S bitz -dm bash -c "bitz collect; exec bash"
    
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "You can attach to the miner screen with: ${YELLOW}screen -r bitz${NC}"
}

# Function to remove components
remove_components() {
    echo -e "${RED}WARNING: This will remove installed components${NC}"
    read -p "Are you sure you want to continue? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Removing components...${NC}"
        
        # Remove Rust
        rustup self uninstall -y
        
        # Remove Solana
        rm -rf ~/.local/share/solana
        
        # Remove Bitz
        cargo uninstall bitz
        
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
        echo -e "2) ${CYAN}Setup Wallet & Miner${NC}"
        echo -e "3) ${RED}Remove Components${NC}"
        echo -e "4) ${MAGENTA}Exit script${NC}"
        
        read -p "$(echo -e "${BLUE}Enter your choice [1-4]: ${NC}")" choice

        case $choice in
            1) 
                install_dependencies
                ;;
            2)
                setup_wallet_miner
                ;;
            3)
                remove_components
                ;;
            4)
                echo -e "${GREEN}Exiting script... Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please choose between 1-4.${NC}"
                sleep 1
                ;;
        esac

        echo -e "${YELLOW}Press any key to return to main menu...${NC}"
        read -n 1 -s
    done
}

# Start the main menu
main_menu
