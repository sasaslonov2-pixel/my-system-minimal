#!/usr/bin/env bash

set -e

# ==========================================
# CachyOS + Sway + Fish Setup
# AMD Laptop Edition
# ==========================================

GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

ok() {
    echo -e "${GREEN}[OK]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}


if [[ $EUID -eq 0 ]]; then
    error "Запусти скрипт без sudo"
    exit 1
fi


if ! command -v pacman &>/dev/null; then
    error "Это не Arch/CachyOS система"
    exit 1
fi


echo "
========================================
 CachyOS Sway Installer
 AMD Laptop + Wayland Setup
========================================
"


# -------------------------------
# SYSTEM UPDATE
# -------------------------------

info "Обновление системы"

sudo pacman -Syu --noconfirm


# -------------------------------
# PACKAGES
# -------------------------------

info "Установка пакетов"


sudo pacman -S --needed --noconfirm \
sway \
swayidle \
swaylock \
waybar \
foot \
fish \
starship \
fuzzel \
mako \
grim \
slurp \
swappy \
wl-clipboard \
xdg-desktop-portal-wlr \
xdg-desktop-portal-gtk \
polkit-gnome \
pipewire \
pipewire-pulse \
wireplumber \
pavucontrol \
pamixer \
playerctl \
brightnessctl \
networkmanager \
network-manager-applet \
bluez \
bluez-utils \
blueman \
openssh \
git \
base-devel \
stow \
lsd \
bat \
btop \
zoxide \
fzf \
fd \
ripgrep \
lazygit \
superfile \
yazi \
thunar \
gvfs \
gvfs-mtp \
file-roller \
fastfetch \
dust \
duf \
ncdu \
mesa \
vulkan-radeon \
libva-mesa-driver \
libva-utils \
tlp \
zram-generator \
ttf-jetbrains-mono-nerd \
noto-fonts \
noto-fonts-emoji


ok "Основные пакеты установлены"


# -------------------------------
# YAY
# -------------------------------

if ! command -v yay &>/dev/null
then

    info "Установка yay"

    cd /tmp

    git clone https://aur.archlinux.org/yay.git

    cd yay

    makepkg -si --noconfirm

fi


info "Установка AUR пакетов"


yay -S --needed --noconfirm \
bibata-cursor-theme-bin \
catppuccin-gtk-theme-mocha \
swaylock-effects


ok "AUR готов"


# -------------------------------
# BACKUP CONFIGS
# -------------------------------

backup_file() {

if [ -e "$1" ]; then
    mv "$1" "$1.backup"
fi

}


mkdir -p ~/.config


backup_file ~/.config/fish
backup_file ~/.config/sway
backup_file ~/.config/foot
backup_file ~/.config/waybar
backup_file ~/.config/fuzzel
backup_file ~/.config/mako


# -------------------------------
# FISH
# -------------------------------


info "Настройка Fish"


mkdir -p ~/.config/fish


cat > ~/.config/fish/config.fish <<'EOF'

set -U fish_greeting


starship init fish | source

zoxide init fish | source

fzf --fish | source


alias ls="lsd"

alias ll="lsd -lah"

alias la="lsd -a"


alias cat="bat"

alias grep="rg"

alias find="fd"


alias top="btop"


alias lg="lazygit"

alias sf="superfile"

alias y="yazi"


alias du="dust"

alias df="duf"


alias ff="fastfetch"


alias update="sudo pacman -Syu"


alias c="clear"


alias ..="cd .."


alias gs="git status"

alias ga="git add"

alias gc="git commit"

alias gp="git push"


EOF


chsh -s /usr/bin/fish


ok "Fish настроен"



# -------------------------------
# STARSHIP
# -------------------------------


info "Настройка Starship"


mkdir -p ~/.config


cat > ~/.config/starship.toml <<'EOF'

add_newline = false


format = """
$directory\
$git_branch\
$git_status\
$character
"""


[directory]

truncation_length = 3


[git_branch]

symbol = " "


[character]

success_symbol = "[❯](green)"

error_symbol = "[❯](red)"


EOF


ok "Starship готов"



# -------------------------------
# FOOT
# -------------------------------


info "Настройка Foot"


mkdir -p ~/.config/foot


cat > ~/.config/foot/foot.ini <<'EOF'

[main]

font=JetBrainsMono Nerd Font:size=11

pad=8x8

scrollback-lines=10000


[colors]

alpha=0.90

background=1e1e2e

foreground=cdd6f4


regular0=45475a
regular1=f38ba8
regular2=a6e3a1
regular3=f9e2af
regular4=89b4fa
regular5=f5c2e7
regular6=94e2d5
regular7=bac2de


[cursor]

style=beam

blink=yes


EOF


ok "Foot готов"
# -------------------------------
# FUZZEL
# -------------------------------

info "Настройка Fuzzel"


mkdir -p ~/.config/fuzzel


cat > ~/.config/fuzzel/fuzzel.ini <<'EOF'

[main]

font=JetBrainsMono Nerd Font:size=11

width=45

lines=12

icons=yes

terminal=foot


[colors]

background=1e1e2eee

text=cdd6f4ff

match=89b4faff

selection=89b4faff

selection-text=1e1e2eff

border=89b4faff


[border]

width=2

radius=12


EOF


ok "Fuzzel готов"



# -------------------------------
# MAKO
# -------------------------------


info "Настройка Mako"


mkdir -p ~/.config/mako


cat > ~/.config/mako/config <<'EOF'

font=JetBrainsMono Nerd Font 11

background-color=#1e1e2e

text-color=#cdd6f4

border-color=#89b4fa

border-size=2

border-radius=10

default-timeout=5000

anchor=top-right

margin=15


EOF


ok "Mako готов"



# -------------------------------
# SWAY
# -------------------------------


info "Настройка Sway"


mkdir -p ~/.config/sway


cat > ~/.config/sway/config <<'EOF'


#############################
# VARIABLES
#############################


set $mod Mod4


set $term foot


set $menu fuzzel


font pango:JetBrainsMono Nerd Font 10



#############################
# AUTOSTART
#############################


exec_always waybar

exec mako

exec nm-applet

exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1


#############################
# COLORS
#############################


client.focused          #89b4fa #1e1e2e #cdd6f4 #89b4fa

client.unfocused        #313244 #1e1e2e #a6adc8 #313244



#############################
# TERMINAL / APPS
#############################


bindsym $mod+Return exec $term


bindsym $mod+e exec thunar


bindsym $mod+d exec $menu



#############################
# WINDOWS
#############################


bindsym $mod+q kill


bindsym $mod+f fullscreen toggle



#############################
# MOVEMENT
#############################


bindsym $mod+h focus left

bindsym $mod+l focus right

bindsym $mod+j focus down

bindsym $mod+k focus up



#############################
# MOVE WINDOWS
#############################


bindsym $mod+Shift+h move left

bindsym $mod+Shift+l move right

bindsym $mod+Shift+j move down

bindsym $mod+Shift+k move up



#############################
# WORKSPACES
#############################


bindsym $mod+1 workspace number 1

bindsym $mod+2 workspace number 2

bindsym $mod+3 workspace number 3

bindsym $mod+4 workspace number 4

bindsym $mod+5 workspace number 5

bindsym $mod+6 workspace number 6

bindsym $mod+7 workspace number 7

bindsym $mod+8 workspace number 8

bindsym $mod+9 workspace number 9



bindsym $mod+Shift+1 move container to workspace number 1

bindsym $mod+Shift+2 move container to workspace number 2

bindsym $mod+Shift+3 move container to workspace number 3



#############################
# SYSTEM
#############################


bindsym $mod+Shift+c reload


bindsym $mod+Shift+r restart



bindsym $mod+Shift+e exec swaymsg exit



#############################
# LOCK
#############################


bindsym $mod+Shift+l exec swaylock \
--clock \
--indicator \
--effect-blur 7x5 \
--color 1e1e2e



#############################
# SCREENSHOT
#############################


bindsym Print exec grim -g "$(slurp)" ~/Pictures/screenshot.png


bindsym $mod+Print exec grim ~/Pictures/fullscreen.png



#############################
# AUDIO
#############################


bindsym XF86AudioRaiseVolume exec pamixer -i 5


bindsym XF86AudioLowerVolume exec pamixer -d 5


bindsym XF86AudioMute exec pamixer -t



#############################
# BRIGHTNESS
#############################


bindsym XF86MonBrightnessUp exec brightnessctl set +10%


bindsym XF86MonBrightnessDown exec brightnessctl set 10%-



#############################
# LAPTOP SETTINGS
#############################


output * bg ~/Pictures/wallpaper.png fill



#############################
# FLOATING WINDOWS
#############################


for_window [app_id="pavucontrol"] floating enable

for_window [class="blueman-manager"] floating enable


EOF


ok "Sway готов"



# -------------------------------
# WAYBAR
# -------------------------------


info "Настройка Waybar"


mkdir -p ~/.config/waybar


cat > ~/.config/waybar/config.jsonc <<'EOF'

{

"layer":"top",

"position":"top",

"height":32,


"modules-left":[
"sway/workspaces"
],


"modules-center":[
"clock"
],


"modules-right":[
"cpu",
"memory",
"temperature",
"network",
"pulseaudio",
"battery"
],


"clock":{
"format":"  {:%H:%M}"
},


"cpu":{
"format":" {usage}%"
},


"memory":{
"format":" {}%"
},


"temperature":{
"format":" {temperatureC}°C"
},


"network":{
"format-wifi":" {essid}"
},


"battery":{
"format":" {capacity}%"
}


}

EOF



cat > ~/.config/waybar/style.css <<'EOF'


* {

font-family: JetBrainsMono Nerd Font;

font-size:14px;

}


window#waybar {

background:#1e1e2e;

color:#cdd6f4;

border-radius:10px;

}


#workspaces button {

color:#cdd6f4;

padding:0 8px;

}


#workspaces button.focused {

background:#89b4fa;

color:#1e1e2e;

border-radius:8px;

}


#clock,
#cpu,
#memory,
#temperature,
#network,
#pulseaudio,
#battery {

padding:0 10px;

}


EOF


ok "Waybar готов"
# -------------------------------
# ZRAM
# -------------------------------

info "Настройка ZRAM"


sudo mkdir -p /etc/systemd


sudo tee /etc/systemd/zram-generator.conf > /dev/null <<'EOF'

[zram0]

zram-size = ram

compression-algorithm = zstd

EOF


ok "ZRAM настроен"



# -------------------------------
# TLP POWER MANAGEMENT
# -------------------------------


info "Настройка энергосбережения"


sudo systemctl enable tlp.service


ok "TLP включен"



# -------------------------------
# NETWORK / BLUETOOTH / SSH
# -------------------------------


info "Включение сервисов"


sudo systemctl enable NetworkManager.service

sudo systemctl enable bluetooth.service

sudo systemctl enable sshd.service



ok "Сервисы включены"



# -------------------------------
# SSH CONFIG
# -------------------------------


info "Создание SSH настроек"


mkdir -p ~/.ssh


chmod 700 ~/.ssh


if [ ! -f ~/.ssh/config ]; then

cat > ~/.ssh/config <<'EOF'

Host *

    ServerAliveInterval 60

    ServerAliveCountMax 3

    Compression yes

    ForwardAgent no


EOF


chmod 600 ~/.ssh/config

fi


ok "SSH настроен"



# -------------------------------
# USER DIRECTORIES
# -------------------------------


info "Создание папок"


mkdir -p ~/Pictures

mkdir -p ~/Pictures/Screenshots



# -------------------------------
# GTK THEME
# -------------------------------


info "Настройка GTK"


mkdir -p ~/.config/gtk-3.0


cat > ~/.config/gtk-3.0/settings.ini <<'EOF'


[Settings]

gtk-theme-name=Catppuccin-Mocha-Standard-Mauve-Dark

gtk-icon-theme-name=Papirus-Dark

gtk-font-name=JetBrainsMono Nerd Font 10

gtk-cursor-theme-name=Bibata-Modern-Ice


EOF



# -------------------------------
# FASTFETCH
# -------------------------------


mkdir -p ~/.config/fastfetch


cat > ~/.config/fastfetch/config.jsonc <<'EOF'

{

"display": {

"separator": " "

},


"modules": [

"title",

"os",

"kernel",

"wm",

"shell",

"cpu",

"gpu",

"memory",

"disk",

"uptime"

]


}

EOF



# -------------------------------
# DEFAULT WALLPAPER PLACEHOLDER
# -------------------------------


if [ ! -f ~/Pictures/wallpaper.png ]; then

    echo "Положи свой wallpaper.png в ~/Pictures/"

fi



# -------------------------------
# FISH PLUGINS
# -------------------------------


info "Установка Fisher"


fish -c '

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source

and fisher install jorgebucaran/fisher

'


fish -c '

fisher install PatrickF1/fzf.fish

fisher install jorgebucaran/autopair.fish

'


ok "Fish плагины установлены"



# -------------------------------
# FINAL CHECK
# -------------------------------


echo "

========================================

 ГОТОВО

 Перезагрузи систему:

 reboot


После входа:

1. Выбери Sway в экранном менеджере

2. Mod + Enter  → терминал

3. Mod + D      → приложения

4. Mod + E      → файлы

5. Mod + H/J/K/L → управление окнами


Установлены:

✓ Sway
✓ Waybar
✓ Foot
✓ Fish
✓ Starship
✓ Fuzzel
✓ Mako
✓ PipeWire
✓ Bluetooth
✓ SSH
✓ ZRAM
✓ TLP
✓ AMD Vulkan
✓ CLI tools


========================================

"


exit 0