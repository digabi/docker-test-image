FROM debian:buster

RUN apt-get update && \
    apt-get -y install gnupg jq ca-certificates cmake curl g++ gcc git libx11-dev libffi-dev libnss3-tools locales make bsdtar latexmk texlive-latex-recommended texlive-latex-extra\
    texlive texlive-lang-european texlive-fonts-recommended texlive-fonts-extra netcat-traditional ruby ruby-dev sudo libsystemd-dev golang vim && \
    curl 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | apt-key add - && \
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list && \
    echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/stretch-backports.list && \
    apt-get update && \
    apt-get -y install google-chrome-unstable postgresql postgresql-contrib postgresql-server-dev-11 && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'fi_FI.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    ln -sf /usr/share/zoneinfo/Europe/Helsinki /etc/localtime && \
    sed -i 's/md5/trust/' /etc/postgresql/11/main/pg_hba.conf && \
    echo "TimeZone = 'Europe/Helsinki'" >> /etc/postgresql/11/main/postgresql.conf && \
    pg_ctlcluster 11 main start && \
    sudo -u postgres psql -c 'CREATE USER digabi WITH SUPERUSER;' && \
    pg_ctlcluster 11 main stop && \
    adduser --system --uid 1001 --shell /bin/bash digabi && \
    curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | sudo -u digabi bash && \
    sudo -u digabi bash -c 'cd ; . ~/.nvm/nvm.sh; for v in 14.16.0; do nvm install $v; nvm exec $v npm install -g yarn; done' && \
    gem install fpm
