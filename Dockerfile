FROM centos:6

# Install from YUM
RUN yum install -y wget perl libX11.i686 libXext.i686 libzip.i686

# Add zaurus user
RUN useradd zaurus
RUN mkdir /home/zaurus/packages
WORKDIR /home/zaurus/packages

# Copy host to guest
COPY packages/qtopia-free-1.5.0-1.i386.rpm /home/zaurus/packages
COPY packages/tmake-1.8.tar.gz /home/zaurus/packages
COPY packages/ipkg-build /usr/local/bin

# Download cross compile packages
RUN wget http://support.ezaurus.com/developer/tool/tools/gcc-cross-sa1100-2.95.2-0.i386.rpm
RUN wget http://support.ezaurus.com/developer/tool/tools/glibc-arm-2.2.2-0.i386.rpm
RUN wget http://support.ezaurus.com/developer/tool/tools/linux-headers-arm-sa1100-2.4.6-3.i386.rpm
RUN wget http://support.ezaurus.com/developer/tool/tools/binutils-cross-arm-2.11.2-0.i386.rpm
RUN wget http://support.ezaurus.com/developer/tool/tools/tmake-sharp.tar.gz
RUN wget http://support.ezaurus.com/developer/doc/reference/20021227/sharpsdk-pub-20021227.tar.gz
RUN wget http://support.ezaurus.com/developer/doc/reference/20030108/libqte.so.2.3.2.gz

# Install RPM
RUN rpm -i gcc-cross-sa1100-2.95.2-0.i386.rpm
RUN rpm -i glibc-arm-2.2.2-0.i386.rpm
RUN rpm -i linux-headers-arm-sa1100-2.4.6-3.i386.rpm
RUN rpm -i binutils-cross-arm-2.11.2-0.i386.rpm
RUN rpm -i qtopia-free-1.5.0-1.i386.rpm

# tmake-sharp
RUN mv /opt/Qtopia/tmake/lib/qws/linux-sharp-g++ /opt/Qtopia/tmake/lib/qws/linux-sharp-g++.original
RUN tar zxvf tmake-sharp.tar.gz
RUN mv linux-sharp-g++ /opt/Qtopia/tmake/lib/qws/

# sharp-sdk
WORKDIR /opt/Qtopia
RUN tar zxf /home/zaurus/packages/sharpsdk-pub-20021227.tar.gz

# libqte
WORKDIR /opt/Qtopia/sharp/lib
RUN gzip -d -c /home/zaurus/packages/libqte.so.2.3.2.gz > libqte.so.2.3.2

USER zaurus

# tmake-1.8
WORKDIR /home/zaurus
RUN tar zxf packages/tmake-1.8.tar.gz

# Environment
RUN echo "export PATH=$PATH:$HOME/tmake-1.8/bin:/opt/Embedix/tools/bin:/opt/Embedix/tools/arm-linux/bin" > .bashrc
RUN echo "export CC=arm-linux-gcc" >> .bashrc
RUN echo "export CXX=arm-linux-g++" >> .bashrc
RUN echo "export AR=arm-linux-ar" >> .bashrc
RUN echo "export RANLIB=arm-linux-ranlib" >> .bashrc
RUN /bin/bash -c "source /home/zaurus/.bashrc"
