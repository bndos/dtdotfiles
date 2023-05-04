sudo apt update
sudo apt upgrade -y
xargs -a deps.txt sudo apt-get install -y
sudo pip3 install flashfocus

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mkdir -p ~/Downloads/clones ~/Downloads/programs

sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret
git config --global credential.helper \
   /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

cd ~/Downloads/clones
git clone https://github.com/bndos/dtdotfiles
cd dtdotfiles
sudo cp xmonad.desktop /usr/share/xsessions/
cp .zshrc ~
cp -r .config/* ~/.config
cp -r bin/ ~
cp -r Pictures/* ~/Pictures
cp -r .local/share/* ~/.local/share
cp -r .oh-my-zsh/themes/* ~/.oh-my-zsh/themes
cp -r .oh-my-zsh/lib/* ~/.oh-my-zsh/lib
cp -r .xmonad ~
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
git clone https://github.com/bndos/st

sudo apt update
# clangd-10 sometimes crashes with lsp
# sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100

cd dunst
make
sudo make install

cd ../st
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
g checkout emacs-28.2
make -j$(nproc)
sudo make install
mkdir -p ~/.cache/emacs/saves

cd
git clone https://github.com/bndos/.doom.d
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
~/.emacs.d/bin/doom sync
cp ~/Downloads/clones/dtdotfiles/bookmarks ~/.emacs.d/.local/etc

git config --global user.email "grover-brando.tovar-oblitas@polymtl.ca"
git config --global user.name "Brando"

sudo mv ~/.local/share/themes/Kripton /usr/share/themes/
sudo mv ~/.local/share/icons/FossaCursors /usr/share/icons

# go language server that works with emacs
mkdir go
go get golang.org/x/tools/gopls
cd ~/.oh-my-zsh/themes/
git clone https://github.com/romkatv/powerlevel10k.git

sudo npm install -g typescript tslint-config-prettier tslint-plugin-prettier tslint prettier
