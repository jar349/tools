#!/bin/sh

# change this to the version that you want to install
# in order for this script to work, the version has to 
# exist as a tag or branch on git as "monodevelop-$MD_VER"
MD_VER=3.0.1

# the branch/tag that we will checkout to build and install
MD=monodevelop-$MD_VER

# this is the directory in which monodevelop will be installed
INSTALL_PREFIX=/usr/local

# the full path to monodevelop
INSTALL_DIR=$INSTALL_PREFIX/$MD

# this is the profile that drives how monodevelop gets built.
# possible values are 'stable', 'all', and 'core'
INSTALL_PROFILE=stable



#### DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ####

echo "\n-------==<( Installing Dependencies )>==-------"
sudo apt-get -y install git gtk-sharp2 mono-gmcs mono-devel libmono-addins-cil-dev libmono-addins-gui-cil-dev libmono-addins-msbuild-cil-dev gnome-sharp2

echo "\n-------==<( Downloading $MD from github )>==-------"
git clone git://github.com/mono/monodevelop.git
cd monodevelop

echo "\n-------==<( Switching to $MD Branch )>==-------"
git checkout $MD
git submodule init
git submodule update

echo "\n-------==<( Configuring Build Script )>==-------"
./configure --prefix=$INSTALL_DIR --profile=$INSTALL_PROFILE

echo "\n-------==<( Building MonoDevelop... )>==-------"
make

echo "\n-------==<( Installing MonoDevelop to $INSTALL_DIR )>==-------"
sudo make install

echo "\n-------==<( Adding a monodevelop script to $INSTALL_PREFIX )>==-------"
echo "#!/bin/sh\n\n$INSTALL_DIR/bin/monodevelop" >> $INSTALL_PREFIX/bin/monodevelop
chmod +x $INSTALL_PREFIX/bin/monodevelop

echo "\n-------==<( Adding Environment Variables to $HOME/.bashrc )>==-------"
echo "export XDG_DATA_HOME=\$XDG_DATA_HOME:$INSTALL_DIR/share" >> $HOME/.bashrc
echo "export XDG_DATA_DIRS=\$XDG_DATA_DIRS:$INSTALL_DIR/share" >> $HOME/.bashrc
chown $SUDO_USER:$SUDO_USER $HOME/.bashrc
source $HOME/.bashrc

echo "\n-------==<( Install Complete )>==-------"
echo "To start monodevelop, just type: monodevelop"
echo "It's up to you to create panel launchers and/or start menu entries."


