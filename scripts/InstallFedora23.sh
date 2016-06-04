useradd parsoj
usermod parsoj -a -G wheel
mkdir /home/parsoj/.ssh
chmod 755 /home/parsoj/.ssh
mkdir /home/parsoj/.ssh/authorized_keys
chmod 644 /home/parsoj/.ssh/authorized_keys
chown -R parsoj /home/parsoj

sudo dnf install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-23.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-23.noarch.rpm
dnf config-manager --add-repo=http://negativo17.org/repos/fedora-handbrake.repo
