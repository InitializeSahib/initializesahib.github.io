#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)
echo "${bold}Sahib's Arch Installer Script Stage 3${normal}"
echo "'if you don't have to do it again, do it once'"
echo "= = = = = = = = = ="
echo "${bold}Requirements for stage 3:${normal}"
echo "Proper execution of stages 1 and 2"
echo "An internet connection"
echo "Pre-setup partitions (minimum: root and swap)"
echo "An EFI System Partition formatted as FAT32"
echo "Being in the United States of America"
echo "Using the United States locale"
echo "A NVIDIA card / Intel Graphics (AMD support planned)"
echo "${bold}NOTE${normal}: This installer currently does not support more than 3 partitions (root, home, and swap)."
echo
echo "If you do not meet the installation requirements above, please hit CTRL+C."
echo "Otherwise, hit ENTER to continue."
read -r >> /dev/null
echo "${bold}Consent accepted.${normal}"
echo

echo "${bold}[Stage 3, Part 1]${normal} Collecting Information Again"
read -r -p "Path to ${bold}root${normal} partition: " root
read -r -p "Path to ${bold}swap${normal} partition: " swap
read -r -p "Path to ${bold}home${normal} partition [type in ${bold}exactly${normal} none if you want to mount]: " home
read -r -p "Path to your ${bold}ESP${normal} (EFI System Partition): " esp
read -r -p "Your ${bold}username${normal}: " username
read -r -p "The system's ${bold}hostname${normal}: " hostname
read -r -p "Would you like ${bold}NVIDIA${normal} support? Type in ${bold}exactly${normal} 'yes' or 'no', this script does not handle other inputs: " nvidia
echo
echo "${bold}You have chosen${normal}"
echo "${bold}Root${normal} ${root}"
echo "${bold}Swap${normal} ${swap}"
if [[ "$home" == "none" ]]; then
  echo "${bold}Home${normal} No separate home partition"
else
  echo "${bold}Home${normal} ${home}"
fi
echo "${bold}ESP${normal} ${esp}"
echo "${bold}Username${normal} ${username}"
echo "${bold}Hostname${normal} ${hostname}"
if [[ "$nvidia" == "yes" ]]; then
  echo "${bold}Graphics card${normal} NVIDIA"
else
  echo "${bold}Graphics card${normal} Intel"
fi
echo
read -r -p "Press ENTER if this information looks correct. Press CTRL+C to abort."
clear
echo "${bold}WARNING${normal}"
echo "Proceeding from this point on will result in ${bold}immediate${normal} system changes."
echo "This installer will format your partitions and attempt to install Arch Linux."
echo "Any malformed inputs earlier will result in a corrupted system / failure to properly install."
echo "I am not liable for any damage done to your system as a result of this script."
echo "This was made for me because I am lazy."
echo "${bold}PLEASE PRESS ENTER 7 TIMES TO CONTINUE INSTALLATION.${normal}"
read -r -p "[1/7] Press ENTER if you would like to install. Press CTRL+C to abort."
read -r -p "[2/7] Press ENTER if you would like to install. Press CTRL+C to abort."
read -r -p "[3/7] Press ENTER if you would like to install. Press CTRL+C to abort."
read -r -p "[4/7] Press ENTER if you would like to install. Press CTRL+C to abort."
read -r -p "[5/7] Press ENTER if you would like to install. Press CTRL+C to abort."
read -r -p "[6/7] Press ENTER if you would like to install. Press CTRL+C to abort."
read -r -p "[7/7] Press ENTER if you would like to install. Press CTRL+C to abort."
clear
echo

echo "${bold}[Stage 3, Part 2]${normal} Chroot Configuration"
echo "You will now be prompted to enter your ${bold}root${normal} password."
passwd
useradd -m -G wheel,systemd-journal -s /bin/bash ${username}
echo "You will now be prompted to enter your ${bold}user's${normal} password."
passwd ${username}
sed -i 's/^# %wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL/' /etc/sudoers
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
echo ${hostname} > /etc/hostname
echo -e "127.0.0.1\t${hostname}" >> /etc/hosts
read -r -p "What is your POSIX ${bold}timezone${normal}? (For example: PST is America/Los_Angeles): " timezone
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
hwclock --systohc --utc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
clear
echo "${bold}Stage 3${normal} complete!"
echo "Please download Stage 4 when you have rebooted to finish installation: "
echo "https://initializesahib.me/stage4.sh"
echo "Press ENTER to exit Stage 3."
read -r
