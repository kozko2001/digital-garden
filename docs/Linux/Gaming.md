# Gamin in Linux using Lutris

Gaming in Linux is way better than was before, I would say is easier to be a gamer
in a linux machine than in desktop right now.

Lutris is a front-end to use different systems like wine-ge to help you run the games in linux

## Installation (in arch)

- Enable multilib in arch and reboot
  - `sudo nvim /etc/pacman.conf`
  - uncomment the `[multilib]` section
  - `sudo pacman -Syu` to update the system
  - `sudo reboot` -- cause Why not?

- [Install dependencies](https://github.com/lutris/docs/blob/master/WineDependencies.md)
```bash
sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
```
- [Install drivers](https://github.com/lutris/docs/blob/master/InstallingDrivers.md)
    ```bash
    sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
    ```
- Start lutris 
- Let's imagine we want to play Diablo II
  - Find battlenet as a game in lutris
  - Use battlenet to install diablo II