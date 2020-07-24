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
cp -r .local/share/* ~/.local/share
cp -r .oh-my-zsh/themes/* ~/.oh-my-zsh/themes
cp -r .oh-my-zsh/lib/* ~/.oh-my-zsh/lib
cp .Xresources ~
cp .zprofile ~
cp .bash_profile ~
cp .profile ~

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
# clangd-10 sometimes crashes with lsp
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100

cd dunst
make
sudo make install

cd ../bspwm
make
sudo make install

cd ../dmenu
sudo make install

cd ../picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

cd ../polybar
mkdir build
cd build
cmake ../
make -j$(nproc)
sudo make install

cd ../../emacs
make -j$(nproc)
sudo make install
mkdir -p ~/.cache/emacs/saves

cd
git clone https://github.com/bndos/.emacs.d

sudo mv ~/.local/share/themes/Kripton /usr/share/themes/
sudo mv ~/.local/share/icons/FossaCursors /usr/share/icons
