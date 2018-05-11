

set -e

cd /tmp
wget https://linux.dropbox.com/packages/ubuntu/dropbox_2015.10.28_amd64.deb

sudo dpkg -i /tmp/dropbox_2015.10.28_amd64.deb

sudo apt update

dropbox start -i
