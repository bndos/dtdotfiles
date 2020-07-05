sudo apt update
sudo apt upgrade -y
xargs -a deps.txt sudo apt-get install -y
sudo pip3 install flashfocus
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
git clone --recursive https://github.com/polybar/polybar
git clone https://github.com/emacs-mirror/emacs.git

git clone https://github.com/bndos/dmenu
git clone https://github.com/bndos/dwm

sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt update
sudo apt install alacritty -y

cd dunst
sudo make install

cd ../bspwm
sudo make install

cd ../polybar
mkdir build
cd build
cmake ../
make -j$(nproc)
sudo make install

cd ../../emacs
make
sudo make install
