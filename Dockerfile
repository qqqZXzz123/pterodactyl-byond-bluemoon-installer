#based on /tg/station byond image

FROM i386/ubuntu:bionic

ENV BYOND_MAJOR=514 \
    BYOND_MINOR=1583

ENV         DEBIAN_FRONTEND=noninteractive



RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    nano \
    curl \
    unzip \
    zip \
    make \
    libstdc++6 \
    tzdata \
    ca-certificates \
    openjdk-8-jre \
    locales \
    git \
##  mariadb client not work well
#   libmariadb-client-lgpl-dev \
    libmysqlclient-dev \
    python3 \
    python3-pip \
    gnupg \
    build-essential \
    iproute2 \
    && curl --silent --location https://deb.nodesource.com/setup_16.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y nodejs yarn \
    && node -v


RUN curl "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip \
    && unzip byond.zip \
    && cd byond \
    && sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile \
    && make install \
    && chmod 644 /usr/local/byond/man/man6/* \
    && cd .. \
    && rm -rf byond byond.zip /var/lib/apt/lists/*

RUN locale-gen ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.UTF-8

ENV TERM=xterm

#timezone fix
ENV TZ=Europe/Moscow
RUN ln -fs /usr/share/zoneinfo/US/Pacific-New /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

#python packages
#RUN pip3 install requests Pillow
RUN pip3 install --upgrade pip
RUN pip3 install requests Pillow
