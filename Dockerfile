FROM debian:11.5

RUN apt-get update && \
    apt-get -y install gnupg jq ca-certificates cmake curl g++ gcc git libx11-dev libffi-dev libnss3-tools locales make libarchive-tools latexmk texlive-latex-recommended texlive-latex-extra\
    texlive texlive-xetex texlive-lang-european texlive-fonts-recommended texlive-fonts-extra netcat-traditional ruby ruby-dev sudo libsystemd-dev golang vim cups-ipp-utils && \
    curl 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | apt-key add - && \
    echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list && \
    echo 'deb http://deb.debian.org/debian bullseye-backports main' > /etc/apt/sources.list.d/stretch-backports.list && \
    apt-get update && \
    apt-get -y install google-chrome-unstable postgresql postgresql-contrib postgresql-server-dev-13 && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'fi_FI.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    ln -sf /usr/share/zoneinfo/Europe/Helsinki /etc/localtime && \
    sed -i 's/md5/trust/' /etc/postgresql/13/main/pg_hba.conf && \
    echo "TimeZone = 'Europe/Helsinki'" >> /etc/postgresql/13/main/postgresql.conf && \
    pg_ctlcluster 13 main start && \
    sudo -u postgres psql -c 'CREATE USER digabi WITH SUPERUSER;' && \
    pg_ctlcluster 13 main stop && \
    adduser --system --uid 1001 --shell /bin/bash digabi && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sudo -u digabi bash && \
    sudo -u digabi bash -c 'cd ; . ~/.nvm/nvm.sh; for v in 14.16.0 16.14.0; do nvm install $v; nvm exec $v npm install -g yarn; done' && \
    gem install fpm

# Install playwright based oni official playwright image
# https://github.com/microsoft/playwright/blob/main/utils/docker/Dockerfile.focal
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright-agent
RUN mkdir /ms-playwright-agent && \
    export PATH=$PATH:/home/digabi/.nvm/versions/node/v16.14.0/bin && \
    cd /ms-playwright-agent && npm init -y && \
    npm i playwright && \
    npx playwright install --with-deps && \
    rm -rf /ms-playwright-agent
