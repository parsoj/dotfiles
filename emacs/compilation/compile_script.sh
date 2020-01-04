

export LIBXML2_CFLAGS=`xml2-config --cflags`
export LIBXML2_LIBS=`xml2-config --libs`
export PATH=$PATH:/usr/local/Cellar/gnutls/3.6.10/bin/
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
export PATH="/usr/local/opt/texinfo/bin:$PATH"


./autogen.sh 

./configure \
--disable-dependency-tracking \
--without-x \
--with-json \
--with-harfbuzz \
--with-ns --disable-ns-self-contained

sudo make clean
sudo make
sudo make install
