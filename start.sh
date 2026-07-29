#!/usr/bin/env bash

set -e

GREEN="\e[32m"
BLUE="\e[34m"
RESET="\e[0m"

ok() {
    echo -e "${GREEN}[OK]${RESET} $1"
}

info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}


if [[ $EUID -eq 0 ]]; then
    echo "Не запускай от root"
    exit 1
fi


info "Обновление системы"

sudo pacman -Syu --noconfirm


info "Установка пакетов"


sudo pacman -S --needed --noconfirm \
sway \
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
pipewire \
pipewire-pulse \
wireplumber \
pavucontrol \
pamixer \
playerctl \
brightnessctl \
networkmanager \
network-manager-applet \
openssh \
git \
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
fastfetch \
firefox \
ttf-jetbrains-mono-nerd \
noto-fonts \
noto-fonts-emoji


ok "Пакеты установлены"


# yay

if ! command -v yay &>/dev/null
then

info "Установка yay"

cd /tmp

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si --noconfirm

fi


# AUR

yay -S --needed --noconfirm \
bibata-cursor-theme-bin \
catppuccin-gtk-theme-mocha \
swaylock-effects


ok "AUR готов"


####################
# FISH
####################


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

alias update="sudo pacman -Syu"

alias c="clear"

alias ..="cd .."


alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"


fastfetch


EOF


chsh -s /usr/bin/fish


####################
# STARSHIP
####################


mkdir -p ~/.config


cat > ~/.config/starship.toml <<'EOF'

add_newline=false


format="""
$directory\
$git_branch\
$git_status\
$character
"""


[directory]

truncation_length=3


[character]

success_symbol="[❯](green)"
error_symbol="[❯](red)"

EOF



####################
# FOOT
####################


mkdir -p ~/.config/foot


cat > ~/.config/foot/foot.ini <<'EOF'

[main]

font=JetBrainsMono Nerd Font:size=11

pad=8x8


[colors]

alpha=0.92

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



####################
# FUZZEL
####################


mkdir -p ~/.config/fuzzel


cat > ~/.config/fuzzel/fuzzel.ini <<'EOF'

[main]

font=JetBrainsMono Nerd Font:size=11

width=40

lines=10

icons=yes


[colors]

background=1e1e2eee
text=cdd6f4ff
match=89b4faff
selection=89b4faff
selection-text=1e1e2eff

EOF



####################
# SWAY
####################


mkdir -p ~/.config/sway


cat > ~/.config/sway/config <<'EOF'


set $mod Mod4


font pango:JetBrainsMono Nerd Font 10


set $term foot


### приложения


bindsym $mod+Return exec foot

bindsym $mod+e exec thunar

bindsym $mod+d exec fuzzel


### закрытие

bindsym $mod+q kill


### fullscreen

bindsym $mod+f fullscreen toggle



### движение


bindsym $mod+h focus left

bindsym $mod+l focus right

bindsym $mod+j focus down

bindsym $mod+k focus up



### перемещение окон


bindsym $mod+Shift+h move left

bindsym $mod+Shift+l move right

bindsym $mod+Shift+j move down

bindsym $mod+Shift+k move up



### reload

bindsym $mod+Shift+c reload



### lock

bindsym $mod+l exec swaylock



### скриншот

bindsym Print exec grim -g "$(slurp)" ~/Pictures/screenshot.png



### звук


bindsym XF86AudioRaiseVolume exec pamixer -i 5

bindsym XF86AudioLowerVolume exec pamixer -d 5

bindsym XF86AudioMute exec pamixer -t



### яркость


bindsym XF86MonBrightnessUp exec brightnessctl set +10%

bindsym XF86MonBrightnessDown exec brightnessctl set 10%-



### запуск


exec_always waybar

exec mako

exec nm-applet


EOF



####################
# WAYBAR
####################


mkdir -p ~/.config/waybar


cat > ~/.config/waybar/config.jsonc <<'EOF'

{

"position":"top",

"height":30,


"modules-left":[
"sway/workspaces"
],


"modules-center":[
"clock"
],


"modules-right":[
"cpu",
"memory",
"pulseaudio",
"network",
"battery"
]


}

EOF



cat > ~/.config/waybar/style.css <<'EOF'

* {

font-family:
JetBrainsMono Nerd Font;

font-size:14px;

}


window#waybar {

background:#1e1e2e;

color:#cdd6f4;

}


EOF



####################
# SERVICES
####################


sudo systemctl enable NetworkManager

sudo systemctl enable sshd


ok "Готово"


echo "

================================

Установка завершена

Перезагрузи систему:

reboot

После входа выбери Sway

================================

"