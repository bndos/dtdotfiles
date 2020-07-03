sudo apt update
sudo apt upgrade -y
xargs -a deps.txt sudo apt-get install -y
mkdir -p ~/Downloads/clones ~/Downloads/programs

cd ~/Downloads/clones
git clone https://github.com/bndos/dtdotfiles
cd dtdotfiles
cp .zshrc ~
cp -r .config/* ~/.config
cp -r bin/ ~
cp -r Pictures/* ~/Pictures

cd ~/Downloads/programs
git clone https://github.com/dunst-project/dunst.git
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/alacritty/alacritty.git
git clone https://github.com/sdhand/picom.git
git clone https://github.com/polybar/polybar.git
git clone https://github.com/emacs-mirror/emacs.git

git clone https://github.com/bndos/dmenu
git clone https://github.com/bndos/dwm
