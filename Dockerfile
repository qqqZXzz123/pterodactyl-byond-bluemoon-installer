FROM beestation/byond:latest

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y libmariadb3 libmariadbclient-dev libmariadb-dev mariadb-client \
    && useradd -d /home/container -m container \
    && pwd

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
