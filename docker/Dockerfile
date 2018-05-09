# set author and base
FROM fedora
MAINTAINER  Madhu Rajanna <marajanna@redhat.com>

LABEL version="1"
LABEL description="Development build"

ADD ./setup.sh /setup.sh
ADD ./teardown.sh /teardown.sh
# let's setup all the necessary environment variables
ENV BUILD_HOME=/build
ENV GOPATH=$BUILD_HOME/golang
ENV GOBIN=$BUILD_HOME/golang/bin
ENV PATH=$GOPATH/bin:$PATH
#glusterd2 branch
ENV GD2_BRANCH="master"
#glusterfs branch
ENV GLUSTERFS_BRANCH="master"
ENV GLUSTER_PATH=$BUILD_HOME/gluster

RUN yum  install -y lvm2* systemd-udev dbus-python nfs-utils attr iputils iproute openssh-server openssh-clients cronie tar rsync sos sudo xfsprogs && \
    sed -i.save -e "s#udev_sync = 1#udev_sync = 0#" -e "s#udev_rules = 1#udev_rules = 0#" -e "s#use_lvmetad = 1#use_lvmetad = 0#" /etc/lvm/lvm.conf && \
    systemctl mask getty.target && \
    systemctl disable systemd-udev-trigger.service && \
    systemctl disable systemd-udevd.service && \
systemctl disable nfs-server.service
VOLUME [ "/sys/fs/cgroup" ]

#glusterd2
RUN chmod +x /setup.sh && /setup.sh &&\
    mkdir $BUILD_HOME $GOPATH $GOBIN && \
    mkdir -p  /etc/glusterd2 $GOPATH/src/github.com/gluster && \
    cd $GOPATH/src/github.com/gluster && \
    git clone -b $GD2_BRANCH https://github.com/gluster/glusterd2.git && \
    cd $GOPATH/src/github.com/gluster/glusterd2 && \
    ./scripts/install-reqs.sh && make  && \
    cp build/glusterd2 /usr/bin/glusterd2 && \
    cp build/glustercli /usr/bin/glustercli &&\
    cp glusterd2.toml.example /etc/glusterd2/glusterd2.toml &&\
    chmod +x /teardown.sh && /teardown.sh &&\
    cd && rm -rf $GOPATH

#glusterfs
RUN mkdir $GLUSTER_PATH  &&\
    yum install -y automake autoconf userspace-rcu\
    libtool flex bison openssl-devel \
    libxml2-devel python-devel \
    libaio-devel libibverbs-devel \
    librdmacm-devel readline-devel \
    lvm2-devel glib2-devel userspace-rcu-devel \
    libcmocka-devel libacl-devel sqlite-devel \
    fuse-devel redhat-rpm-config &&\
    cd $GLUSTER_PATH &&\
    git clone -b $GLUSTERFS_BRANCH https://github.com/gluster/glusterfs.git && \ 
    cd $GLUSTER_PATH/glusterfs &&\
    ./autogen.sh && \
    ./configure \
    --prefix=/usr \
    --exec-prefix=/usr \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --sysconfdir=/etc \
    --datadir=/usr/share \
    --includedir=/usr/include \
    --libdir=/usr/lib64 \
    --libexecdir=/usr/libexec \
    --localstatedir=/var \
    --sharedstatedir=/var/lib \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info \
    --libdir=/usr/lib64 \
    --enable-cmocka \
    --enable-debug && \
    make  && \
    make install &&\
    cd && rm -rf $GLUSTER_PATH &&\
    cd && rm -rf $BUILD_HOME && \
    yum -y remove git make &&\
    yum -y autoremove && \
    yum -y clean all

#TODO need to remove glusterfs dependencies
#TODO need to remove  curl 

#TODO Expose PORT required by services

ENTRYPOINT [ "/usr/bin/glusterd2" ]