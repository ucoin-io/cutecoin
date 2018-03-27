FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive

# Install french locales (can be changed but UTF-8 is need)
RUN apt-get update ; apt-get install -y locales
RUN sed -i 's/^# *\(fr_FR.UTF-8\)/\1/' /etc/locale.gen && locale-gen
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR
ENV LC_ALL fr_FR.UTF-8

# Install basic utils (vim for debug, can be removed)
RUN apt update ; apt install -y wget curl git vim
# Install python3 <3
RUN apt update ; apt install -y python3 python3-dev python3-pip build-essential

# Install libs 
RUN apt-get -y install libssl-dev libreadline6-dev libbz2-dev
RUN apt-get install -y libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 \
        libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev \
        libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0 \
        libxcb-render-util0-dev libxcb-glx0-dev libgl1-mesa-dri libegl1-mesa libpcre3 libgles2-mesa-dev \
        freeglut3-dev libfreetype6-dev xorg-dev xserver-xorg-input-void xserver-xorg-video-dummy xpra libosmesa6-dev \
        libdbus-1-dev libdbus-glib-1-dev autoconf automake libtool libgstreamer-plugins-base0.10-0 dunst fakeroot \
        dbus-x11
# On travis, inso used more up-to-date version
RUN apt-get -y install --no-install-recommends libsodium18 qtbase5-dev
# Needed by lrelease to create translation
RUN apt-get -y install --no-install-recommends qttools5-dev-tools qt5-default
# Install VNC (copied from  https://github.com/samgiles/docker-xvfb)
RUN apt-get  install -y xvfb x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps

ADD docker/xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ADD docker/xvfb_daemon_run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run

ENV DISPLAY :99

# Install python dev tools dependencies
RUN pip3 install --upgrade pip
RUN pip3 install coveralls
RUN pip3 install pytest-cov
RUN pip3 install pyinstaller==3.2
RUN pip3 install -U git+https://github.com/posborne/dbus-python.git
RUN pip3 install notify2
# Cache pyqt install (can be removed)
RUN pip3 install "PyQt5>=5.9,<5.10"

RUN mkdir /src
WORKDIR /src/
ADD . /src

# Install python dependencies (for sakia and the dev tools)
RUN pip3 install -r requirements.txt

CMD export; /etc/init.d/xvfb start && bash build.sh && python3 setup.py install && pytest --cov=sakia tests

